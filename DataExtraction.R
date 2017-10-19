#adapted and modified from :
#1. https://www.tutorialspoint.com/big_data_analytics/
#2. http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know

rm(list = ls(all = TRUE)); gc() # Clears the global environment
#panggil library utnuk berhubungan dengan twiter jika belum terisntall 
#install package twitteR and text minning 
# see the prior tep to access twitter in : 
library(twitteR)
library("tm") 
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
Sys.setlocale(category = "LC_ALL", locale = "C")

#masukan paramater untuk berhubungan dengan twitter 
consumer_key = "OwiALywKeYsEybOhhCXGT29rn"
consumer_secret = "bxod8IXYKeLBCxZiAVfP0ybifdPRAUp0k0o3ccHE8SVBHJLrmG"
access_token = "83317394-p0CviDybDTOgQBsZXuBUT22Aw3ZK6Scng5C0mRWCV"
access_token_secret= "10TbRUcGzg2WIdf1MJtjUqZemwDouevJUVRRSkwYJ3ILb"
#---------------------------
# konek dengan twitter 
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_token_secret)

# masukan keyword yang akan dipakai 
keyword <-'jakarta'
#--------------------
#ambil data dari twitter untuk tweets yang mengandung keyword sejumlah n 
#dan bahasa = id 
tweets <- searchTwitter(keyword, n = 1000, lang = 'id')
df <- twListToDF(tweets) #masukan tweets ke dataframe bernama df
#----------------------------------------------------------------

# Take a look at the data
head(df)

#Mengambil statistik tweets
# 
sources <- sapply(tweets, function(x) x$getStatusSource()) #asal device 
sources <- gsub("</a>", "", sources)
sources <- strsplit(sources, ">")
sources <- sapply(sources, function(x) ifelse(length(x) > 1, x[2], x[1]))
source_table = table(sources)
source_table = source_table[source_table > 1]
freq = source_table[order(source_table, decreasing = T)]
as.data.frame(freq)
#--------------------------------------------
#head(df$text)


# Konversi -  encoding of the text dari  latin1 ke  ASCII
df$text <- sapply(df$text,function(row) iconv(row, "latin1", "ASCII", sub = ""))

# Create a function to clean tweets
clean.text <- function(tx) {
  tx <- gsub("htt.{1,20}", " ", tx, ignore.case = TRUE)
  tx = gsub("[^#[:^punct:]]|@|RT", " ", tx, perl = TRUE, ignore.case = TRUE)
  tx = gsub("[[:digit:]]", " ", tx, ignore.case = TRUE)
  tx = gsub(" {1,}", " ", tx, ignore.case = TRUE)
  tx = gsub("^\\s+|\\s+$", " ", tx, ignore.case = TRUE)
  tx = gsub("jakarta", " ", tx, ignore.case = TRUE)
  tx = gsub("jaka", " ", tx, ignore.case = TRUE)
  
  
  return(tx)
}  
#cleaning the tweets text 
text <- lapply(df$text, clean.text)
#---------------------------------------


docs <- Corpus(VectorSource(text))
#dx <-Corpus(VectorSource(text))
#docs<-dx
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")
#docs <- tm_map(docs, toSpace, "")
#docs<-tm_map( docs, toSpace, "https*")
# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("dong", "itu", "dan", keyword))



# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)
set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))
findFreqTerms(dtm, lowfreq = 4)
findAssocs(dtm, terms = "gubernur", corlimit = 0.3)

#menampilkan statistik 10 kata terbanyak 
head(d, 10)
barplot(d[1:10,]$freq, las = 2, names.arg = d[1:10,]$word,
        col ="blue", main ="Kata Paling Sering",
        ylab = "Frekfensi")
axis(2, at = 0:5, labels = 0:5)
#legend("topright", colnames(d[1:10,]$word), fill = colors, bty = "n")
