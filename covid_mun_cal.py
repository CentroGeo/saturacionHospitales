import pandas as pd 
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
from scipy.optimize import minimize
import numpy as np


def SIR_compute(S_0= 100000, I_0= 1, R_0=0 , beta=0.00000085 ,gamma=0.00000001, time=100):
    """To Calculate the number of infected using a infected rate a recovery rate and the time 
    param: S_0  Suceptible population
    param: I_0  Infected poblation at initial time,
    param: R_0  Recover population at initial time,
    param: beta Infected rate 
    param: gamma Recovery rate
    param: time  Time in front to calculate
    """
    def SIR(t, y):
        S = y[0]
        I = y[1]
        R = y[2]
        return [-beta*S*I, beta*S*I-gamma*I, gamma*I]
    size = time
    solution = solve_ivp(SIR, [0, size] , [S_0,I_0,R_0], t_eval=np.arange(0, size, 1), vectorized=True)
    return solution

def Camas_mun(Total_mu,dis_enf_mun,porcen_rangos_hosp, gamma= None, beta= None , time=200):
    """ Get the amount of beds needed in a municipality
    param: Total_mu The total poblation in a municipality
    param: dis_enf_mun The distribution of the infected
    param: porcen_rangos_hosp The distribution for the hospitalization of the infected
    gamma= None The gamma for the SIR model
    beta= None  The Beta for the SIR model
    time=200 The amount of time to run the SIR model
    """
    ### Poblacion suceptible #80% de la poblacion 
    Suce_mun = Total_mu*0.8
    comu=SIR_compute(S_0= Suce_mun, I_0=20, R_0 =5 , time=200) ### El numero de infectados 
    #### Para cada tiempo podemos optener el numero de infectados y su distribución 
    dis_enf_cam_Co=[]
    total_enf_cam_Co=[]
    for i in comu['y'][1]:
        dis=(i*dis_enf_mun)*porcen_rangos_hosp ### Numero de enfermos  en tiempot 
        ### El porcentaje que requiere cama
        dis_enf_cam_Co.append(dis)
        ### Total de camas en el tiempo
        total_enf_cam_Co.append(dis.sum())
    return  {'Distr':dis_enf_cam_Co, 'Tot': total_enf_cam_Co}


def Camas_mun_df(Total_mu, dis_enf_mun, porcen_rangos_hosp, gamma= None, beta= None , time=200):
    """ Get the amount of beds needed in a municipality
    param: Total_mu The total poblation in a municipality
    param: dis_enf_mun The distribution of the infected
    param: porcen_rangos_hosp The distribution for the hospitalization of the infected
    gamma= None The gamma for the SIR model
    beta= None  The Beta for the SIR model
    time=200 The amount of time to run the SIR model
    """

    Suce_mun = Total_mu*0.8                                                                                                                  
    comu=SIR_compute(S_0= Suce_mun, I_0=20, R_0 =5 , time=200) ### El numero de infectados
    #### Para cada tiempo podemos optener el numero de infectados y su distribución                                                          
    dis_enf_cam_Co=[]                                                                                                                        
    total_enf_cam_Co=[]                                                                                                                      
    for i in comu['y'][1]:                                                                                                                   
        dis=(i*dis_enf_mun)*porcen_rangos_hosp['0'] ### Numero de enfermos  en tiempot                                                       
        ### El porcentaje que requiere cama                                                                                                  
        dis_enf_cam_Co.append(dis)                                                                                                           
        ### Total de camas en el tiempo                                                                                                      
        total_enf_cam_Co.append(dis.sum())                                                                                                   
    return  {'Distr':dis_enf_cam_Co, 'Tot': total_enf_cam_Co}      

def distri_enf_mun(id_mun, res_df,por_cent_edad_dis_enf ,dis_prom_se):
    """Get the distribucion of infected by municipality
    param: id_mun ID cve_geo municipality
    param: res_df the dataframe with all the municipality distributions
    param: por_cent_edad_dis_enf the distribution of infected 
    param: dis_prom_se the average dirtibution of the country
"""
    ### Los factores para cada rango de poblacion entre el correpondiente de la distibución promedio
    fact_dis_mun = res_df.loc[id_mun]/dis_prom_se  
    por_enf_mun  = por_cent_edad_dis_enf*fact_dis_mun
    dis_enf_mun  = (por_enf_mun/por_enf_mun.sum())
    return dis_enf_mun

