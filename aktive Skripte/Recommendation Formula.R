# Load required libraries
library(mlr)  # For machine learning tasks
library(dplyr)  # For data manipulation



u_u_meta_Recommendation <- function(u_a, user_profiles, rating_data, cluster = FALSE) {
  # Assuming user_profiles and rating_data are pre-processed and scaled
  
  if (cluster == TRUE) {
    # Tune and train KMeans model here, or pass it as an argument
    prediction <- predict(tunedKMeansModel, newdata = user_profiles[,])
    cluster <- prediction[["data"]][["response"]]
    user_neighbors_candidates <- user_profiles %>% filter(KMCluster == cluster)
  } else {
    user_neighbors_candidates <- user_profiles %>% sample_frac(size = 0.25)
  }
  
  user_neighbors <- rating_data %>% filter(user %in% user_neighbors_candidates$user) %>% dplyr::select(user, beer_id, overall) %>% as.data.frame()%>% 
    distinct(user, beer_id, .keep_all = TRUE)
  
  # Assuming makeU_I_rm, normalize, getList, evaluationScheme, Recommender, evaluate are pre-defined functions
  
  
  algorithmns <- list(
    IBCF_cos = list(name = "IBCF", param = list(method = "cosine")),
    IBCF_cor = list(name = "IBCF", param = list(method = "pearson")),
    UBCF_cos = list(name = "UBCF", param = list(method = "cosine")),
    UBCF_cor = list(name = "UBCF", param = list(method = "pearson")),
    SVD = list(name = "SVD", param = list(k = 50)),
    random = list(name = "RANDOM", param=NULL)
  )
  
  U_I_rm <- as(user_neighbors, "realRatingMatrix")
  U_I_Zsc <- normalize(U_I_rm, method = "Z-score")
  U_I_list <- getList(U_I_Zsc, decode = TRUE, ratings = TRUE)
  
  set.seed(421)
  rec_data <- evaluationScheme(U_I_rm, method = "cross-validation", k = 5, train = 0.8, given = -1, goodRating = 4)
  
 head(U_I_rm)
     
  
  
  rec_results <- evaluate(rec_data, algorithms,  "ratingMatrix")
  #
  plot(rec_results,annotate=TRUE, ylim = c(0,100))
  
  
  return(rec_results)
}


u_u_meta_Recommendation(user = "u10904", user_profiles, rating_data, cluster = TRUE)


getResults(rec_results)



