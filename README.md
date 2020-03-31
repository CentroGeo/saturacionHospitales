
Modelo de Atención de Hospitales 
========================================
## ETAPA 1: GENERAR CLUSTERS DE HOSPITALES 

### CLUSTERS HOSPITALES

``` sql
SELECT
id,
st_union(geom) geom
FROM (
    SELECT
    ST_ClusterKMeans(geom, 5) OVER () id,
    geom
    FROM pandemic.infraestructura
    ) kmeans GROUP BY id;
```
### CENTROIDES CLUSTERS
``` sql
CREATE TABLE pandemic.cluster_centroid AS
SELECT
id,
st_centroid(st_union(geom)) AS geom
FROM (
    SELECT
    ST_ClusterKMeans(geom, 5) OVER () id,
    geom
    FROM pandemic.infraestructura
    ) kmeans GROUP BY id
```
### NODO MAS CERCADO DE LA RED AL CENTROIDE DEL CLUSTER
``` sql
alter table pandemic.cluster_centroid add column closest_node bigint; 
update pandemic.cluster_centroid set closest_node = c.closest_node
from  
(select b.id as id_centroid, (
  SELECT a.id
  FROM network.ways_vertices_pgr As a
  ORDER BY b.geom <-> a.the_geom LIMIT 1
)as closest_node
from  pandemic.cluster_centroid b) as c
where c.id_centroid = pandemic.cluster_centroid.id
```
## ETAPA 2: REGIONALIZACIÓN CON BASE EN CONECTIVIDAD 

#### NODOS CON MAYOR CONECTIVIDAD
* Calcular Medidas de centralidad de red
``` sql
SELECT  pgr_analyzeGraph('network.ways', .1 ,'the_geom','gid','source','target');
```
* Usar nodos con mayor centralidad para asignarlos a los centroides de los clusters
``` sql
CREATE TABLE pandemic.regiones_vertex AS 
SELECT b.the_geom, a.*
FROM
(SELECT DISTINCT ON (start_vid)
       start_vid, end_vid, agg_cost
FROM   (SELECT * FROM pgr_dijkstraCost(
    'select gid as id, source, target, timetravel as cost from network.ways',
    array(select distinct(id) from (select * from network.ways_vertices_pgr where cnt > 2) as net ), --destino 
	array(select distinct(closest_node) from cluster_centroid), --origen
directed:=false)
) as sub
ORDER  BY start_vid, agg_cost asc) as a
JOIN network.ways_vertices_pgr b
ON a.start_vid = b.id
```
__NOTA:De la tabla resultante la columna start_vid pertenece a los nodos de la red y end_vid los nodos del centroide de los clusters para tener, cambiar los nombres a net_node y centroid_node respectivamente

* Generar polígonos por grupo de puntos asignados a caga centroide
``` sql
create table pandemic.regiones_vertex_pol as
SELECT d.centroid_node as centroid_region,
	ST_ConvexHull(ST_Collect(d.the_geom)) As the_geom
	FROM pandemic.regiones_5clust_ As d
	GROUP BY d.centroid_node;  
```
* Cambiar los id's de las regiones
``` sql
alter table pandemic.regiones_vertex_pol add column id_region int;
update pandemic.regiones_vertex_pol set id_region =
  case
    when centroid_region = 165441 then 1
	when centroid_region = 83310 then 2
	when centroid_region = 159494 then 3
	when centroid_region = 60371 then 4
	when centroid_region = 447 then 5
    else null
  end;
```
#### AGEBS URBANAS 
``` sql
alter table pandemic.covid_pob_ageb_urbana add column closest_node bigint; 
update pandemic.covid_pob_ageb_urbana set closest_node = c.closest_node
from  
(select b.tid as id_pob, (
  SELECT a.id
  FROM network.ways_vertices_pgr As a
  ORDER BY b.geom <-> a.the_geom LIMIT 1
)as closest_node
from  pandemic.covid_pob_ageb_urbana b) as c
where c.id_pob = pandemic.covid_pob_ageb_urbana.tid
``` 
``` sql
CREATE TABLE pancemic.regiones_agebs AS 
SELECT b.the_geom, a.*
FROM
(SELECT DISTINCT ON (start_vid)
       start_vid, end_vid, agg_cost
FROM   (SELECT * FROM pgr_dijkstraCost(
    'select gid as id, source, target, timetravel as cost from network.ways',
    array(select distinct(id) from pandemic.covid_pob_ageb_urbana), --destino 
	array(select distinct(closest_node) from pandemic.cluster_centroid), --origen
directed:=false)
) as sub
ORDER  BY start_vid, agg_cost asc) as a
JOIN network.ways_vertices_pgr b
ON a.start_vid = b.id
```
* Generar polígonos por grupo de puntos asignados a caga centroide
``` sql
create table pancemic.regiones_agebs_pol as
SELECT d.centroid_node as centroid_region,
	ST_ConvexHull(ST_Collect(d.the_geom)) As the_geom
	FROM pandemic.regiones_5clust_ As d
	GROUP BY d.centroid_node;  
```
* Cambiar los id's de las regiones
``` sql
alter table pandemic.regiones_agebs_pol add column id_region int;
update pandemic.regiones_agebs_pol set id_region =
  case
    when centroid_region = 165441 then 1
	when centroid_region = 83310 then 2
	when centroid_region = 159494 then 3
	when centroid_region = 60371 then 4
	when centroid_region = 447 then 5
    else null
  end;
```
## ETAPA 3: CALCULO DE POBLACIÓN VULNERABLE, INFECTADOS, RECUPERADOS Y MUERTES POR REGIÓN