def distri_enf_mun_df(id_mun, res_df,por_cent_edad_dis_enf ,dis_prom_se):
    """Get the distribucion of infected by municipality
    param: id_mun ID cve_geo municipality
    param: res_df the dataframe with all the municipality distributions
    param: por_cent_edad_dis_enf the distribution of infected as dataframe 
    param: dis_prom_se the average dirtibution of the country
"""
    ### Los factores para cada rango de poblacion entre el correpondiente de la distibución promedio
    fact_dis_mun = res_df.loc[id_mun]/dis_prom_se  
    por_enf_mun  = por_cent_edad_dis_enf['0']*fact_dis_mun
    dis_enf_mun  = (por_enf_mun/por_enf_mun.sum())
    return dis_enf_mun


def demanda_camas_ind(Sum_total_enf , camas_hospital= 200, plot_s= False, rec_time =  24):
    """Estimate the demand of beds in a hospital
    param: Sum_total_enf the total expected infected
    param: camas_hospital the amount of beds in the hospital
    param: plot_s if we want to print the plot of demand of the bed
    param: rec_time the excpected recovery time to free beds 
"""
    camas_nec_nue = (np.asarray(Sum_total_enf[1:])-np.asarray(Sum_total_enf[:len(Sum_total_enf)-1]) )
    camas_de_rec =  (np.asarray(Sum_total_enf[1:len(Sum_total_enf)-rec_time])- np.asarray(Sum_total_enf[:len(Sum_total_enf)-rec_time-1]) )
    rep = np.repeat(0,rec_time)
    camas_de_rec=np.concatenate(( rep, camas_de_rec))
    camas_nec= np.cumsum(camas_nec_nue)
    camas_dem = camas_nec_nue - camas_de_rec
    saturacion =  (np.cumsum(camas_dem ) - camas_hospital)/ camas_hospital
    if plot_s==True:
        fig = plt.figure
        fig1 = fig(1)
        fig1.suptitle('Demanda camas Covid 19', fontsize=15)
        pto =plt.plot(camas_dem)
        fig2 = fig(2)
        fig2.suptitle('Ocupación Covid 19', fontsize=15)
        pto2=plt.bar(range(0, len(saturacion)),height=saturacion)
        
        
    return {'Demanda':camas_dem,'Saturacion': saturacion}

def demanda_camas_ind_df(Sum_total_enf , camas_hospital= 200, plot_s= False, rec_time =  24):
    """Estimate the demand of beds in a hospital
    param: Sum_total_enf the total expected infected
    param: camas_hospital the amount of beds in the hospital
    param: plot_s if we want to print the plot of demand of the bed
    param: rec_time the excpected recovery time to free beds 
"""
    camas_nec_nue = (np.asarray(Sum_total_enf[1:])-np.asarray(Sum_total_enf[:len(Sum_total_enf)-1]) )
    camas_de_rec =  (np.asarray(Sum_total_enf[1:len(Sum_total_enf)-rec_time])- np.asarray(Sum_total_enf[:len(Sum_total_enf)-rec_time-1]) )
    rep = np.repeat(0,rec_time)
    camas_de_rec=np.concatenate(( rep, camas_de_rec))
    camas_nec= np.cumsum(camas_nec_nue)
    camas_dem = camas_nec_nue - camas_de_rec
    saturacion =  (np.cumsum(camas_dem ) - camas_hospital)/ camas_hospital
    if plot_s==True:
        fig = plt.figure
        fig1 = fig(1)
        fig1.suptitle('Demanda camas Covid 19', fontsize=15)
        pto =plt.plot(camas_dem)
        fig2 = fig(2)
        fig2.suptitle('Ocupación Covid 19', fontsize=15)
        pto2=plt.bar(range(0, len(saturacion)),height=saturacion)
        
        
    return {'Demanda':camas_dem,'Saturacion': saturacion}


