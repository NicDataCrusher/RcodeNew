library(stm)

u_stm_corp <- readCorpus(RevsTM, type = "slam")

rev_metadata <- rev_metadata[rev_metadata$doc_id %in% names(u_stm_corp$documents),]


out <- prepDocuments(documents = u_stm_corp$documents, vocab = u_stm_corp$vocab, meta = rev_meta, lower.thresh = 50)
rev_meta <- rev_meta %>% 
  mutate_if(is.character, as.factor)
set.seed(421)
stm.search <- searchK(documents = out$documents,
                      vocab = out$vocab,
                      K = 10:30,
                      init.type = "Spectral",
                      prevalence = ~ overall + style + country + n.ratings + abv + country,
                      data = out$meta)

# Identify the missing indices
missing_indices <- setdiff(1:nrow(out$meta), 1:nrow(out$documents))

sum(is.na(u_stm_corp$documents))
sum(is.na(u_stm_corp$vocab))
sum(is.na(rev_meta))


# Remove the rows in out$meta corresponding to missing_indices
out$meta <- out$meta[-missing_indices, ]
plot(stm.search)