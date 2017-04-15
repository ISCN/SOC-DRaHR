library(xlsx)
library(reshape2)
library(plyr)

source('processMethodBlock.R')

##Out of memory erros
#header <- read.xlsx('Layers/ISCN_ALL_DATA_LAYER_C1_1-1.xlsx', sheetIndex=1, startRow=1, endRow=2)
#data.df <- read.xlsx2('Layers/ISCN_ALL_DATA_LAYER_C1_1-1.xlsx', sheetIndex=1)

data.df <- read.csv('Layers/ISCN_ALL_DATA_LAYER_C1_1-1.csv', stringsAsFactors=FALSE)
format(object.size(data.df), units='Mb')

#trim replicates
data.df <- subset(data.df, !grepl('ISCN SOC stock', dataset_name_soc))
format(object.size(data.df), units='Mb')

data.df <- unique(data.df)
format(object.size(data.df), units='Mb')

##process the header for units
header <- read.csv('Layers/ISCN_ALL_DATA_LAYER_C1_1-1.csv', nrows=1, header=FALSE)

header.df <- data.frame(header=unlist(header),
                       measurement=gsub(' \\(.*\\)', '', unlist(header)),
                       unit=gsub('\\)', '', gsub('.* \\(', '', unlist(header))),
                       stringsAsFactors=FALSE)
header.df$unit[header.df$measurement == header.df$unit] <- NA
header.df$unit[grepl('ph_(cacl|h2o|other)', header.df$measurement)] <- 'unitless'
header.df$unit[grepl('root_quant_size', header.df$measurement)] <- 'unitless'
header.df$unit[92:95] <- 'unitless'

##Set up the easy data frame
study.df <- data.frame(studyID = header[1], doi='10.17040/ISCN/1305039', permissions='acknowledgement')

lab.df <- data.frame(labID=unique(data.df[,2])) #ignore dataset_name_SOC, back out SOC later

fieldTreatment.df <- data.frame(fieldTreatmentID=NA) #no field treatment
labTreatment.df <- data.frame(labTreatmentID=NA) #no lab treatment

field.df <- unique(data.df[,4:22])
names(field.df) <- as.character(header.df$measurement[4:22])
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
header.df[c(12, 23:28),]
sampleTemp <- data.df[, c(12, 23:28)]
names(sampleTemp) <- header.df$measurement[c(12,23:28)]
names(sampleTemp)[1] <- 'fieldID'
headerTemp <- header.df[c(24:27), c('measurement', 'unit')]

temp <- processMethodBlock(methodNames=header.df$measurement[c(23, 28)],
                           sampleTemp=sampleTemp, headerInfo=headerTemp)

#merge results
measurement.df <- temp$measurement
sample.df <- temp$sample

#CARBON=====================
##Carbon, columns 29-33
header.df[c(12, 29:33),]
sampleTemp <- data.df[, c(12, 29:33)]
names(sampleTemp) <- header.df$measurement[c(12,29:33)]
names(sampleTemp)[1] <- 'fieldID'
headerTemp <- header.df[c(31:33), c('measurement', 'unit')]

temp <- processMethodBlock(methodNames=header.df$measurement[29:30],
                           sampleTemp=sampleTemp, headerInfo=headerTemp)

#merge results
measurement.df <- rbind.fill(measurement.df, temp$measurement)
sample.df <- rbind.fill(sample.df, temp$sample)

#=============================
##Nitrogen, columns 34-35
###TODO what method is associated with this?
header.df[c(12, 34:35),]
sampleTemp <- data.df[, c(12, 34:35)]
names(sampleTemp) <- header.df$measurement[c(12,34:35)]
names(sampleTemp)[1] <- 'fieldID'
headerTemp <- header.df[c(34:35), c('measurement', 'unit')]

temp <- processMethodBlock(methodNames=NULL,
                           sampleTemp=sampleTemp, headerInfo=headerTemp)

#merge results
measurement.df <- rbind.fill(measurement.df, temp$measurement)
sample.df <- rbind.fill(sample.df, temp$sample)

##SOC, columns 36-38
##pH, columns 39-42
##CaCO3, column 43
##Texture, columns 44, 46
##WPG2, columns 47 48
##Al, columns 50, 52, 59, 60
##Fe, columns 53, 55, 59, 60
##Mn, columns 56, 58, 59 ??60
##BC, columns 61:67
##CEC_h, columns 68:71
##bs, columns 72:73
##metal_ext, columns 74:77
##P, columns 78:83
##Root, column 84:85
##Isotope, 86:93
##textureClass, 94
##locator, 95