def get_pob_dataframe(year):
    """Load tata from CONAPO proyection by municipality database
    param: year year to load
"""
    df_poblacion_1 =  pd.read_csv('/home/miguel/Cgeo/Data/CONAPO/base_municipios_final_datos_01.csv',
            dtype={'RENGLON':int,'CLAVE':str,'CLAVE_ENT':str,
                   'NOM_ENT':str,'MUN':str,'SEXO':str,'AÑO':str,
                   'EDAD_QUIN':str,'POB':int},
            encoding = "ISO-8859-1")
    df_poblacion_2 =  pd.read_csv('/home/miguel/Cgeo/Data/CONAPO/base_municipios_final_datos_02.csv',
            dtype={'RENGLON':int,'CLAVE':str,'CLAVE_ENT':str,
                  'NOM_ENT':str,'MUN':str,'SEXO':str,
                  'AÑO':str,'EDAD_QUIN':str,'POB':int},
            encoding = "ISO-8859-1")
    df_poblacion_1.drop(columns='RENGLON', inplace=True)
    df_poblacion_2.drop(columns='RENGLON', inplace=True)
    df_poblacion= pd.concat([df_poblacion_1, df_poblacion_2])

    df_poblacion['CLAVE']= df_poblacion['CLAVE'].apply(lambda x: clave_municipio(x))
    df_poblacion['CLAVE_ENT']= df_poblacion['CLAVE_ENT'].apply(lambda x: clave_ent(x))
    df_poblacion_year=df_poblacion[df_poblacion['AÑO']==year]
    return  df_poblacion_year


def distro_all_mun(df_pobla, sex =None):
    """Get the distribution of the total poblation in percentages for all the ranges
    param: df_pobla is the data frame with the poblation data
    param: gender is if male and female are extract as different
 """
    df_pob= {}
    claves_mun =  df_pobla['CLAVE'].unique()
    for i in claves_mun:
        des = df_pobla[ df_pobla['CLAVE'] ==i]
        if sex==None:
            tot_munc= (des[['EDAD_QUIN','POB']].groupby('EDAD_QUIN').sum()).sum()
            des2= des[['EDAD_QUIN','POB']].groupby('EDAD_QUIN').sum()/tot_munc
        elif sex == 'Mujer':
            des= des [des['SEXO']=='Mujeres']
            tot_munc= (des[['EDAD_QUIN','POB']].groupby('EDAD_QUIN').sum()).sum()
            des2= des[['EDAD_QUIN','POB']].groupby('EDAD_QUIN').sum()/tot_munc
        elif sex == 'Hombre':
            des= des [des['SEXO']=='Hombres']
            tot_munc= (des[['EDAD_QUIN','POB']].groupby('EDAD_QUIN').sum()).sum()
            des2= des[['EDAD_QUIN','POB']].groupby('EDAD_QUIN').sum()/tot_munc
        else:
            print(sex, ' is not a good value' )
            raise ValueError("Mujer, Hombre o nada ")
        
            
        des2= des2.T
        des2.rename_axis(None)
        des2['CLAVE'] = i
        des2.set_index('CLAVE')
        #des2.drop(columns=['EDAD_QUIN'])    
        df_pob[i]=des2
    res= pd.concat(df_pob.values())
    res.set_index('CLAVE', drop=True, inplace=True)
    return res


def clave_municipio(clave):
    """Function to get the municipal clave right"""
    if len(clave) > 5:
        raise ValueError("The expected leng of the string is 5 or 4")
    elif len(clave)==5:
        return clave
    elif len(clave)==4:
        clave= '0'+ clave
        return clave
    else:
        raise ValueError("The expected leng of the string is 5 or 4")

def clave_ent(clave):
    """Function to get the clave entidad right"""
    if len(clave) > 2:
        raise ValueError("The expected leng of the string is 2 or 1")
    elif len(clave)==2:
        return clave
    elif len(clave)==1:
        clave= '0'+ clave
        return clave
    else:
        raise ValueError("The expected leng of the string is 2 or 2")
