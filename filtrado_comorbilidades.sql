DROP TABLE IF EXISTS aria.covid_cdmx_prob;
CREATE TABLE aria.covid_cdmx_prob as
SELECT c.*
FROM
(SELECT a.*, 
	   b.pob57 as pobmasctot_2010,
	   b.pob31 as pobfemtot_2010
FROM
(SELECT st_centroid(b.municipio_geom_4326) as geom, b.entidad_cvegeo, b.municipio_cvegeo, a.*
FROM
(SELECT 
		municipio_res_concat, 
		SUM (CASE WHEN sexo = '2' and edad::int < 5  and resultado = '1'  THEN 1 ELSE 0 END) AS masc_edadmenos_5,
		SUM (CASE WHEN sexo = '1' and edad::int < 5  and resultado = '1'  THEN 1 ELSE 0 END) AS fem_edadmenos_5,
		
		SUM (CASE WHEN sexo = '2' and edad::int < 5  and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS masc_edadmenos_5_neumo,
		SUM (CASE WHEN sexo = '1' and edad::int < 5  and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS fem_edadmenos_5_neumo,
		
		SUM (CASE WHEN sexo = '2' and edad::int < 5  and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS masc_edadmenos_5_diab,
		SUM (CASE WHEN sexo = '1' and edad::int < 5  and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS fem_edadmenos_5_diab,
		
		SUM (CASE WHEN sexo = '2' and edad::int < 5  and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS masc_edadmenos_5_epoc,
		SUM (CASE WHEN sexo = '1' and edad::int < 5  and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS fem_edadmenos_5_epoc,
		
		SUM (CASE WHEN sexo = '2' and edad::int < 5  and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS masc_edadmenos_5_asma,
		SUM (CASE WHEN sexo = '1' and edad::int < 5  and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS fem_edadmenos_5_asma,
		
		SUM (CASE WHEN sexo = '2' and edad::int < 5  and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS masc_edadmenos_5_inmunosup,
		SUM (CASE WHEN sexo = '1' and edad::int < 5  and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS fem_edadmenos_5_inmunosup,

		SUM (CASE WHEN sexo = '2' and edad::int < 5  and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS masc_edadmenos_5_hiper,
		SUM (CASE WHEN sexo = '1' and edad::int < 5  and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS fem_edadmenos_5_hiper,
		
		SUM (CASE WHEN sexo = '2' and edad::int < 5  and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS masc_edadmenos_5_cardio,
		SUM (CASE WHEN sexo = '1' and edad::int < 5  and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS fem_edadmenos_5_cardio,
		
		SUM (CASE WHEN sexo = '2' and edad::int < 5  and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS masc_edadmenos_5_obes,
		SUM (CASE WHEN sexo = '1' and edad::int < 5  and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS fem_edadmenos_5_obes,
		
		SUM (CASE WHEN sexo = '2' and edad::int < 5  and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS masc_edadmenos_5_taba,
		SUM (CASE WHEN sexo = '1' and edad::int < 5  and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS fem_edadmenos_5_taba,
		
		SUM (CASE WHEN sexo = '2' and edad::int < 5  and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS masc_edadmenos_5_renalcro,
		SUM (CASE WHEN sexo = '1' and edad::int < 5  and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS fem_edadmenos_5_renalcro,
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
		SUM (CASE WHEN sexo = '2' and edad::int >= 5  and edad::int <= 15 and resultado = '1'  THEN 1 ELSE 0 END) AS masc_edad_5a15,
		SUM (CASE WHEN sexo = '1' and edad::int >= 5  and edad::int <= 15 and resultado = '1'  THEN 1 ELSE 0 END) AS fem_edad_5a15,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS masc_edad_5a15_neumo,
		SUM (CASE WHEN sexo = '1' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS fem_edad_5a15_neumo,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS masc_edad_5a15_diab,
		SUM (CASE WHEN sexo = '1' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS fem_edad_5a15_diab,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS masc_edad_5a15_epoc,
		SUM (CASE WHEN sexo = '1' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS fem_edad_5a15_epoc,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS masc_edad_5a15_asma,
		SUM (CASE WHEN sexo = '1' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS fem_edad_5a15_asma,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS masc_edad_5a15_inmunosup,
		SUM (CASE WHEN sexo = '1' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS fem_edad_5a15_inmunosup,

		SUM (CASE WHEN sexo = '2' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS masc_edad_5a15_hiper,
		SUM (CASE WHEN sexo = '1' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS fem_edad_5a15_hiper,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS masc_edad_5a15_cardio,
		SUM (CASE WHEN sexo = '1' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS fem_edad_5a15_cardio,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS masc_edad_5a15_obes,
		SUM (CASE WHEN sexo = '1' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS fem_edad_5a15_obes,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS masc_edad_5a15_taba,
		SUM (CASE WHEN sexo = '1' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS fem_edad_5a15_taba,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS masc_edad_5a15_renalcro,
		SUM (CASE WHEN sexo = '1' and edad::int >= 5  and edad::int <= 15 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS fem_edad_5a15_renalcro,
-----------------------------------------------------------------------------------------------------------		
		                SUM (CASE WHEN sexo = '2' and edad::int >= 16  and edad::int <= 25 and resultado = '1'  THEN 1 ELSE 0 END) AS masc_edad_16a25,
		SUM (CASE WHEN sexo = '1' and edad::int >= 16  and edad::int <= 25 and resultado = '1'  THEN 1 ELSE 0 END) AS fem_edad_16a25,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS masc_edad_16a25_neumo,
		SUM (CASE WHEN sexo = '1' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS fem_edad_16a25_neumo,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS masc_edad_16a25_diab,
		SUM (CASE WHEN sexo = '1' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS fem_edad_16a25_diab,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS masc_edad_16a25_epoc,
		SUM (CASE WHEN sexo = '1' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS fem_edad_16a25_epoc,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS masc_edad_16a25_asma,
		SUM (CASE WHEN sexo = '1' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS fem_edad_16a25_asma,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS masc_edad_16a25_inmunosup,
		SUM (CASE WHEN sexo = '1' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS fem_edad_16a25_inmunosup,

		SUM (CASE WHEN sexo = '2' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS masc_edad_16a25_hiper,
		SUM (CASE WHEN sexo = '1' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS fem_edad_16a25_hiper,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS masc_edad_16a25_cardio,
		SUM (CASE WHEN sexo = '1' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS fem_edad_16a25_cardio,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS masc_edad_16a25_obes,
		SUM (CASE WHEN sexo = '1' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS fem_edad_16a25_obes,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS masc_edad_16a25_taba,
		SUM (CASE WHEN sexo = '1' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS fem_edad_16a25_taba,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS masc_edad_16a25_renalcro,
		SUM (CASE WHEN sexo = '1' and edad::int >= 16  and edad::int <= 25 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS fem_edad_16a25_renalcro,
-----------------------------------------------------------------------------------------------------------	
		SUM (CASE WHEN sexo = '2' and edad::int >= 26  and edad::int <= 35 and  resultado = '1'  THEN 1 ELSE 0 END) AS masc_edad_26a35,
		SUM (CASE WHEN sexo = '1' and edad::int >= 26  and edad::int <= 35 and  resultado = '1'  THEN 1 ELSE 0 END) AS fem_edad_26a35,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS masc_edad_26a35_neumo,
		SUM (CASE WHEN sexo = '1' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS fem_edad_26a35_neumo,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS masc_edad_26a35_diab,
		SUM (CASE WHEN sexo = '1' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS fem_edad_26a35_diab,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS masc_edad_26a35_epoc,
		SUM (CASE WHEN sexo = '1' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS fem_edad_26a35_epoc,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS masc_edad_26a35_asma,
		SUM (CASE WHEN sexo = '1' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS fem_edad_26a35_asma,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS masc_edad_26a35_inmunosup,
		SUM (CASE WHEN sexo = '1' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS fem_edad_26a35_inmunosup,

		SUM (CASE WHEN sexo = '2' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS masc_edad_26a35_hiper,
		SUM (CASE WHEN sexo = '1' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS fem_edad_26a35_hiper,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS masc_edad_26a35_cardio,
		SUM (CASE WHEN sexo = '1' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS fem_edad_26a35_cardio,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS masc_edad_26a35_obes,
		SUM (CASE WHEN sexo = '1' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS fem_edad_26a35_obes,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS masc_edad_26a35_taba,
		SUM (CASE WHEN sexo = '1' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS fem_edad_26a35_taba,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS masc_edad_26a35_renalcro,
		SUM (CASE WHEN sexo = '1' and edad::int >= 26  and edad::int <= 35 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS fem_edad_26a35_renalcro,
	
-----------------------------------------------------------------------------------------------------------		
		SUM (CASE WHEN sexo = '2' and edad::int >= 36  and edad::int <= 45 and  resultado = '1'  THEN 1 ELSE 0 END) AS masc_edad_36a45,
		SUM (CASE WHEN sexo = '1' and edad::int >= 36  and edad::int <= 45 and resultado = '1'  THEN 1 ELSE 0 END) AS fem_edad_36a45,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS masc_edad_36a45_neumo,
		SUM (CASE WHEN sexo = '1' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS fem_edad_36a45_neumo,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS masc_edad_36a45_diab,
		SUM (CASE WHEN sexo = '1' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS fem_edad_36a45_diab,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS masc_edad_36a45_epoc,
		SUM (CASE WHEN sexo = '1' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS fem_edad_36a45_epoc,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS masc_edad_36a45_asma,
		SUM (CASE WHEN sexo = '1' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS fem_edad_36a45_asma,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS masc_edad_36a45_inmunosup,
		SUM (CASE WHEN sexo = '1' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS fem_edad_36a45_inmunosup,

		SUM (CASE WHEN sexo = '2' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS masc_edad_36a45_hiper,
		SUM (CASE WHEN sexo = '1' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS fem_edad_36a45_hiper,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS masc_edad_36a45_cardio,
		SUM (CASE WHEN sexo = '1' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS fem_edad_36a45_cardio,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS masc_edad_36a45_obes,
		SUM (CASE WHEN sexo = '1' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS fem_edad_36a45_obes,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS masc_edad_36a45_taba,
		SUM (CASE WHEN sexo = '1' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS fem_edad_36a45_taba,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS masc_edad_36a45_renalcro,
		SUM (CASE WHEN sexo = '1' and edad::int >= 36  and edad::int <= 45 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS fem_edad_36a45_renalcro,
-----------------------------------------------------------------------------------------------------------		
		SUM (CASE WHEN sexo = '2' and edad::int >= 46  and edad::int <=  55 and resultado = '1'  THEN 1 ELSE 0 END) AS masc_edad_46a55,
		SUM (CASE WHEN sexo = '1' and edad::int >= 46  and edad::int <=  55 and resultado = '1'  THEN 1 ELSE 0 END) AS fem_edad_46a55,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS masc_edad_46a55_neumo,
		SUM (CASE WHEN sexo = '1' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS fem_edad_46a55_neumo,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS masc_edad_46a55_diab,
		SUM (CASE WHEN sexo = '1' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS fem_edad_46a55_diab,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS masc_edad_46a55_epoc,
		SUM (CASE WHEN sexo = '1' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS fem_edad_46a55_epoc,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS masc_edad_46a55_asma,
		SUM (CASE WHEN sexo = '1' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS fem_edad_46a55_asma,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS masc_edad_46a55_inmunosup,
		SUM (CASE WHEN sexo = '1' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS fem_edad_46a55_inmunosup,

		SUM (CASE WHEN sexo = '2' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS masc_edad_46a55_hiper,
		SUM (CASE WHEN sexo = '1' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS fem_edad_46a55_hiper,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS masc_edad_46a55_cardio,
		SUM (CASE WHEN sexo = '1' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS fem_edad_46a55_cardio,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS masc_edad_46a55_obes,
		SUM (CASE WHEN sexo = '1' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS fem_edad_46a55_obes,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS masc_edad_46a55_taba,
		SUM (CASE WHEN sexo = '1' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS fem_edad_46a55_taba,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS masc_edad_46a55_renalcro,
		SUM (CASE WHEN sexo = '1' and edad::int >= 46  and edad::int <=  55 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS fem_edad_46a55_renalcro,
			
-----------------------------------------------------------------------------------------------------------		
		SUM (CASE WHEN sexo = '2' and edad::int >= 56  and edad::int <=  65 and resultado = '1'  THEN 1 ELSE 0 END) AS masc_edad_56a65,
		SUM (CASE WHEN sexo = '1' and edad::int >= 56  and edad::int <=  65 and resultado = '1'  THEN 1 ELSE 0 END) AS fem_edad_56a65,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS masc_edad_56a65_neumo,
		SUM (CASE WHEN sexo = '1' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS fem_edad_56a65_neumo,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS masc_edad_56a65_diab,
		SUM (CASE WHEN sexo = '1' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS fem_edad_56a65_diab,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS masc_edad_56a65_epoc,
		SUM (CASE WHEN sexo = '1' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS fem_edad_56a65_epoc,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS masc_edad_56a65_asma,
		SUM (CASE WHEN sexo = '1' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS fem_edad_56a65_asma,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS masc_edad_56a65_inmunosup,
		SUM (CASE WHEN sexo = '1' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS fem_edad_56a65_inmunosup,

		SUM (CASE WHEN sexo = '2' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS masc_edad_56a65_hiper,
		SUM (CASE WHEN sexo = '1' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS fem_edad_56a65_hiper,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS masc_edad_56a65_cardio,
		SUM (CASE WHEN sexo = '1' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS fem_edad_56a65_cardio,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS masc_edad_56a65_obes,
		SUM (CASE WHEN sexo = '1' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS fem_edad_56a65_obes,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS masc_edad_56a65_taba,
		SUM (CASE WHEN sexo = '1' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS fem_edad_56a65_taba,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS masc_edad_56a65_renalcro,
		SUM (CASE WHEN sexo = '1' and edad::int >= 56  and edad::int <=  65 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS fem_edad_56a65_renalcro,
-----------------------------------------------------------------------------------------------------------		
		SUM (CASE WHEN sexo = '2' and edad::int >= 66  and edad::int <=  75 and resultado = '1'  THEN 1 ELSE 0 END) AS masc_edad_66a75,
		SUM (CASE WHEN sexo = '1' and edad::int >= 66  and edad::int <=  75 and resultado = '1'  THEN 1 ELSE 0 END) AS fem_edad_66a75,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS masc_edad_66a75_neumo,
		SUM (CASE WHEN sexo = '1' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS fem_edad_66a75_neumo,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS masc_edad_66a75_diab,
		SUM (CASE WHEN sexo = '1' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS fem_edad_66a75_diab,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS masc_edad_66a75_epoc,
		SUM (CASE WHEN sexo = '1' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS fem_edad_66a75_epoc,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS masc_edad_66a75_asma,
		SUM (CASE WHEN sexo = '1' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS fem_edad_66a75_asma,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS masc_edad_66a75_inmunosup,
		SUM (CASE WHEN sexo = '1' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS fem_edad_66a75_inmunosup,

		SUM (CASE WHEN sexo = '2' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS masc_edad_66a75_hiper,
		SUM (CASE WHEN sexo = '1' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS fem_edad_66a75_hiper,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS masc_edad_66a75_cardio,
		SUM (CASE WHEN sexo = '1' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS fem_edad_66a75_cardio,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS masc_edad_66a75_obes,
		SUM (CASE WHEN sexo = '1' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS fem_edad_66a75_obes,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS masc_edad_66a75_taba,
		SUM (CASE WHEN sexo = '1' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS fem_edad_66a75_taba,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS masc_edad_66a75_renalcro,
		SUM (CASE WHEN sexo = '1' and edad::int >= 66  and edad::int <=  75 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS fem_edad_66a75_renalcro,
-----------------------------------------------------------------------------------------------------------				
	        SUM (CASE WHEN sexo = '2' and edad::int >= 76  and edad::int <=  85 and resultado = '1'  THEN 1 ELSE 0 END) AS masc_edad_76a85,
		SUM (CASE WHEN sexo = '1' and edad::int >= 76  and edad::int <=  85 and resultado = '1'  THEN 1 ELSE 0 END) AS fem_edad_76a85,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS masc_edad_76a85_neumo,
		SUM (CASE WHEN sexo = '1' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS fem_edad_76a85_neumo,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS masc_edad_76a85_diab,
		SUM (CASE WHEN sexo = '1' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS fem_edad_76a85_diab,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS masc_edad_76a85_epoc,
		SUM (CASE WHEN sexo = '1' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS fem_edad_76a85_epoc,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS masc_edad_76a85_asma,
		SUM (CASE WHEN sexo = '1' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS fem_edad_76a85_asma,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS masc_edad_76a85_inmunosup,
		SUM (CASE WHEN sexo = '1' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS fem_edad_76a85_inmunosup,

		SUM (CASE WHEN sexo = '2' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS masc_edad_76a85_hiper,
		SUM (CASE WHEN sexo = '1' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS fem_edad_76a85_hiper,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS masc_edad_76a85_cardio,
		SUM (CASE WHEN sexo = '1' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS fem_edad_76a85_cardio,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS masc_edad_76a85_obes,
		SUM (CASE WHEN sexo = '1' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS fem_edad_76a85_obes,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS masc_edad_76a85_taba,
		SUM (CASE WHEN sexo = '1' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS fem_edad_76a85_taba,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS masc_edad_76a85_renalcro,
		SUM (CASE WHEN sexo = '1' and edad::int >= 76  and edad::int <=  85 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS fem_edad_76a85_renalcro,
-----------------------------------------------------------------------------------------------------------		
		SUM (CASE WHEN sexo = '2' and edad::int >= 86  and edad::int <=  95 and resultado = '1'  THEN 1 ELSE 0 END) AS masc_edad_86a95,
		SUM (CASE WHEN sexo = '1' and edad::int >= 86  and edad::int <=  95 and resultado = '1'  THEN 1 ELSE 0 END) AS fem_edad_86a95,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS masc_edad_86a95_neumo,
		SUM (CASE WHEN sexo = '1' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS fem_edad_86a95_neumo,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS masc_edad_86a95_diab,
		SUM (CASE WHEN sexo = '1' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS fem_edad_86a95_diab,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS masc_edad_86a95_epoc,
		SUM (CASE WHEN sexo = '1' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS fem_edad_86a95_epoc,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS masc_edad_86a95_asma,
		SUM (CASE WHEN sexo = '1' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS fem_edad_86a95_asma,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS masc_edad_86a95_inmunosup,
		SUM (CASE WHEN sexo = '1' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS fem_edad_86a95_inmunosup,

		SUM (CASE WHEN sexo = '2' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS masc_edad_86a95_hiper,
		SUM (CASE WHEN sexo = '1' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS fem_edad_86a95_hiper,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS masc_edad_86a95_cardio,
		SUM (CASE WHEN sexo = '1' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS fem_edad_86a95_cardio,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS masc_edad_86a95_obes,
		SUM (CASE WHEN sexo = '1' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS fem_edad_86a95_obes,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS masc_edad_86a95_taba,
		SUM (CASE WHEN sexo = '1' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS fem_edad_86a95_taba,
		
		SUM (CASE WHEN sexo = '2' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS masc_edad_86a95_renalcro,
		SUM (CASE WHEN sexo = '1' and edad::int >= 86  and edad::int <=  95 and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS fem_edad_86a95_renalcro,
-----------------------------------------------------------------------------------------------------------
	
				
		SUM (CASE WHEN sexo = '2' and edad::int > 96  and resultado = '1'  THEN 1 ELSE 0 END) AS masc_edad_mayor96,
		SUM (CASE WHEN sexo = '1' and edad::int > 96  and resultado = '1'  THEN 1 ELSE 0 END) AS fem_edad_mayor96,
		
		SUM (CASE WHEN sexo = '2' and edad::int > 96  and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS masc_edad_mayor96_neumo,
		SUM (CASE WHEN sexo = '1' and edad::int > 96  and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS fem_edad_mayor96_neumo,
		
		SUM (CASE WHEN sexo = '2' and edad::int > 96  and  resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS masc_edad_mayor96_diab,
		SUM (CASE WHEN sexo = '1' and edad::int > 96  and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS fem_edad_mayor96_diab,
		
		SUM (CASE WHEN sexo = '2' and edad::int > 96  and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS masc_edad_mayor96_epoc,
		SUM (CASE WHEN sexo = '1' and edad::int > 96  and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS fem_edad_mayor96_epoc,
		
		SUM (CASE WHEN sexo = '2' and edad::int > 96  and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS masc_edad_mayor96_asma,
		SUM (CASE WHEN sexo = '1' and edad::int > 96  and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS fem_edad_mayor96_asma,
		
		SUM (CASE WHEN sexo = '2' and edad::int > 96  and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS masc_edad_mayor96_inmunosup,
		SUM (CASE WHEN sexo = '1' and edad::int > 96  and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS fem_edad_mayor96_inmunosup,

		SUM (CASE WHEN sexo = '2' and edad::int > 96  and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS masc_edad_mayor96_hiper,
		SUM (CASE WHEN sexo = '1' and edad::int > 96  and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS fem_edad_mayor96_hiper,
		
		SUM (CASE WHEN sexo = '2' and edad::int > 96  and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS masc_edad_mayor96_cardio,
		SUM (CASE WHEN sexo = '1' and edad::int > 96  and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS fem_edad_mayor96_cardio,
		
		SUM (CASE WHEN sexo = '2' and edad::int > 96  and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS masc_edad_mayor96_obes,
		SUM (CASE WHEN sexo = '1' and edad::int > 96  and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS fem_edad_mayor96_obes,
		
		SUM (CASE WHEN sexo = '2' and edad::int > 96  and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS masc_edad_mayor96_taba,
		SUM (CASE WHEN sexo = '1' and edad::int > 96  and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS fem_edad_mayor96_taba,
		
		SUM (CASE WHEN sexo = '2' and edad::int > 96  and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS masc_edad_mayor96_renalcro,
		SUM (CASE WHEN sexo = '1' and edad::int > 96  and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS fem_edad_mayor96_renalcro,
------------------------
		SUM (CASE WHEN sexo = '1' and resultado = '1' THEN 1 ELSE 0 END) AS fem_tot_inf,
		SUM (CASE WHEN sexo = '1' and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS fem_tot_inf_neumo,
		SUM (CASE WHEN sexo = '1' and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS fem_tot_inf_diab,
		SUM (CASE WHEN sexo = '1' and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS fem_tot_inf_epoc,
		SUM (CASE WHEN sexo = '1' and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS fem_tot_inf_asma,
		SUM (CASE WHEN sexo = '1' and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS fem_tot_inf_inmuno,
		SUM (CASE WHEN sexo = '1' and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS fem_tot_inf_hiper,
		SUM (CASE WHEN sexo = '1' and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS fem_tot_inf_cardio,
		SUM (CASE WHEN sexo = '1' and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS fem_tot_inf_obes,
		SUM (CASE WHEN sexo = '1' and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS fem_tot_inf_taba,
		SUM (CASE WHEN sexo = '1' and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS fem_tot_inf_renal,
------------------------------------
		SUM (CASE WHEN sexo = '2' and resultado = '1' THEN 1 ELSE 0 END) AS masc_tot_inf,
		SUM (CASE WHEN sexo = '2' and resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS masc_tot_inf_neumo,
		SUM (CASE WHEN sexo = '2' and resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS masc_tot_inf_diab,
		SUM (CASE WHEN sexo = '2' and resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS masc_tot_inf_epoc,
		SUM (CASE WHEN sexo = '2' and resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS masc_tot_inf_asma,
		SUM (CASE WHEN sexo = '2' and resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS masc_tot_inf_inmuno,
		SUM (CASE WHEN sexo = '2' and resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS masc_tot_inf_hiper,
		SUM (CASE WHEN sexo = '2' and resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS masc_tot_inf_cardio,
		SUM (CASE WHEN sexo = '2' and resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS masc_tot_inf_obes,
		SUM (CASE WHEN sexo = '2' and resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS masc_tot_inf_taba,
		SUM (CASE WHEN sexo = '2' and resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS masc_tot_inf_renal,
-------------------------------------------------------------------------------------------------------------
		SUM (CASE WHEN  resultado = '1' and neumonia = '1' THEN 1 ELSE 0 END) AS  pob_tot_inf_neumo,
		SUM (CASE WHEN  resultado = '1' and diabetes = '1' THEN 1 ELSE 0 END) AS  pob_tot_inf_diab,
		SUM (CASE WHEN  resultado = '1' and epoc = '1' THEN 1 ELSE 0 END) AS  pob_tot_inf_epoc,
		SUM (CASE WHEN  resultado = '1' and asma = '1' THEN 1 ELSE 0 END) AS  pob_tot_inf_asma,
		SUM (CASE WHEN  resultado = '1' and inmusupr = '1' THEN 1 ELSE 0 END) AS  pob_tot_inf_inmuno,
		SUM (CASE WHEN  resultado = '1' and hipertension = '1' THEN 1 ELSE 0 END) AS  pob_tot_inf_hiper,
		SUM (CASE WHEN  resultado = '1' and cardiovascular = '1' THEN 1 ELSE 0 END) AS  pob_tot_inf_cardio,
		SUM (CASE WHEN  resultado = '1' and obesidad = '1' THEN 1 ELSE 0 END) AS  pob_tot_inf_obes,
		SUM (CASE WHEN  resultado = '1' and tabaquismo = '1' THEN 1 ELSE 0 END) AS  pob_tot_inf_taba,
		SUM (CASE WHEN  resultado = '1' and renal_cronica = '1' THEN 1 ELSE 0 END) AS  pob_tot_inf_renal,
		SUM (CASE WHEN resultado = '1' THEN 1 ELSE 0 END) AS pob_tot_infect
FROM
	aria.dim_covidanonda0412
GROUP BY  municipio_res_concat) as a
JOIN dim_municipio as b
ON a.municipio_res_concat = b.municipio_cvegeo) as a
JOIN fact_municipio b
ON a.municipio_cvegeo = b.municipio_cvegeo) as c
WHERE pob_tot_infect > 0 and entidad_cvegeo = '09';
----------------------------------------------------------------------------------------------
ALTER TABLE aria.covid_cdmx_prob 
    ALTER COLUMN geom
    TYPE Geometry(Point, 4326)
    USING ST_Transform(geom, 4326);
---------------------------------------------------------------------
select * from aria.covid_cdmx_prob;