Se tomaron como base las estadísticas de infección por COVID-19 de Nueva York, ya que la dinámica poblacional y el número de habitantes es muy parecido a la Ciudad de México y se encontraron los porcentajes de infección por rangos de edad. 

    Rango de Edad| Porcentaje de Infectados
    --------------------- | ---------------------
     0 a 14 años | 2%
    15 a 49 años | 46%
    45 a 69 años | 33%
    desconocido  | 9%

* __Número total de infectados:__ 786 228
* __Número total de recuperados:__ 166 041 (%22)
* __Número total de muertes:__ 37 820 (5%)

* FILTADO DE LOS DATOS DEL CENSO 2010 CON BASE EN LOS RANGOS DE EDAD ESTABLECIDOS Y ASIGANACIÓN DEL ID DE LA REGIÓN A LA QUE PERTENECE
```sql
--- Población de 50 años hasta mayores de 60
ALTER TABLE pandemic.covid_pob_ageb_urbana add column pobVul_50mayor60 int4;
update pandemic.covid_pob_ageb_urbana set pobVul_50mayor60 = pob_50a59 + pob_masd60

---Agregar el id de region a los datos de AGEBS 
ALTER TABLE pandemic.covid_pob_ageb_urbana ADD COLUMN id_region int;
update pandemic.covid_pob_ageb_urbana ps 
set id_region = nb.id_region
from pandemic.#REGION_AQUI# nb 
where st_intersects(nb.the_geom, ps.geom);

---Agregar id de región a los hospitales 
ALTER TABLE pandemic.infraestructura ADD COLUMN id_region INT;
update pandemic.infraestructura ps 
set id_region = nb.id_region
from pandemic.#REGION_AQUI# nb 
where st_intersects(nb.the_geom, ps.geom);

-- Tabla de datos agregados por región
CREATE TABLE pandemic.covid_pobvul_regiones AS
SELECT a.*, b.total_camas, b.hospitales, b.respiradores  
FROM
    (Select id_region, sum(camas_covid) as total_camas, 
    count(*)  as hospitales,
    sum(ventiladores_covid) as respiradores
FROM pandemic.infraestructura 
WHERE region is not null 
GROUP BY id_region) AS b
JOIN 
(SELECT a.the_geom, pob.*
FROM
(Select id_region, sum(poblacion_total) as pob_total, 
sum(pobvul_50mayor60) as pobvul_50mayor60,
sum(pob_30a49) as pobvul_30a49,
sum(pob_15a29) as pobvul_15a29,
sum(pob_0a14) as pobvul_0a14  
from pandemic.covid_pob_ageb_urbana 
where id_region is not null 
group by id_region) AS pob
JOIN pandemic.centroid_region a 
ON pob.id_region = a.id_region) a
ON a.id_region = b.id_region 

---Población infectada por rangos de edad
ALTER TABLE pandemic.covid_pobvul_regiones ADD COLUMN pobinf_50mayor60 INT; 
ALTER TABLE pandemic.covid_pobvul_regiones ADD COLUMN pobinf_30a49 INT; 
ALTER TABLE pandemic.covid_pobvul_regiones ADD COLUMN pobinf_15a29 INT; 
ALTER TABLE pandemic.covid_pobvul_regiones ADD COLUMN pobinf_0a14 INT; 
---Se calculó el total de hospitalizados con base en el porcentaje actual de hospitalizaciones en el país
ALTER TABLE pandemic.covid_pobvul_regiones ADD COLUMN total_hospitalizados INT;
---Total de infectados 
ALTER TABLE pandemic.covid_pobvul_regiones ADD COLUMN total_infectados INT;
ALTER TABLE pandemic.covid_pobvul_regiones ADD COLUMN total_muertos INT;
ALTER TABLE pandemic.covid_pobvul_regiones ADD COLUMN total_recuperados INT;

UPDATE pandemic.covid_pobvul_regiones SET  pobinf_50mayor60 = pobvul_50mayor60*0.19;
UPDATE pandemic.covid_pobvul_regiones SET pobinf_30a49 = pobvul_30a49*0.33;
UPDATE pandemic.covid_pobvul_regiones SET pobinf_15a29 = pobvul_15a29*0.46;
UPDATE pandemic.covid_pobvul_regiones SET pobinf_0a14 = pobvul_0a14*0.02;
UPDATE pandemic.covid_pobvul_regiones SET total_hospitalizados = (pobinf_30a49 + pobinf_50mayor60) *0.16;
UPDATE pandemic.covid_pobvul_regiones SET  total_infectados = pobinf_50mayor60 + pobinf_30a49 + pobinf_15a29 + pobinf_0a14
UPDATE pandemic.covid_pobvul_regiones SET total_muertos = total_infectados*0.05;
UPDATE pandemic.covid_pobvul_regiones SET total_recuperados = total_infectados*0.21;
``` 







 
 


