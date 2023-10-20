### Clustering user Profiles ###

library(mlr)
library(tidyverse)

user_profiles_meta_scaled <- user_profiles %>% dplyr::select(-user) %>% scale() %>% as.data.frame()


normalize <- function(x, na.rm = TRUE) {
  return((x- min(x)) /(max(x)-min(x)))
}
user_profiles_meta_scaled <- user_profiles %>% 
  dplyr::select(-user) %>% 
  dplyr::mutate(across(everything(), normalize)) %>%  # Scale all columns
  as.data.frame() 
  
cor_mat <- cor(user_profiles_meta_scaled)

robust_scaling <- function(x) {
  iqr_x <- IQR(x)
  median_x <- median(x)
  (x - median_x) / iqr_x
}
user_profiles_meta_scaled <- user_profiles %>%
  dplyr::select(-user) %>%  # Exclude the 'user' column
  dplyr::mutate(across(everything(), robust_scaling)) %>%  # Apply robust scaling to all columns
  as.data.frame()

user_profiles_meta_scaled <- user_profiles_meta_scaled%>%
  mutate(across(everything(), ~ ifelse(is.na(.), mean(., na.rm = TRUE), .)))

library(GGally)
library(parallel)
library(parallelMap)

meta_plot_reduced <- ggpairs(user_profiles_meta_scaled, upper = list(continuous = "density"), 
        lower = list(continuous = "points", size = 0.5),
        diag = list(continouos = "densityDiag"))+theme_bw()

ggsave(filename = "meta_plot.png", plot = meta_plot)
user_task <- makeClusterTask(data = user_profiles_meta_scaled)
kMeans <- makeLearner("cluster.kmeans", par.vals = list(iter.max = 300, nstart = 10))



kMeansParamSpace <- makeParamSet(makeDiscreteParam("centers", values = 3:10), 
                                 makeDiscreteParam("algorithm", values = c("Lloyd", "MacQueen")))
gridSearch <- makeTuneControlGrid()
kFold <- makeResampleDesc("CV", iters = 5)

library(clusterSim)


tunedK <- tuneParams(kMeans, task = user_task, resampling = kFold, par.set = kMeansParamSpace, control = gridSearch, measures = list(db, G1))
kMeansTuningData <- generateHyperParsEffectData(tunedK)
kMeansTuningData$data



kMeansTuningData <- generateHyperParsEffectData(tunedK)
kMeansTuningData$data

gatheredTuningData <- gather(kMeansTuningData$data, 
                             key = "Metric", 
                             value= "Value", 
                             c(-centers,-iteration,-algorithm))

ggplot(gatheredTuningData, aes(centers, Value, col = algorithm))+
  facet_wrap(~Metric, scales =  "free_y")+
  geom_line()+
  geom_point()+
  theme_bw()
tunedKMeans <- setHyperPars(kMeans, par.vals = tunedK$x)  
tunedKMeansModel <- train(tunedKMeans, user_task)
kMeansModelData <- getLearnerModel(tunedKMeansModel)

user_profiles_meta_scaled <- mutate(user_profiles_meta_scaled, KMCluster = as.factor(kMeansModelData$cluster))
user_profiles$KMCluster <- user_profiles_meta_scaled$KMCluster



clusters_with_outliers <- ggpairs(user_profiles_meta_scaled, 
        aes(col = KMCluster), 
        upper = list(continuous = "density"))+
  theme_bw()


ggsave("clusters_with_outliers.png", plot = clusters_with_outliers)





