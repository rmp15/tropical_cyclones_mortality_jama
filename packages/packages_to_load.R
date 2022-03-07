# script which checks if chosen packages are installed, 
# loads them if already installed, or installs them then loads them if not already installed

############ 1. Packages on CRAN ############

# list of packages to use (in alphabetical order and 5 per row)
list.of.packages = c('car','caret','cowplot','RColorBrewer','data.table',
                     'datapasta','devtools','drat','EnvStats','Epi', 
                     'extrafont','expss', 'fBasics', 'foreign','forestplot',
                     'GGally','ggplot2','grid','gridExtra','haven',
                     'janitor','lubridate', 'MASS','nortest','naniar',
                     'olsrr','plyr', 'pROC','psych','raster',
                     'readr','reshape','reshape2','rgdal','rpart',
                     'scales','stringr','splines','rpart.plot','tidyverse',
                     'viridis', 'zoo')

# check if list of packages is installed. If not, it will install ones not yet installed
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages,repos = "https://cloud.r-project.org")

# load packages
lapply(list.of.packages, require, character.only = TRUE)

############ 2. Packages on not on CRAN and to download from source ############

# list of packages not on CRAN (INLA only in this case)
list.of.packages.not.on.cran <- c('INLA')
new.packages.not.on.cran <- list.of.packages[!(list.of.packages.not.on.cran %in% installed.packages()[,"Package"])]
if(length(new.packages.not.on.cran))
 install.packages("INLA",repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)
lapply(list.of.packages.not.on.cran, require, character.only = TRUE)

############ 3. Packages on not on CRAN and to download from github ############

# tropical cyclone data packages that need to be downloaded from github
list.of.packages.from.github <- c('hurricaneexposure','hurricaneexposuredata')
new.packages.from.github <- list.of.packages[!(list.of.packages.from.github %in% installed.packages()[,"Package"])]
if(length(new.packages.from.github))
{
 addRepo("geanders")
 install.packages(new.packages)
}
lapply(list.of.packages.from.github, require, character.only = TRUE)
