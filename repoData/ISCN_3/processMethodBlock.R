processMethodBlock <- function(methodNames=NULL, 
                               sampleTemp, headerInfo){
  
  ##Merge methods
  sampleTemp$method <- ''
  for(methodStr in methodNames){
    patternStr <- sprintf('%%s %s: %%s', methodStr)
    emptyStr <- sprintf('\\s+%s:\\s+$', methodStr)
    sampleTemp$method <- sprintf(patternStr, sampleTemp$method, sampleTemp[,methodStr])
    sampleTemp$method <- gsub(emptyStr, '', sampleTemp$method)
    sampleTemp$method <- gsub('^\\s+', '', sampleTemp$method)
    sampleTemp[,methodStr] <- NULL
  }
  
  #melt values
  sampleTemp <- melt(sampleTemp, id.vars=c('fieldID', 'method'), 
                     variable.name='measurement', 
                     na.rm=TRUE)
  
  #units
  sampleTemp <- merge(sampleTemp, headerInfo[,c('measurement', 'unit')])
  
  #issolate unique measurements
  measurementTemp <- unique(sampleTemp[c('measurement','method')])
  measurementTemp$measurementID <- sprintf('%s_%02d', measurementTemp$measurement, 
                                           1:nrow(measurementTemp))
  sampleTemp <- merge(sampleTemp, measurementTemp)[, c('fieldID', 'measurementID', 'value')]
  
  #rename stuff
  names(measurementTemp)[1] <- 'type'
  
  return(list(sample=sampleTemp, measurement=measurementTemp))
  
}