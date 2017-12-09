#library(devtools)
#install_github("ktoddbrown/soilDataR")
library(assertthat)
library(tidyverse)
library(readxl)
library(SoilDataR)

temp <- processData_Templet(
  filename='hackathon/example.xlsx',
  excludeSheets='key',
  key.df=readxl::read_excel(path='hackathon/example.xlsx', sheet='key', na='NA'), 
  skip=NA, 
  verticalSheets=c('study'))
