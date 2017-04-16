processMethodBlock <- function(methodNames=NULL, unitName=NULL,
                               sampleTemp, unit.df=NULL){
  
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
  sampleTemp <- melt(sampleTemp, id.vars=c(c('fieldID', 'method'), unitName), 
                     variable.name='measurement', 
                     na.rm=TRUE, forceNumericValue=TRUE)
  
  if(!is.null(unitName)){
    names(sampleTemp)[3] <- 'unit'
  }else if(is.null(unitName) & !is.null(unit.df)){
    #units
    sampleTemp <- merge(sampleTemp, unit.df[,c('measurement', 'unit')])
  }else{
    warning('units not specified')
  }
  
  #issolate unique measurements
  measurementTemp <- unique(sampleTemp[c('measurement','method')])
  measurementTemp$measurementID <- sprintf('%s_%02d', measurementTemp$measurement, 
                                           1:nrow(measurementTemp))
  sampleTemp <- merge(sampleTemp, measurementTemp)[, c('fieldID', 'measurementID',
                                                       'value', 'unit')]
  
  #rename stuff
  names(measurementTemp)[1] <- 'type'
  
  sampleTemp$value <- as.numeric(sampleTemp$value)
  
  return(list(sample=sampleTemp, measurement=measurementTemp))
  
}