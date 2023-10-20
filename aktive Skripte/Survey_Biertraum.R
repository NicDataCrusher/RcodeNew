####Loading Packages ####

library(dbplyr)
library(Matrix)
library(NLP)
library(stringr)
library(stringi)
library(tidyverse)
library(readr)
library(wordcloud)
install.packages("topicmodels")
#### Loading Data ####
Bt_Survey <- as.data.frame(daten_fragebogen_beta_test)
names(Bt_Survey) <- c("doc_id", "Rating", "Liked", "TbImproved")

U_R_Liked <- Bt_Survey[,c("doc_id", "Rating", "Liked")] %>% filter_at(vars(Rating, Liked),any_vars(!is.na(.)))
U_R_Liked$Rating <- as.numeric(U_R_Liked$Rating)
names(U_R_Liked) <- c("doc_id", "rating", "text")

U_R_TbImproved <- Bt_Survey[,c("doc_id", "Rating", "TbImproved")] %>% filter_at(vars(Rating, TbImproved), any_vars(!is.na(.)))
U_R_TbImproved$Rating <- as.numeric(U_R_TbImproved$Rating)
names(U_R_TbImproved) <- c("doc_id", "rating", "text")

Liked_Corpus <- VCorpus(                            # Diese Funktion erstellt den Korpus
  DataframeSource(U_R_Liked),                 # Verwandelt unseren DataFrame in eine
  # "Source" (Quelle) f?r den Korpus um
  readerControl = list(reader = readDataframe)  # Erkl?rt der Funktion VCorpus, wie die
  # Informationen aus dem DataFrame 
)                       

TbImpoved_Corpus <- VCorpus(                            # Diese Funktion erstellt den Korpus
  DataframeSource(U_R_TbImproved),                 # Verwandelt unseren DataFrame in eine
  # "Source" (Quelle) f?r den Korpus um
  readerControl = list(reader = readDataframe)  # Erkl?rt der Funktion VCorpus, wie die
  # Informationen aus dem DataFrame 
)                       


Liked_Corpus[[19]]$content



skipWords <- function(x) removeWords(x, c(stopwords("german"), "o"))
funs <- list(stripWhitespace,
             skipWords,
             removePunctuation,
             content_transformer(tolower))
Liked_Corpus <- tm_map(Liked_Corpus, FUN = tm_reduce, tmFuns = funs)


TbImpoved_Corpus <- tm_map(TbImpoved_Corpus, FUN = tm_reduce, tmFuns = funs)


TbImproved_Corpus[[19]]$content


Liked_DTM <- DocumentTermMatrix(Liked_Corpus)
TbImproved_DTM <- DocumentTermMatrix(TbImproved_Corpus)
inspect(TbImproved_DTM)

LikedLDA <- LDA(Liked_DTM, 3, method = "Gibbs")




