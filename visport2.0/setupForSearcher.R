#microdata clean up
#idea is to create a search and constructor via ICD9/ICD10 through java

setwd("C:/Users/astut/Desktop/porting/datasets")

raw_microdata <- read.csv("mos3371.csv", header = TRUE)

datareduce <- raw_microdata[ , c(13, 14, 20, 15:17, 66, 9, 31, 68:70, 32, 34)]

dmy <- as.Date(datareduce[ , 1], "%d/%m/%Y")
datareduce[ , 1] <- dmy
datareduce$year <- as.numeric(format(dmy, "%Y")) 

startingDate <- 1996
dd <- datareduce[datareduce$year > 1995, ]

age_band <- seq(from = 0, to = 80, by = 5)
age_band_2 <- character(length(age_band) - 1)
for (i in 1:(length(age_band) - 1)) {
  age_band_2[i] <- paste(as.character(age_band[i]), as.character(age_band[i] + 4), sep = ".")
}
age_band_2 <- c(age_band_2, "80 and over", "Total")

variable <- function (data, existing) {
  location <- grep(existing, colnames(data))
  newLocation <- ncol(data) + 1
  age_band = c(age_band, 1000)
  for (i in 2:(length(age_band_2))) {
    data[(data[ , location] < age_band[i] & data[ , location] >= age_band[i - 1]), newLocation] <- age_band_2[i - 1]
  }
  colnames(data)[newLocation] <- "ageband"
  return(data)
}

pp <- variable(dd, "AGE_AT_DEATH_YRS")
head(pp)

write.csv(x = pp, file = "processed_microdata.csv", row.names = FALSE, quote = FALSE)

#example for constructing such a data frame
#newdf <- pp[which(pp$icdd == "C55"), ]

#can make ethnic splits here
#pcode <- c(30, 31, 32, 33, 34, 35, 36, 37)
#acode <- c(40, 41, 42, 43, 44)

#then aggregate to get counts
#aggregate(DOD ~ GENDER + year + ageband, data = pp, FUN = function (x) {NROW(x)})