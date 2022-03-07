# code for model used in Parks et al. JAMA 2022
# NOTE: this code is a guide and not able to be run

# some packages used
library(INLA) ; library(splines)

# hyperparameter value
hyper_value = 0.001

# number of degrees of freedom for modelling temperature
deg_freedom_temperature = 3

# knots for natural spline term
knots <- seq(3,369,3)

# model formula
# year.month is time in months from beginning of period to end: 1 (Jan 1988) to 372 (Dec 2018))
# tmean is mean monthly temperature
# event_lag0 ... event_lag6 are hurricane/tropical cyclone exposure counts: lag_0 (month of exposure) to lag_6 (6 months after exposure)
# stratum is county-month (for conditional model)
# e is overdispersion term

fml = deaths ~
  ns(year.month,knots = knots) + # natural spline with knot every 3 months
  f(tmean, model='rw2', hyper = list(prec = list(prior = "loggamma", param = c(1, hyper_value)))) + # temperature rw2
  event_lag0 + event_lag1 + event_lag2 + event_lag3 + event_lag4 + event_lag5 + event_lag6 + # exposure count in the month
  f(stratum, model="iid", hyper = list(prec = list(prior = "loggamma", param = c(1, hyper_value)))) + # county-month strata
  e # overdispersion

# run model (first rough version for starting values, then full version)

# 1. rough version
mod.rough =
  inla(formula = fml,
       family = "poisson",
       data = data, # the data used for model
       E = pop, # population offset
       control.compute = list(dic=TRUE, openmp.strategy="pardiso.parallel"),
       control.predictor = list(link = 1),
       control.inla = list(diagonal=10000, int.strategy='eb',strategy='gaussian'),
  )

# 2. full version
mod =
  inla(formula = fml,
       family = "poisson",
       data = data, # the data used for model
       E = pop, # population offset
       control.compute = list(config=TRUE, dic=TRUE, openmp.strategy="pardiso.parallel"),
       control.predictor = list(link = 1),
       control.inla=list(diagonal=0),
       control.mode = list(result = mod.rough, restart = TRUE),
  )

# number of draws for posterior sampling
num_draws=1000

# parameters to sample from posterior 
selected_parameters = list(event_lag0=1,event_lag1=1,event_lag2=1,event_lag3=1,event_lag4=1,event_lag5=1,event_lag6=1)

# make draws for selected parameters
set.seed(1234)
draws.current = inla.posterior.sample(num_draws, mod, selection = selected_parameters)
