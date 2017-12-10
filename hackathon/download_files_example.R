#trying to load dataset directly from pangaea
library(rvest)
library(stringr)
library(utils)

temp <- tempfile()
download.file("https://doi.pangaea.de/10.1594/PANGAEA.864866?format=zip",temp)
data <- read.table(unz(temp, "datasets/Walz_2016_depthaerobic.tab"), skip=32, sep="\t", header=T)
unlink(temp)


