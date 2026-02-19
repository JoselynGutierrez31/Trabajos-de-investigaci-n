*UNIVERSIDAD NACIONAL AGRARIA LA MOLINA
*ALUMNA: GUTIERREZ MARCA, JOSELYN MILAGROS
*TIPO DE CAMBIO Y SU INFLUENCIA EN LA EXPORTACION AURIFERA PARA EL PERU (2010-2019).

use "C:\Users\PC25\Downloads\dta.dta"

rename preciodeexporta p
rename tipodecambio tc
rename exportacion exp

*SETEAMOS EL TIEMPO
gen t = tm(2010,1) + _n - 1
format t %tm
tsset t, monthly

*ANÁLISIS DE DISPERSIÓN DE VARIABLES
*Estadísticos descriptivos LIN
tabstat exp tc p, stat(mean cv sd variance)
*observamos que tiene varianzas muy altas por lo tanto: 
*Se generan logaritmos
g lexp=log( exp )
g lp=log(p)

*Estadísticos descriptivos LOG
tabstat lexp tc lp, stat(mean cv sd variance)

*NORMALIDAD DE LAS VARIABLES
ssc install jb
jb tc
jb lexp
jb lp


*REGRESIONES Y PRUEBAS DE MC Y HC
reg exp tc p 
reg lexp tc lp 
vif
*No hay problema de multicolinealidad preocupante ya que es VIF < 5


*Estacionariedad*
*evaluando de la estacionariedad de los residuos de un modelo de regresión, utilizando la prueba de Dickey-Fuller
predict residuals, resid
dfuller residual, trend regress
dfuller residual, regress
dfuller residual, regress noconstant
dfuller residual

*Asumimos que lexp es I(0)
dfuller lexp, trend regress
dfuller lexp, regress
dfuller lexp, regress noconstant
*lx es no estacionario en I(0)
*asumiendo que lx es I(1)
g dlexp=D.lexp
dfuller dlexp, trend regress
dfuller dlexp, regress
dfuller dlexp, regress noconstant
**dlexp es I(1)

*Asumimos que tc es I(0)
dfuller tc, trend regress
dfuller tc, regress
dfuller tc, regress noconstant
*tc es no estacionario en I(0)
*asumiendo que tc es I(1)
g dtc=D.tc
dfuller dtc, trend regress
dfuller dtc, regress
dfuller dtc, regress noconstant
**dtc es I(1)

*Asumimos que lp es I(0)
dfuller lp, trend regress
dfuller lp, regress
dfuller lp, regress noconstant
*lp es no estacionario en I(0)
*asumiendo que lp es I(1)
g dlp=D.lp
dfuller dlp, trend regress
dfuller dlp, regress
dfuller dlp, regress noconstant
**dlp es I(1)


*obtenemos que las variables lexp tc lp son estacionarias en la primera diferencia 

*REZAGOS ÓPTIMOS
varsoc lexp tc lp , maxlag(24)

*PRUEBA DE JOHANSEN
vecrank lexp tc lp, max ic
*solo cointegran 1 variables 
*hay evidencia de que hay por lo menos 1 variable que cointegra a largo plazo. Se elige un modelo VECM

*PRUEBA DE CUSUM
ssc install cusum6
cusum6 lexp lp tc t, cs(cusum) lw(lower) uw(upper)
*No hay quiebre estructural

*PRUEBA DE AUTOCORRELACIÓN
ac lexp
ac lp
ac tc
*hay autocorrelación en todas las variables


*MODELO VECM

*usando lag 2
vec lexp tc lp, rank(1) lags(2) trend(constant)

*PRUEBA LM DE AUTOCORRELACIÓN
veclmar
*CONDICIÓN DE ESTABILIDAD
vecstable, graph
*PRUEBAS PARA NORMALIDAD DE RESIDUOS
vecnorm 
