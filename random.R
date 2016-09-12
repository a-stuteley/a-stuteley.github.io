setwd("js/attempt/")
y = abs(rnorm(1000) * 1000)
x = abs(y + rnorm(1000, 0, 20))
d = data.frame(noise = x, rand = y)
write.csv(d, file = "random.csv", quote = FALSE, row.names = FALSE)


refpopext = read.delim("~/js/barchart/refpopext.tsv")
da = refpopext[1,2:18]
db = unlist(da)

names(db) = gsub("X", "", names(db))
names(db) = gsub("[[:punct:]]", "-", names(db))
df = data.frame(rate = db, rate2 = db + 0.05, year = 1996:2012)
write.csv(df, file = "rate.csv", quote = FALSE, row.names = FALSE)
