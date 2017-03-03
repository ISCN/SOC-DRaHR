library(XML)
library(reshape2)
library(plyr)
processData_Hardon2005 <- function(dir='repoData/'){
  xml_tree <- xmlTreeParse(sprintf('%sHardon2005/MetaData.xml', dir)) 
  xlm_ls <- xmlToList(sprintf('%sHardon2005/MetaData.xml', dir))
  #columns: xlm_ls$dataset$dataTable$attributeList[[1]]
  
  ##Pull site information
  fieldData <- data.frame()
  for(site.ls in xlm_ls$dataset$methods$sampling$studyExtent$coverage){
    if('boundingCoordinates' %in% names(site.ls)){
      fieldData <- rbind(fieldData,
                    data.frame(fieldTreatmentID = unlist(strsplit(site.ls$geographicDescription, 
                                                      split=' -- '))[1],
                                    description=unlist(strsplit(site.ls$geographicDescription,
                                                                split=' -- '))[2],
                                    lat=site.ls$boundingCoordinates$northBoundingCoordinate,
                                    lon=site.ls$boundingCoordinates$westBoundingCoordinate))
    }
  }
  fieldData$fieldName <- 'Bonanza Creek LTER'
  
  fieldTreatment <- fieldData[, c('fieldTreatmentID', 'description')]
  fieldData <- unique(fieldData[, c('fieldName', 'lat', 'lon')])
  
  ##Pull creator information
  labData <- data.frame()
  for(personel.ls in xlm_ls$dataset[names(xlm_ls$dataset) %in% 'creator']){
    personelInfo <- c("individualName.givenName",
                      "individualName.surName",   "positionName",
                      "electronicMailAddress",    "onlineUrl")
    orgInfo <- c('organizationName', 'electronicMailAddress', 'onlineUrl')
    if(all(personelInfo %in% names(unlist(personel.ls)))){
      labData <- rbind.fill(labData,
                            data.frame(t(unlist(personel.ls)[personelInfo])))
    }else if(all(orgInfo %in% names(unlist(personel.ls)))){
      labData <- rbind.fill(labData,
                            data.frame(t(unlist(personel.ls)[orgInfo])))
    }
  }
  labData$lab_ID <- 'Harden-Turetsky'
  
  ##Pull column names and information
  tableMeta <- data.frame()
  for(column.ls in xlm_ls$dataset$dataTable$attributeList){
    tableMeta <- rbind(tableMeta,
                       data.frame(Name=column.ls$attributeName, Label=column.ls$attributeLabel,
                                  Definition=column.ls$attributeDefinition, 
                                  Type=column.ls$storageType,
                                  Scale=paste0(unlist(column.ls$measurementScale), 
                                               collapse=' - '),
                                  comment=ifelse(is.null(column.ls$comment), '', 
                                                 column.ls$comment)))
  }
  tableMeta$columnIndex <- paste('column', row.names(tableMeta), sep='_')
  
  
  data.df <- read.csv(sprintf('%sHardon2005/335_BNZ_moisturegradient_isotopestudy_2005_LTER.txt',
                              dir))
  
  #human check the naming
  print(rbind(as.character(tableMeta$Name), names(data.df)))
  
  names(data.df)[ 7:ncol(data.df)] <- paste('column', 7:ncol(data.df), sep='_')
  
  data.df <- melt(data.df, id.vars=names(data.df)[1:6], variable.name='columnIndex')
  
  tableMeta$IncubationTime <- NA
  tableMeta$IncubationTime[grepl('\\d+ ((hours)|(hrs)|(days))', as.character(tableMeta$Name))] <-
    regmatches(as.character(tableMeta$Name), regexpr('\\d+ ((hours)|(hrs)|(days))', 
                                                     as.character(tableMeta$Name)))
  tableMeta$IncubationTime[grepl('initial', tableMeta$Name)] <- '2 days'
  tableMeta$IncubationTime.units <- NA
  tableMeta$IncubationTime.units[grepl('\\d+ ((hours)|(hrs)|(days))', 
                                       as.character(tableMeta$IncubationTime))] <- 
    regmatches(as.character(tableMeta$IncubationTime), regexpr('((hours)|(hrs)|(days))', 
                                                    as.character(tableMeta$IncubationTime)))
  tableMeta$IncubationTime <- gsub(' ((hours)|(hrs)|(days))', '', 
                                   as.character(tableMeta$IncubationTime))
  tableMeta$measure_id <- paste(ifelse(grepl('14C',tableMeta$Name), 'd14C_', ''), 
                                paste(ifelse(grepl('13C',tableMeta$Name), 'd13C_', ''), 
                                      ifelse(grepl('(CO2)|(14C)', tableMeta$Name),
                                             'CO2_flux_lab_48hr', ''), sep=''), sep='')
  tableMeta$measure_units <- ifelse(grepl('^d',tableMeta$measure_id), 'ppm', 
                               ifelse(grepl('ppm/d', tableMeta$Scale), 'ppm cm-soil^-3 day^-1',
                                           ifelse(grepl('mgCO2/d', tableMeta$Scale), 
                                                  'mg-CO2 cm-soil^-3 day^-1',
                                                  '')))
  
  soilVolume <-  5*pi*(4.25/2)^2 #(From methods) preserved core size 5 cm of soil using a 4.25 cm
  
  data.df <- merge(data.df, tableMeta, by='columnIndex')
  data.df$value <- data.df$value/(grepl('cm-soil', data.df$measure_units)*soilVolume + 
                                    !grepl('cm-soil', data.df$measure_units))
  data.df$DOI <- '10.6073/pasta/9b363cc74bcd784cfcee85e6920f2989'
  data.df$Warming.status <- ifelse(grepl('warm', data.df$Warming.status), 
                                   'field_warming_NAC', 'control')
  
  #time (collection date), depth.min, depth.max, depth.unit
  fieldData$'mm-dd-yyyy' <- unique(data.df$Sampling.Date)
  fieldData$depth.unit <- 'cm'
  #fieldData <- rbind(fieldData, fieldData) #quick and dirty hack
  fieldData <- data.frame(fieldData,
                          Depth=as.character(unique(data.df$Depth)),
                          depth.min = as.numeric(as.character(unlist(data.frame(strsplit(
                            as.character(unique(data.df$Depth)), split='-'))[1,]))),
                          depth.max = as.numeric(as.character(unlist(data.frame(strsplit(
                            as.character(unique(data.df$Depth)), split='-'))[2,]))))
  fieldData$fieldID <- paste('BC-LTER', fieldData$Depth, sep='_')
  
  fieldTreatment <- merge(fieldTreatment, unique(data.df[, c('Warming.status', 'Site')]), 
                          by.x='fieldTreatmentID', by.y='Site', all=TRUE)
  fieldTreatment$vegID <- fieldTreatment$fieldTreatmentID
  fieldTreatment$Site <- fieldTreatment$vegID
  fieldTreatment$fieldTreatmentID <- with(fieldTreatment, 
                                          sprintf('%s_%s', fieldTreatmentID, Warming.status))
  
  data.df <- merge(data.df, fieldTreatment)
  data.df$lab_ID <- unique(labData$lab_ID) #Only one ID
  data.df <- merge(data.df, fieldData)
  
  return(list(data=data.df[c('lab_ID', 'fieldID', 'fieldTreatmentID', 'Sample.ID', 
                             'IncubationTime', 
                             'IncubationTime.units', 'measure_id', 'value', 'measure_units')],
              field=fieldData,
              fieldTreatment=fieldTreatment,
              lab=labData,
              labTreatment=NA))
}