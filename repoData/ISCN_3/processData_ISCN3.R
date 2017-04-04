library(xlsx)
library(reshape2)

##Out of memory erros
#header <- read.xlsx('Layers/ISCN_ALL_DATA_LAYER_C1_1-1.xlsx', sheetIndex=1, startRow=1, endRow=2)
#data.df <- read.xlsx2('Layers/ISCN_ALL_DATA_LAYER_C1_1-1.xlsx', sheetIndex=1)

header <- read.csv('Layers/ISCN_ALL_DATA_LAYER_C1_1-1.csv', nrows=1, header=FALSE)

data.df <- read.csv('Layers/ISCN_ALL_DATA_LAYER_C1_1-1.csv', stringsAsFactors=FALSE)
format(object.size(data.df), units='Mb')

#trim replicates
data.df <- subset(data.df, !grepl('ISCN SOC stock', dataset_name_soc))
format(object.size(data.df), units='Mb')

data.df <- unique(data.df)
format(object.size(data.df), units='Mb')

vocab.df <- data.frame(header=unlist(header),
                       measurement=gsub(' \\(.*\\)', '', unlist(header)),
                       unit=gsub('\\)', '', gsub('.* \\(', '', unlist(header))),
                       stringsAsFactors=FALSE)
vocab.df$unit[vocab.df$measurement == vocab.df$unit] <- NA
vocab.df$unit[grepl('ph_(cacl|h2o|other)', vocab.df$measurement)] <- 'unitless'
vocab.df$unit[grepl('root_quant_size', vocab.df$measurement)] <- 'unitless'
vocab.df$unit[92:95] <- 'unitless'
vocab.df$dataNum <- 1:nrow(vocab.df)
vocab.df$fieldNum <- c(1:22, rep(NA, length=nrow(vocab.df)-22))
vocab.df$measureNum <- NA
vocab.df$measureNum[!is.na(vocab.df$unit) & is.na(vocab.df$fieldNum)] <- 1+(1:sum(!is.na(vocab.df$unit) & is.na(vocab.df$fieldNum)))
vocab.df$measureNum[grepl('layer_name', vocab.df$header)] <- 1

type.arr <- sort(c('bd', 'c', 'soc', 'ph', 'wpg2', 'al', 'bc', 'metal_ext', 'p', 'oc', 'loi', 'caco3', 'sand', 'silt', 'clay', 'cat_exch', 'fe', 'mn', 'ca', 'k', 'mg', 'na', 'base_sum', 'cec', 'ecec', 'bs', 'h', 'zn', 'root_quant_size', 'root_weight', '15c', '13c', '14c', 'fraction_modern', 'textureClass', 'locator_parent_alias'))

repeats <- names(table(data.df$layer_name)[table(data.df$layer_name) > 1])
field.df <- data.df[,1:22]
measurements.df <- data.df[,c(12, 23:95)]

