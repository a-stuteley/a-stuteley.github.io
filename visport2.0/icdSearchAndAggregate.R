#script that will essentially be able to pull the microdata from an ICD code


###########################
#Preamble - microdata load#
###########################

setwd("C:/Users/astut/Desktop/porting/datasets")
library(reshape)
microdata <- read.csv("processed_microdata.csv", header = TRUE)

############################
#CSV creator for chosen ICD#
############################

createCSV <- function (md = microdata, filename = "data.csv", icd = NA, ...) {
  #first reduction via icd code
  if (is.na(icd)) {
    md_icd <- md
  } else {
    md_icd <- md[which(md$icdd == rep(icd, each = length(md$icdd) * length(icd))) %% length(md$icdd), ]
  }
  
  #second reduction via ethnicity
  md_eth_to <- md_icd[ , c(1, 15, 2, 16)]
  md_eth_to$eth <- "Total"
  md_eth_ma <- md_icd[which(is.element(md_icd$ETHNICG1, 21) | is.element(md_icd$ETHNICG2, 21) | is.element(md_icd$ETHNICG3, 21)), c(1, 15, 2, 16)]
  md_eth_ma$eth <- "Maori"
  md_eth_nm <- md_icd[which(!(is.element(md_icd$ETHNICG1, 21) | is.element(md_icd$ETHNICG2, 21) | is.element(md_icd$ETHNICG3, 21))), c(1, 15, 2, 16)]
  md_eth_nm$eth <- "Non-Maori"
  
  md_eth <- rbind(md_eth_to, md_eth_ma, md_eth_nm)
  
  raw_counts <- aggregate(DOD ~ eth + GENDER + year + ageband, data = md_eth, FUN = function (x) { NROW(x) } )
  raw_total_eth <- aggregate(DOD ~ eth + GENDER + year, data = md_eth, FUN = function (x) { NROW(x) } )
  raw_total_gen <- aggregate(DOD ~ eth + year + ageband, data = md_eth, FUN = function (x) { NROW(x) } )
  raw_total_tot <- aggregate(DOD ~ eth + year, data = md_eth, FUN = function (x) { NROW(x) } )
  
  raw_total_eth$ageband <- "Total"
  raw_total_gen$GENDER <- "Total"
  raw_total_tot$ageband <- "Total"
  raw_total_tot$GENDER <- "Total"
  
  raw_merged <- rbind(raw_counts, raw_total_eth, raw_total_gen, raw_total_tot)
  
  u_remove <- raw_merged[-which(raw_merged$GENDER == "U"), ]
  
  u_remove$GENDER <- gsub("M", "Male", u_remove$GENDER, perl = TRUE)
  u_remove$GENDER <- gsub("F", "Female", u_remove$GENDER, perl = TRUE)
  
  u_remove$pop <- paste(u_remove$GENDER, u_remove$eth, sep = " ")
  u_remove$pop <- gsub("Total ", "", u_remove$pop, perl = TRUE)
  u_remove$pop <- gsub(" Total", "", u_remove$pop, perl = TRUE)
  
  levels(u_remove$ageband)[1] <- "00.04"
  levels(u_remove$ageband)[10] <- "05.09"
  levels(u_remove$ageband)[17] <- "80+"
  u_remove$ageband <- gsub("[.]", "-", u_remove$ageband, perl = TRUE)
  
  reduced <- with(u_remove, data.frame(ageband = ageband, year = year, pop = pop, deaths = DOD))
  
  #only need to add dynamic denominators
  popestm91 <- createDenoms("popest91maorinat.csv", "Maori")
  popestnm91 <- createDenoms("popest91nonmaorinat.csv", "Non-Maori", sepa = ";")
  popestt91 <- createDenoms("popest91totalnat.csv")
  popestm90 <- createDenoms("popestdisc90maorinat.csv", "Maori")
  popestnm90 <- createDenoms("popestdisc90nonmaorinat.csv", "Non-Maori",sepa = ";")
  popestt90 <- createDenoms("popestdisc95totalnat.csv")
  
  popest <- rbind(popestm91, popestnm91, popestt91, popestm90, popestnm90, popestt90[-which(popestt90$year > 1990), ])
  poppre <- popest[-which(popest$year < 1996), ]
  
  #now bind via some matching and question of standards
  final <- merge(reduced, poppre)
  
  setwd("C:/Users/astut/Desktop/porting/datasets")
  
  write.csv(x = final, file = filename, row.names = FALSE, quote = FALSE)
}

########################
#Setting up denominator#
########################

createDenoms <- function (filename, eth = "Total", sepa = ",") {
  
  setwd("C:/Users/astut/Desktop/appui/data/denominator")
  
  popest <- read.csv(filename, header = TRUE, sep = sepa)
  
  pe <- melt(popest, id = c("Year", "Factor"))
  
  pe$Year <- rep(pe$Year[-which(is.na(pe$Year))], each = 3)
  
  pe$Factor <- paste(pe$Factor, eth, sep = " ")
  pe$Factor <- gsub("Total ", "", pe$Factor, perl = TRUE)
  pe$Factor <- gsub(" Total", "", pe$Factor, perl = TRUE)
  
  pe$variable <- gsub("X0.4", "00-04", pe$variable, perl = TRUE)
  pe$variable <- gsub("X5.9", "05-09", pe$variable, perl = TRUE)
  pe$variable <- gsub("X", "", pe$variable, perl = TRUE)
  pe$variable <- gsub("[.]and[.]over", "+", pe$variable, perl = TRUE)
  pe$variable <- gsub("[.]", "-", pe$variable, perl = TRUE)
  
  colnames(pe) <- c("year", "pop", "ageband", "people")
  
  pe
}

##################
#Getting the data#
##################

createCSV(microdata, "output.csv")

#think about reading in text files of icd coding, could be easier?
#icdgroup <- scan("testscan.txt", what = character())






