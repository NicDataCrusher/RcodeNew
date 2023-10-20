#### Predictions with recommenderlab
#Modifications to your R code using recommenderlab:
  #Creating a RealRatingMatrix: You already have a function R_M that returns a realRatingMatrix object. This object can be directly used with recommenderlab.


real_rating_matrix <- makeU_I_rm(.data = reviews_filtered)
#Data Split for Evaluation: Split the data into training and test sets for model evaluation.


rec_data <- evaluationScheme(real_rating_matrix, method = "split", train = 0.8, given = -1)
#Training Recommender Models: Train various recommender models on the training set. You can train multiple models and compare their performance.


recommender_models <- Recommender(getData(rec_data, "train"), method = c("UBCF", "IBCF", "SVD"))
#Evaluating Models: Use the test set to evaluate the performance of your trained models.


rec_results <- evaluate(rec_data, method = c("UBCF", "IBCF", "SVD"), n = c(1, 5, 10))
#Top-N Recommendations: Once the model is trained, you can use it to make recommendations.


top_n_recommendations <- predict(recommender_models, getData(rec_data, "known"), n = 5)
#Integrating with Topic Modeling or Content Features: recommenderlab allows for the incorporation of content-based models, which would enable you to use the topics identified by your LDA model or the embeddings from Word2Vec as features.


content_based_model <- Recommender(real_rating_matrix, method = "CONTENT", parameter = list(normalize = "Z-score"))
#Hybrid Models: recommenderlab does not natively support hybrid models, but you can build your own by combining predictions from multiple models.
#This approach can be integrated seamlessly into your existing pipeline and should align well with your academic needs.

#Define a function for your algorithm: Create a function that takes a 
#realRatingMatrix object and other parameters as input, and returns a list 
#containing the model.

my_custom_algorithm <- function(real_rating_matrix, ...) {
  # your custom code here
  return(list(model = model, otherInfo = otherInfo))
}

#Register your method: Use the setMethod function to register your algorithm with recommenderlab.

setMethod("Recommender", signature(data = "realRatingMatrix", method = "my_custom_algorithm"), 
          function(data, method, parameter=NULL) {
            return(my_custom_algorithm(data, ...))
          }
)

#Predict method: Create a function that takes your model and new data, and returns a list of recommendations.

predict_my_custom_algorithm <- function(model, newdata, ...) {
  # custom prediction logic
  return(recommendation_list)
}

#Register your prediction method: Similar to how the method was registered, the predict function needs to be registered as well.
setMethod("predict", signature(object = "my_custom_algorithm", newdata = "realRatingMatrix"), 
          function(object, newdata, n=10, ...) {
            return(predict_my_custom_algorithm(object@model, newdata, n))
          }
)
#Once your custom method and prediction function are registered, you can use 
#recommenderlab's evaluate function to evaluate your custom method alongside 
#other built-in methods.

rec_results <- evaluate(rec_data, method = c("UBCF", "IBCF", "my_custom_algorithm"), n = c(1, 5, 10))
