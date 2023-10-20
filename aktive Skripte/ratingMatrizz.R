rec_mod <- Recommender(re, method = "UBCF")
recs <- predict(rec_mod, re[24,])






summary(lm)

library(slac)

beer_matrix <- as.matrix(Beer_tfidf)
revs_matrix <- as.matrix(Revs_tfidf)

# Then convert these dense matrices to sparse matrices
beer_sparse <- as(beer_matrix, "CsparseMatrix")
revs_sparse <- as(revs_matrix, "CsparseMatrix")
# Convert DocumentTermMatrix objects to sparse matrices



# Initialize similarity matrix
user_item_similarity <- matrix(0, nrow = nrow(revs_sparse), ncol = nrow(beer_sparse))

# Loop through users and beers to compute similarity
for (Docs in 1:nrow(revs_sparse)) {
  for (beer_index in 1:nrow(beer_sparse)) {
    
    # Find common terms for the user and the beer
    common_indices <- intersect(
      which(revs_sparse[Docs, ] != 0), 
      which(beer_sparse[beer_index, ] != 0)
    )
    
    # If there are common terms, compute the cosine similarity
    if (length(common_indices) > 0) {
      user_vector <- as.vector(revs_sparse[Docs, common_indices])
      beer_vector <- as.vector(beer_sparse[beer_index, common_indices])
      similarity <- sum(user_vector * beer_vector) / 
        (sqrt(sum(user_vector^2)) * sqrt(sum(beer_vector^2)))
      user_item_similarity[Docs, beer_index] <- similarity
    }
  }
}
user_item_similarity <- as(user_item_similarity, "CsparseMatrix")


#Combining the Corpi for Word2Vec
combined_revs_beers <- c(rev_tidy_docs$text, beer_tidy_docs)
combined_revs_beers <- as.character(combined_revs_beers)


#Kombiniere die Corpi und lerne das word2vec modell. Dann wende es auf jedes Dokument an um die Ähnlichkeit zu bestimmen. 

w2v_mod <- word2vec(combined_revs_beers, type = "skip-gram", window = 5, dim = 5, hs=TRUE)

rev_docs_vecs <- matrix(0, nrow(rev_tidy_docs), ncol(5))
user_docs_vecs <- doc2vec(w2v_mod, rev_tidy_docs$text)
beer_tidy_docs <- beer_tidy_docs[!beer_tidy_docs$text == "", ]
beer_tidy_docs <- beer_tidy_docs[!is.na(beer_tidy_docs$text), ]

beer_meta <- beers_filtered[!beers_filtered$text == "", ]
beer_meta <- beers_filtered[!is.na(beers_filtered$text), ]
beer_meta <- beer_meta[,-8]

beer_docs_vecs$doc_id <- rownames(beer_docs_vecs)

beer_docs_vecs <- doc2vec(w2v_mod, beer_tidy_docs$text)
rownames(beer_docs_vecs) <- beer_tidy_docs$id
user_docs_vecs$doc_id <- rev_tidy_docs$id
beer_docs_vecs <- as.data.frame(beer_docs_vecs)
user_docs_vecs <- as.data.frame(user_docs_vecs)
user_profiles_w2v <- as.data.frame(c(rev_meta, user_docs_vecs[,1:5]))

user_profiles_w2v$date <- as.Date(user_profiles_w2v$date)

beer_profiles_w2v <- as.data.frame(c(rev_meta, user_docs_vecs[,1:5]))

beer_profiles_w2v <- merge(beer_meta, beer_docs_vecs, by = "doc_id")








