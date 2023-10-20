##### simple recommender ####


head(U_I_R_overall)
getRatingMatrix(U_I_R_overall)



U_I_R_overall_z <- normalize(U_I_R_overall)

r1 <- Recommender(getData(eval_scheme,"train"), method = "UBCF")


eval_scheme <- evaluationScheme(U_I_R_overall_z[1:1000], method = "cross", k= 5, train = 0.8, given = -1, goodRating = 4)
#generate Predictions!
preds <- predict(r1, getData(eval_scheme, "known"), type="ratings")
#get MEA etc as output
res <- calcPredictionAccuracy(preds, getData(eval_scheme, "unknown"))

#now take different algorithms as input
res_vgl <- evaluate(eval_scheme, algorithmns, type = "ratings")
plot(res_vgl, legend = "bottomright")


res_top <- evaluate(eval_scheme, algorithmns, type = "topNList",
   n=c(1, 3, 5, 10, 15, 20))

plot(res_top, annotate=TRUE, ylim = c(0,100))
plot(res_top, "prec/rec", annotate= TRUE, legend="topleft")


algorithmns <- list(
  UBCF_cos = list(name = "UBCF", param = list(method = "cosine")),
  UBCF_pears = list(name = "UBCF", param = list(method = "pearson")),
  random = list(name = "RANDOM", param=NULL)
  )
