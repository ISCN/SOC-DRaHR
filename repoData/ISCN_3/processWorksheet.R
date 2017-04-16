processWorksheet <- function(csvFile='Layers/ISCN_ALL_DATA_LAYER_C1_1-1.csv',
                             verbose=TRUE){
  ##Out of memory erros
  #header <- read.xlsx('Layers/ISCN_ALL_DATA_LAYER_C1_1-1.xlsx', sheetIndex=1, startRow=1, endRow=2)
  #data.df <- read.xlsx2('Layers/ISCN_ALL_DATA_LAYER_C1_1-1.xlsx', sheetIndex=1)
  
  #Load file========
  if(verbose) cat('loading csv:', csvFile, '\n')
  data.df <- read.csv(csvFile, stringsAsFactors=FALSE)
  if(verbose) cat('inital size: ', format(object.size(data.df), units='Mb'), '\n')
  
  #trim replicates
  data.df <- subset(data.df, !grepl('ISCN SOC stock', dataset_name_soc))
  if(verbose) cat('trim ISCN SOC stocks: ', format(object.size(data.df), units='Mb'), '\n')
  
  data.df <- unique(data.df)
  if(verbose) cat('trim non-unique: ', format(object.size(data.df), units='Mb'), '\n')
  
  #Process header column =============
  ##process the header for units
  header <- read.csv(csvFile, nrows=1, header=FALSE)
  
  header.df <- data.frame(header=unlist(header),
                          measurement=gsub(' \\(.*\\)', '', unlist(header)),
                          unit=gsub('\\)', '', gsub('.* \\(', '', unlist(header))),
                          stringsAsFactors=FALSE)
  header.df$unit[header.df$measurement == header.df$unit] <- NA
  header.df$unit[grepl('ph_(cacl|h2o|other)', header.df$measurement)] <- 'unitless'
  header.df$unit[grepl('root_quant_size', header.df$measurement)] <- 'unitless'
  header.df$unit[92:95] <- 'unitless'
  
  #Set up study, lab, and treatment ===========
  ##Set up the easy data frame
  study.df <- data.frame(studyID = header[1], doi='10.17040/ISCN/1305039', permissions='acknowledgement')
  
  lab.df <- data.frame(labID=unique(data.df[,2])) #ignore dataset_name_SOC, back out SOC later
  
  fieldTreatment.df <- data.frame(fieldTreatmentID=NA) #no field treatment
  labTreatment.df <- data.frame(labTreatmentID=NA) #no lab treatment
  
  #set up field IDs============
  field.df <- unique(data.df[,c(4:22, c(84, 94, 95))])
  names(field.df) <- as.character(header.df$measurement[c(4:22, c(84, 94, 95))])
  field.df$fieldID <- field.df$layer_name
  field.df <- melt(field.df, id.vars=c('fieldID', 'lat', 'long', 'observation_date', 
                                       'layer_top', 'layer_bot'), 
                   variable.name='measurement', factorsAsStrings=TRUE)
  field.df$layer_units <- 'cm'
  field.df$layer_top <- as.numeric(as.character(field.df$layer_top))
  field.df <- field.df[!grepl('^\\s*$',field.df$value),]
  
  ####Pull data subsets, sampleID = fieldID = layer_name [12]
  #BulkDensity===================
  ##Bulk density columns 23:28
  #header.df[c(12, 23:28),]
  sampleTemp <- data.df[, c(12, 23:28)]
  names(sampleTemp) <- header.df$measurement[c(12,23:28)]
  names(sampleTemp)[1] <- 'fieldID'
  temp <- processMethodBlock(methodNames=header.df$measurement[c(23, 28)],
                             sampleTemp=sampleTemp, 
                             unit.df=header.df[c(24:27), c('measurement', 'unit')])
  #merge results
  measurement.df <- temp$measurement
  sample.df <- temp$sample
  
  #CARBON=====================
  ##Carbon, columns 29-33
  #header.df[c(12, 29:33),]
  sampleTemp <- data.df[, c(12, 29:33)]
  names(sampleTemp) <- header.df$measurement[c(12,29:33)]
  names(sampleTemp)[1] <- 'fieldID'
  headerTemp <- 
  
  temp <- processMethodBlock(methodNames=header.df$measurement[29:30],
                             sampleTemp=sampleTemp, 
                             unit.df=header.df[c(31:33), c('measurement', 'unit')])
  #merge results
  measurement.df <- rbind.fill(measurement.df, temp$measurement)
  sample.df <- rbind.fill(sample.df, temp$sample)
  
  #Nitrogen=============================
  ##Nitrogen, columns 34-35
  ###TODO what method is associated with this?
  #header.df[c(12, 34:35),]
  sampleTemp <- data.df[, c(12, 34:35)]
  names(sampleTemp) <- header.df$measurement[c(12,34:35)]
  names(sampleTemp)[1] <- 'fieldID'
  temp <- processMethodBlock(methodNames=NULL,
                             sampleTemp=sampleTemp, 
                             unit.df=header.df[c(34:35), c('measurement', 'unit')])
  #merge results
  measurement.df <- rbind.fill(measurement.df, temp$measurement)
  sample.df <- rbind.fill(sample.df, temp$sample)
  
  #SOC==================
  ##SOC, columns 36-38
  #header.df[c(12, 36:38),]
  sampleTemp <- data.df[, c(12, 36:38)]
  names(sampleTemp) <- header.df$measurement[c(12,36:38)]
  names(sampleTemp)[1] <- 'fieldID'
  temp <- processMethodBlock(methodNames=header.df$measurement[c(37:38)],
                             sampleTemp=sampleTemp, 
                             unit.df=header.df[c(36), c('measurement', 'unit')])
  #merge results
  measurement.df <- rbind.fill(measurement.df, temp$measurement)
  sample.df <- rbind.fill(sample.df, temp$sample)
  
  ##pH, columns 39-42
  #header.df[c(12, 39:42),]
  sampleTemp <- data.df[, c(12, 39:42)]
  names(sampleTemp) <- c('fieldID', header.df$measurement[c(39:42)])
  temp <- processMethodBlock(methodNames=header.df$measurement[c(39)],
                             sampleTemp=sampleTemp, 
                             unit.df=header.df[c(40:42), c('measurement', 'unit')])
  #merge results
  measurement.df <- rbind.fill(measurement.df, temp$measurement)
  sample.df <- rbind.fill(sample.df, temp$sample)
  
  ##CaCO3 + Texture + CAT exchange, column 43:46, 49
  #header.df[c(12, 43:46, 49),]
  sampleTemp <- data.df[, c(12, 43:46, 49)]
  names(sampleTemp) <- c('fieldID', header.df$measurement[c(43:46, 49)])
  temp <- processMethodBlock(methodNames=NULL,
                             sampleTemp=sampleTemp, 
                             unit.df=header.df[c(43:46, 49), c('measurement', 'unit')])
  #merge results
  measurement.df <- rbind.fill(measurement.df, temp$measurement)
  sample.df <- rbind.fill(sample.df, temp$sample)
  
  ##WPG2, columns 47 48
  #header.df[c(12, 47, 48),]
  sampleTemp <- data.df[, c(12, 47, 48)]
  names(sampleTemp) <- c('fieldID', header.df$measurement[c(47:48)])
  temp <- processMethodBlock(methodNames=header.df$measurement[47],
                             sampleTemp=sampleTemp, 
                             unit.df=header.df[c(47:48), c('measurement', 'unit')])
  #merge results
  measurement.df <- rbind.fill(measurement.df, temp$measurement)
  sample.df <- rbind.fill(sample.df, temp$sample)
  
  ##Al, columns 50, 52, 59, 60
  ##Fe, columns 53, 55, 59, 60
  ##Mn, columns 56, 58, 59 ??60
  #header.df[c(12, 50:60),]
  sampleTemp <- data.df[, c(12, 50:60)]
  names(sampleTemp) <- c('fieldID', header.df$measurement[c(50:60)])
  temp <- processMethodBlock(methodNames=header.df$measurement[60], 
                             unitName=header.df$measurement[59],
                             sampleTemp=sampleTemp)
  #merge results
  measurement.df <- rbind.fill(measurement.df, temp$measurement)
  sample.df <- rbind.fill(sample.df, temp$sample)
  
  #BC===============
  ##BC, columns 61:67
  #header.df[c(12, 61:67),]
  sampleTemp <- data.df[, c(12, 61:67)]
  names(sampleTemp) <- c('fieldID', header.df$measurement[c(61:67)])
  temp <- processMethodBlock(methodNames=header.df$measurement[67], 
                             unitName=header.df$measurement[66],
                             sampleTemp=sampleTemp)
  #merge results
  measurement.df <- rbind.fill(measurement.df, temp$measurement)
  sample.df <- rbind.fill(sample.df, temp$sample)
  
  #CEC===========
  ##CEC_h, columns 68:71
  #header.df[c(12, 68:71),]
  sampleTemp <- data.df[, c(12, 68:71)]
  names(sampleTemp) <- c('fieldID', header.df$measurement[c(68:71)])
  temp <- processMethodBlock(methodNames=NULL, 
                             unitName=header.df$measurement[71],
                             sampleTemp=sampleTemp)
  #merge results
  measurement.df <- rbind.fill(measurement.df, temp$measurement)
  sample.df <- rbind.fill(sample.df, temp$sample)
  #BS=======
  ##bs, columns 72:73
  sampleTemp <- data.df[, c(12, 72:73)]
  names(sampleTemp) <- c('fieldID', header.df$measurement[c(72:73)])
  temp <- processMethodBlock(methodNames=NULL, 
                             unitName=NULL,
                             unit.df=header.df[c(72:73), c('measurement', 'unit')],
                             sampleTemp=sampleTemp)
  #merge results
  measurement.df <- rbind.fill(measurement.df, temp$measurement)
  sample.df <- rbind.fill(sample.df, temp$sample)
  
  #Metal==========
  ##metal_ext, columns 74:77
  sampleTemp <- data.df[, c(12, 74:77)]
  names(sampleTemp) <- c('fieldID', header.df$measurement[c(74:77)])
  temp <- processMethodBlock(methodNames=header.df$measurement[77], 
                             unitName=header.df$measurement[76],
                             unit.df=NULL,
                             sampleTemp=sampleTemp)
  #merge results
  measurement.df <- rbind.fill(measurement.df, temp$measurement)
  sample.df <- rbind.fill(sample.df, temp$sample)
  
  #P ============
  ##P, columns 78:83
  sampleTemp <- data.df[, c(12, 78:83)]
  names(sampleTemp) <- c('fieldID', header.df$measurement[c(78:83)])
  temp <- processMethodBlock(methodNames=header.df$measurement[83], 
                             unitName=header.df$measurement[82],
                             unit.df=NULL,
                             sampleTemp=sampleTemp)
  #merge results
  measurement.df <- rbind.fill(measurement.df, temp$measurement)
  sample.df <- rbind.fill(sample.df, temp$sample)
  
  #Roots + Isotope + texture + locator
  ##Root, column 84:85 84is TEXT move to field description
  ##Isotope, 86:93
  ##textureClass, 94 TEXT move to field description
  ##locator, 95 TEXT move to field description
  sampleTemp <- data.df[, c(12, 85:93)]
  names(sampleTemp) <- c('fieldID', header.df$measurement[c(85:93)])
  temp <- processMethodBlock(methodNames=NULL, 
                             unitName=NULL,
                             unit.df=header.df[c(85:93),],
                             sampleTemp=sampleTemp)
  #merge results
  measurement.df <- rbind.fill(measurement.df, temp$measurement)
  sample.df <- rbind.fill(sample.df, temp$sample)
 
  return(list(study=study.df, field=field.df, lab=lab.df, 
              fieldTreatment=fieldTreatment.df, labTreatment=labTreatment.df, 
              measurement=measurement.df, samples=sample.df)) 
}