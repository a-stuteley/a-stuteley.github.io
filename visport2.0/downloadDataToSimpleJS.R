#Alexander Stuteley

#data directory
setwd("C:/Users/astut/Desktop/porting/datasets/first data setup")

#function to take and combine data into ready to run through app form
combineAndForm <- function (file1, file2, file3, outfile) {
  full <- rbind(file1, file2, file3) 
  full_strip <- full[ , -c(1, 4, 11:17)]
  full_strip_sort <- full_strip[ , c(1:2, 9, 6:8, 3:5)]
  colnames(full_strip_sort)[3] <- "pop"
  full_strip_sort$pop <- substring(full_strip_sort$pop, 1, nchar(as.character(full_strip_sort$pop)) - 6)
  levels(full_strip_sort$ageband) <- c(levels(full_strip_sort$ageband)[1:8], "05-09", levels(full_strip_sort$ageband)[10:16], "10-14", "Total")
  full_strip_sort[ , 4:6] <- round(full_strip_sort[ , 4:6], 2)
  full_strip_sort[ , 4:9][which(is.na(full_strip_sort[ , 4])) , ] <- 0
  write.csv(x = full_strip_sort, file = paste("built/", outfile, sep = ""), row.names = FALSE, quote = FALSE)
}

f1 <- read.csv("total.csv", header = T, sep = ";")
f2 <- read.csv("maori.csv", header = T, sep = ";")
f3 <- read.csv("nonmaori.csv", header = T, sep = ";")

combineAndForm(f1, f2, f3, "mort.csv")



f1 <- read.csv("gastric_d_total.csv", header = T, sep = ";")
f2 <- read.csv("gastric_d_maori.csv", header = T, sep = ";")
f3 <- read.csv("gastric_d_nonmaori.csv", header = T, sep = ";")

combineAndForm(f1, f2, f3, "gastric_d.csv")



f1 <- read.csv("gastric_i_total.csv", header = T, sep = ";")
f2 <- read.csv("gastric_i_maori.csv", header = T, sep = ";")
f3 <- read.csv("gastric_i_nonmaori.csv", header = T, sep = ";")

combineAndForm(f1, f2, f3, "gastric_i.csv")
