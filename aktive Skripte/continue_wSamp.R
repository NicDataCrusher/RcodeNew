library(textdata)
library(stringr)
library(SnowballC)
library(tidytext)
library(word2vec)
library(quanteda)
library(keyATM)
library(tm)
library(dplyr)

#Pseudo Code



summary(user_profiles)








revs_w_text <- rev_text %>% filter(word_count>75)

revs_w_text <- revs_w_text[c(1:10000),]

beer_w_text <- beer_docs %>% filter(notes != "No notes at this time.")



# Remove punctuation, convert to lower case, and remove extra whitespace

rev_docs_processed <- revs_w_text %>%
  mutate(text = str_replace_all(text, "[[:punct:]]", "")) %>%
  mutate(text = tolower(text)) %>%
  mutate(text = str_squish(text))

 rev_words <- rev_docs_processed %>%
  unnest_tokens(word, text)%>% 
   count(doc_id, word, sort = TRUE)

# Join the username to the rev_words data frame
rev_words <- rev_words %>%
  left_join(rev_docs %>% select(doc_id, username), by = "doc_id")


beer_word <- beer_w_text %>% 
  unnest_tokens(word, notes, to_lower = TRUE) %>% 
  count(beer_id, word, sort = TRUE)  
  
beer_word$doc_id <- as.character(beer_word$doc_id)



#Next, we combine the Text Data, to obtain a data set with all textual information, which we clean for stop words. 
#We can also use this combined data for topic modeling and finding embeddings for each document. 

combined_clean_words <- beer_word %>% bind_rows(rev_words)




                    
# Stem the words

combined_clean_words <- combined_clean_words %>%
  mutate(word = wordStem(word))
                  
# Create a document-term matrix in a tidy format 

combined_dtm <- combined_clean_words %>% cast_dtm(doc_id, word, nr_words)
inspect(combined_dtm)
combined_trimmed_dtm <- combined_dtm %>% removeSparseTerms(0.99)
inspect(combined_trimmed_dtm)

combined_trimmed_dfm <- dfm(combined_clean_words$word )
combined_trimmed_dfm@docvars[["docid_"]] <- combined_clean_words$doc_id


combined_trimmed_dfm@docvars[["docid_"]] <- as.factor(combined_trimmed_dfm@docvars[["docid_"]])

beers_trimmed_dfm <- combined_trimmed_dfm[grepl("^[0-9]+$", combined_trimmed_dfm@docvars$docid_), ]

user_samp <- drop(user_samp$total_words.x)


trimmed_dfm_beers <- combined_trimmed_dfm@docvars["docid_" =="^[0-9]+$"]
beers_key <- keyATM_read(texts = beers_trimmed_dfm)
visualize_keywords(beers_key, all_tags)
tail(combined_clean_words)

#Create a TFIDTF Matrix for beer descriptions

TF_IDF_beers <- combined_clean_words%>% filter(is.na(username) )%>% 
  bind_tf_idf(word, doc_id, nr_words) %>% 
  arrange(desc(tf-idf)) 

#Create a TF-IDF matrix for user-reviews

TF_IDTF_rev <- combined_clean_words%>% filter(!is.na(username) )%>% 
  bind_tf_idf(word, doc_id, nr_words) %>% 
  arrange(desc(tf-idf))

#filter TFIDF matrix by tags we assigned.
TF_IDTF_rev_hop_tags <- TF_IDTF_rev %>% filter(word %in% all_tags$hop_tags)
TFTF_IDTF_rev_malt_tags <- TF_IDTF_rev %>% filter(word %in% all_tags$malt_tags)


#summarize all Tags in a Vector
all_tags <- list(hop_tags = hop_tags, malt_tags = malt_tags, yeast_tags = yeast_tags, offFlavor_tags = offFlavor_tags, taste_tags = taste_tags, categorial_tags = categorial_tags, local_tags = local_tags)

# Convert the list to a dataframe
all_tags <- as.data.frame(all_tags, stringsAsFactors = FALSE)



#Research methods!!
# Create User-User Similarity Metrics
# Create Classification Process
# Use Metadata for Clustering? Or similarity measures? 


# Create a Word2Vec Model

combined_text <- beer_docs_text %>% rename(text=notes) %>% 
  bind_rows(rev_docs_text)

w2v_mod <- word2vec(combined_text$text, type = "skip-gram", window = 5, dim = 100, hs=TRUE, stopwords = all_stopwords$word)

embeddings <- as.matrix(w2v_mod)

summary(is.na(beer_docs_text))

row.names(rev_docs_text) <- rev_docs_text$doc_id
row.names(beer_docs_text) <- beer_docs_text$id
user_embeddings <-  doc2vec(w2v_mod, rev_docs_text)

beer_docs_text <- beer_docs_text[!beer_docs_text$notes == "", ]

beer_embeddings <- doc2vec(w2v_mod, beer_docs_text$notes)
rownames(beer_embeddings) <- beer_docs_text$id
#Research methods!!
# Create User-User Similarity Metrics
# Create Classification Process

library(stm)





#clustern
#cluster assignen
#user reviews nach cluster filtern
#logreg lernen auf good - bad 
#user- user similarity
#tags lernen und features bauen
#user- user similarity
#tfidtf reduce
#topc- models item-item similarity








