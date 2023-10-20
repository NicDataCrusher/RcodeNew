

preparing_the_data <- function(beers, reviews, breweries){

beers_meta <<- beer_proc_meta(beers, breweries)
beer_docs<<- beers_proc_text(beers_meta)

reviews <- sample_frac(reviews, size = 0.01)

cut_reviews <- FUN_cut_reviews(reviews, beers_meta)
cut_reviews <<- cut_reviews %>% filter(!user == "uNA") 
reviews_meta <<- FUN_reviews_meta(cut_reviews)

rev_text <<- rev_text_data_processing(cut_reviews)
user_profiles <<- user_processing(reviews_meta, rating_data, rev_text)



}

summary(user_profiles)

user_profiles <- user_profiles %>% 
  filter(!nu.ratings < 20 & !mean_word_count< 5 )

U_I_R_overall <-  rating_data_processing(cut_reviews, "overall") 
  

  
  