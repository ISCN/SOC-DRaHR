library(xlsx)
library(reshape2)
library(plyr)
processData_ISCN3 <- function(){
  source('repoData/ISCN_3/processWorksheet.R')
  
  data1.ls <- processWorksheet(csvFile=
                                 'repoData/ISCN_3/Layers/ISCN_ALL_DATA_LAYER_C1_1-1.csv',
                               verbose=TRUE)
  
  data2.ls <- processWorksheet(csvFile=
                                 'repoData/ISCN_3/Layers/ISCN_ALL_DATA_LAYER_C2_1-1.csv',
                               verbose=TRUE)
  
  data3.ls <- processWorksheet(csvFile=
                                 'repoData/ISCN_3/Layers/ISCN_ALL_DATA_LAYER_C3_1-1.csv',
                               verbose=TRUE)
  
  data4.ls <- processWorksheet(csvFile=
                                 'repoData/ISCN_3/Layers/ISCN_ALL_DATA_LAYER_C4_1-1.csv',
                               verbose=TRUE)
  #merge easy========
  study.df <- data1.ls$study
  fieldTreatment.df <- data1.ls$fieldTreatment
  labTreatment.df <- data1.ls$labTreatment
  
  lab.df <- unique(rbind.fill(rbind.fill(rbind.fill(data1.ls$lab,data2.ls$lab), 
                                         data3.ls$lab), data4.ls$lab))
  
  field.df <- unique(rbind.fill(rbind.fill(rbind.fill(data1.ls$field,data2.ls$field), 
                                           data3.ls$field), data4.ls$field))
  field.df$value <- as.factor(field.df$value)
  field.df$layer_units <- as.factor(field.df$layer_units)
  
  
  fieldNotes.df <- field.df[,c('fieldID', 'measurement', 'value')]
  field.df <- unique(field.df[,c('fieldID', 'lat', 'long', 'observation_date', 
                                 'layer_top', 'layer_bot', 'layer_units')])
  #mergeMeasures====
  measureTemp.df <- 
    merge(merge(data1.ls$measurement, data2.ls$measurement, by=c('type', 'method'), 
                suffixes=c('.data1', '.data2'), all=TRUE),
          merge(data3.ls$measurement, data4.ls$measurement, by=c('type', 'method'), 
                suffixes=c('.data3', '.data4'), all=TRUE), all=TRUE)
  
  measureTemp.df <- ddply(measureTemp.df, c('type'), function(xx){
    xx$measurementID <- sprintf('%s_%02d', xx$type, 1:nrow(xx))
    return(xx)
  })
  measurement.df <- measureTemp.df[,c('type', 'method', 'measurementID')]
  
  #Construct samples========
  sample.df <- ddply(data1.ls$samples, 'measurementID', function(xx){
    #cat('replacing [', xx$measurementID[1])
    xx$measurementID <- subset(measureTemp.df,
                               xx$measurementID[1] == measurementID.data1)$measurementID
    #cat('] with [',xx$measurementID[1],']\n')
    return(xx)
  })
  
  sample.df <- rbind.fill(sample.df, 
                          ddply(data2.ls$samples, 'measurementID', function(xx){
                            #cat('replacing [', xx$measurementID[1])
                            xx$measurementID <- subset(measureTemp.df,
                                                       xx$measurementID[1] ==
                                                         measurementID.data2)$measurementID
                            #cat('] with [',xx$measurementID[1],']\n')
                            return(xx)
                          }))
  
  sample.df <- rbind.fill(sample.df, 
                          ddply(data3.ls$samples, 'measurementID', function(xx){
                            #cat('replacing [', xx$measurementID[1])
                            xx$measurementID <- subset(measureTemp.df,
                                                       xx$measurementID[1] == 
                                                         measurementID.data3)$measurementID
                            #cat('] with [',xx$measurementID[1],']\n')
                            return(xx)
                          }))
  
  sample.df <- rbind.fill(sample.df, 
                          ddply(data4.ls$samples, 'measurementID', function(xx){
                            #cat('replacing [', xx$measurementID[1])
                            xx$measurementID <- subset(measureTemp.df,
                                                       xx$measurementID[1] == measurementID.data4)$measurementID
                            #cat('] with [',xx$measurementID[1],']\n')
                            return(xx)
                          }))
  sample.df$fieldID <- as.factor(sample.df$fieldID)
  
  return(list(study=study.df, labTreatment=labTreatment.df, fieldTreatment=fieldTreatment.df,
              fieldNotes=fieldNotes.df, measurement=measureTemp.df, sample=sample.df))
}