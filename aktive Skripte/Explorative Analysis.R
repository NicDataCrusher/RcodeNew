#Prescriptive analysis


load("~/Niclas Kammler/Thesis/Data/Step1.RData")
summary(beers)
summary(reviews)
summary(breweries)
head(beers)
head(reviews)

Visualisation <- function(){
u_r_count <-  reviews %>% group_by(username) %>% summarise(count = n())
u_r_count_plot <- ggplot(u_r_count, aes(count)) +
  geom_histogram(binwidth = 10, alpha = 0.7) +
  ggtitle("Number of Ratings per User") +
  xlab("Number of Ratings") +
  ylab("Frequency")+
  theme_bw()

ggsave(filename = "u_r_count.png", plot = u_r_count_plot)



r_word_count <-  reviews %>%
  mutate(word_count = str_count(text, "\\S+")) 

r_word_count_plot <- ggplot(r_word_count, aes(word_count, color = overall)) +
  geom_histogram(binwidth = 10, alpha = 0.7) +
  ggtitle("Number of Words per Rating") +
  xlab("Number of Words") +
  ylab("Frequency")+
  theme_bw()

ggsave(filename = "r_word_count_plot.png", plot = r_word_count_plot)


# Number of ratings per beer
beer_rating_count <- reviews %>% group_by(beer_id) %>% summarise(count = n())
i_r_count <- ggplot(beer_rating_count, aes(x = count)) +
  geom_histogram(binwidth = , alpha = 0.7) +
  ggtitle("Number of Ratings per Beer") +
  xlab("Number of Ratings") +
  ylab("Frequency")+
  theme_bw()

ggsave(filename = "i_r_count.png", plot = i_r_count)

# Distribution of ratings
overall_distr <- ggplot(reviews, aes(x = overall)) +
  geom_histogram(binwidth = 0.5,  alpha = 0.7) +
  ggtitle("Distribution of Ratings") +
  xlab("Rating") +
  ylab("Frequency")+
  theme_bw()
ggsave(filename = "distr_overall.png", plot = overall_distr)


beer_styles_plot <- ggplot(beers, aes(style, fill = factor(style))) + 
  geom_bar()+
  labs(x = "", y = "Count", title = "Count of beer Styles" )+
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5, size = 4))+
  theme(legend.position = "bottom", legend.key.size = unit(0.2, "cm"), legend.text = element_text(size = 4))+
  guides(fill = guide_legend(title = "Styles", label.position = "right", ncol = 7))+
  theme_bw()

ggsave(filename = "distr_styles.png", plot = beer_styles_plot)


usage_of_words <- ggplot(user_profiles, aes(mean_word_count)) +
  geom_histogram( ) +
  ggtitle("Distribution of Average Amount of Words per User") +
  xlab("Mean Word Count") +
  ylab("Frequency")+
  theme_bw()

ggsave(filename = "usage_of_words.png", plot = usage_of_words)

variety_seeking <-  ggplot(user_profiles, aes(VarSeekStyle)) +
  geom_density( ) +
  ggtitle("Distribution of VarietySeeking Behaviour per User") +
  xlab("VarSeek*") +
  ylab("Frequency")+
  theme_bw()
ggsave(filename = "variety_seeking.png", plot = variety_seeking)


IPT_mean_dist <-  ggplot(user_profiles, aes(IPT_mean)) +
  geom_histogram(binwidth = 10 ) +
  ggtitle("Distribution of mean IPT per User") +
  xlab("IPT_mean*") +
  ylab("Frequency")+
  theme_bw()
ggsave(filename = "IPT_mean_dist.png", plot = IPT_mean_dist)

aff.abv_dist <-  ggplot(user_profiles, aes(aff.abv)) +
  geom_histogram( ) +
  ggtitle("Distribution of ABV Affinity per User") +
  xlab("aff.abv*") +
  ylab("Frequency")+
  theme_bw()
ggsave(filename = "aff.abv_dist.png", plot = aff.abv_dist)

n.w_v_n.r <- ggplot(user_profiles, aes(x = nu.ratings, y= mean_word_count))+
  geom_point( )+
  ggtitle("Mean Nr. of Words vs. Nr. of Ratings per User") +
  xlab("Nr. Ratings per User") +
  ylab("Mean Word Count per User")+
  theme_bw()
ggsave(filename = "Mean Nr. of Words vs. Nr. of Ratings per User.png", plot = n.w_v_n.r)

IPT_v_n.w <- ggplot(user_profiles, aes(x = IPT_mean, y= mean_word_count))+
  geom_point( )+
  ggtitle("Mean Nr. of Words vs. Mean IPT per User") +
  xlab("Mean IPT per User") +
  ylab("Mean Nr. of Words per User")+
  theme_bw()
ggsave(filename = "Mean Nr. of Words vs. Mean IPT per User.png", plot = IPT_v_n.w)

IPT_v_aff.abv <- ggplot(user_profiles, aes(x = aff.abv, y= IPT_mean))+
  geom_point( )+
  ggtitle("Alkohohol Affinity vs. Mean IPT per User") +
  xlab("Alkohol Affinity") +
  ylab("Mean IPT per User")+
  theme_bw()
ggsave(filename = "Alkohol Affinity vs. Mean IPT per User.png", plot = IPT_v_aff.abv)

VarSeek_v_AffAbv <- ggplot(user_profiles, aes(x = aff.abv, y= VarSeekStyle))+
  geom_point( )+
  ggtitle("Alkohohol Affinity vs. VarSeek*") +
  xlab("Alkohol Affinity") +
  ylab("VarSeek")+
  theme_bw()
ggsave(filename = "Alkohol Affinity vs. VarSeek.png", plot = VarSeek_v_AffAbv)

VarSeek_v_IPT <- ggplot(user_profiles, aes(x = VarSeekStyle, y= IPT_mean))+
  geom_point( )+
  ggtitle("Alkohohol Affinity vs. IPT_mean*") +
  xlab("IPT_mean") +
  ylab("VarSeek")+
  theme_bw()
ggsave(filename = "IPT_mean vs. VarSeek.png", plot = VarSeek_v_AffAbv)


plots <-return(aff.abv_dist, IPT_mean_dist, variety_seeking, usage_of_words, overall_distr, u_r_count, i_r_count) 
}
Visualisation()

WordCount_v_rating <- ggplot(r_word_count, aes(x = word_count, y = overall))+
  geom_point()+
  ggtitle("Relationship of Rating and Word Count") +
  xlab("word_count") +
  ylab("overall")+
  theme_bw()
ggsave(filename = "WordCount_v_rating.png", plot = WordCount_v_rating)

IPT_std_distr <- ggplot(user_profiles, aes(x = IPT_std)) +
  geom_histogram( ) 
