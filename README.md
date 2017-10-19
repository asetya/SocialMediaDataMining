
# SocialMediaDataMining
It is an experimental work on social media data collection and simple processing 

#adapted and modified from https://www.tutorialspoint.com/big_data_analytics/data_collection.htm 
# and from : http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know

#Steps : 
#1. install packages IN r  : 
install.packages(c("devtools", "rjson", "bit64", "httr"))  
# Make sure to restart your R session at this point 
library(devtools) 
install_github("geoffjentry/twitteR") 

install.packages("tm")  # for text mining
install.packages("SnowballC") # for text stemming
install.packages("wordcloud") # word-cloud generator 
install.packages("RColorBrewer") # color palettes



#2. Set up twitter application 

Go to https://apps.twitter.com/app/new and log in.
After filling in the basic info, go to the “Permission" tab and select "Read, Write and Access direct messages"
 Make sure to click on the save button after doing this
 In the "Details" tab and access tokens , take note of your consumer key, consumer secret, acces_token and access_token_secreet 
consumer_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
consumer_secret = "bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
access_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
access_token_secret= "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

#3. Back to R 
Enter the value of consumer key, consumer secret, acces_token and access_token_secreet in R source code 
