#Feature Selection, Classification, Regression
library(party)
library(xgboost)
library(mlr)
#first we create a smaller Test set, to save computing Power


#Creating a Classification Task for the Variable "overall".
#We need to keep in mind, that we need to create a unique profile for each user. So the algorithms require to learn from individual Profiles 
# We could overcome this by modelling clusters and use similar users als trainings datata 
beer_meta.task <- makeClassifTask("classif.logreg", tester[,c(10,16,22)], target = "labels")
#First we create basic learners
beer.rf = makeLearner("classif.randomForest", predict.type = "prob", fix.factors.prediction = TRUE)
beer.lr = makeLearner("classif.logreg", predict.type = "prob", fix.factors.prediction = TRUE)

holdout <- makeResampleDesc("Holdout")
r <- resample(beer.lr, beer_meta.task, resampling =holdout)

levels(tester$country)
hist(tester$country)

# Train the learner
mod.lr = train(beer.lr, beer_meta.task, subset = train.set)
mod.lr

# Feature selection in inner resampling loop
inner = makeResampleDesc("CV", iters = 3)
lrn = makeFeatSelWrapper(beer.lr,
                         resampling = inner,
                         control = makeFeatSelControlSequential(method = "sfs"), show.info = FALSE)

# Outer resampling loop we use the Method " Feature Selection Forward#!!!!! QUELLE
outer = makeResampleDesc("Subsample", iters = 2)
r = resample(
  learner = lrn, task = beer_meta.task, resampling = outer, extract = getFeatSelResult,
  show.info = FALSE)

r$extract
