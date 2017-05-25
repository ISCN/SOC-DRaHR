#' Process a methods block
#' 
#' Force the samples to discard repeats
#'
#' @param methodNames 
#' @param unitName 
#' @param sampleTemp 
#' @param unit.df 
#'
#' @return
#' @export
#'
#' @examples
processMethodBlock <- function(methodNames=NULL, unitName=NULL,
                               sampleTemp, unit.df=NULL, verbose=FALSE){
  
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
  if(verbose) cat('flag1')
  #melt values
  sampleTemp <- unique(melt(sampleTemp, id.vars=c(c('fieldID', 'method'), unitName), 
                     variable.name='measurement', 
                     na.rm=TRUE, forceNumericValue=TRUE))
  if(verbose) cat('flag2')
  if(!is.null(unitName)){
    names(sampleTemp)[3] <- 'unit'
  }else if(is.null(unitName) & !is.null(unit.df)){
    #units
    sampleTemp <- merge(sampleTemp, unit.df[,c('measurement', 'unit')])
  }else{
    warning('units not specified')
  }
  if(verbose) cat('flag3')
  #issolate unique measurements
  measurementTemp <- unique(sampleTemp[c('measurement','method')])
  measurementTemp$measurementID <- sprintf('%s_%02d', measurementTemp$measurement, 
                                           1:nrow(measurementTemp))
  if(verbose) cat('flag4')
  sampleTemp <- merge(sampleTemp, measurementTemp)[, c('fieldID', 'measurementID',
                                                       'value', 'unit')]
  
  #rename stuff
  names(measurementTemp)[1] <- 'type'
  
  sampleTemp$value <- as.numeric(sampleTemp$value)
  if(verbose) cat('flag5')
  sampleTemp <- sampleTemp[sampleTemp$value != -999, ]
  if(verbose) cat('flag6')
  return(list(sample=sampleTemp, measurement=measurementTemp))
  
}