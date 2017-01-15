#icd grouping trials

setwd("C:/Users/astut/Desktop/porting/datasets")
microdata <- read.csv("processed_microdata.csv", header = TRUE)

toOrder <- unique(microdata$icdd)
icdUnique <- sort(toOrder)

icd9 <- icdUnique[-grep("[A-Z]", icdUnique)]
icd9 <- droplevels(icd9)

icd9self <- icd9[which(as.numeric(as.character(icd9)) == 95000):which(as.numeric(as.character(icd9)) == 95909)]
icd9self <- droplevels(icd9self)

icd10 <- icdUnique[grep("[A-Z]", icdUnique)]
icd10 <- droplevels(icd10)

icd10accidents <- icd10[grep("[V-Y]", icd10)]
icd10accidents <- droplevels(icd10accidents)

icd10self <- icd10[grep("[X]", icd10)]
icd10selfmod <- as.numeric(gsub("X", "", icd10self))
icd10self <- icd10self[which(icd10selfmod == 64):which(icd10selfmod == 84)]
icd10self <- droplevels(icd10self)

write(c(as.character(icd9self), as.character(icd10self)), file = "icdself.txt", sep = " ")
