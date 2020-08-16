
library(mosaic)
library(tidyverse)
library(ggplot2)
library(ggpubr)

#Problem 2 test code
abia_df = read.csv('ABIA.csv')

#Assign a season to each 3 month period.
abia_df$Season = ifelse(abia_df$Month %in% c(12,1,2),"Winter", #December, January, February are Winter.
                        ifelse(abia_df$Month %in% c(3,4,5),"Spring", #March,April, May are Spring
                               ifelse(abia_df$Month %in% c(6,7,8),"Summer", #June, July, August is summer
                                      "Fall"))) #September,October,November is Fall

summary(abia_df)

#Histogram test. Wait Histogram is not very good when comparing two variables.
ggplot(data=abia_df) + 
  geom_histogram(aes(x=Distance, stat(count)), binwidth=100) + 
  labs(title = 'Flight Distance Distribution', x= "Distance of flight (miles)", y = "Number of flights") + 
  theme_classic()

#Just use a scatterplot.
ggplot(data = abia_df) + 
  geom_point(mapping = aes(x = Distance, y = ActualElapsedTime, color = Season))  +
  facet_wrap(~ Season,nrow =2,ncol=2)
  #labs(,title = 'Scatterplot of average market rent vs rent sorted by green certifciation')

#Scatterplot for distance and actual elapsed time. 
ggplot(data = abia_df) + 
  geom_point(mapping = aes(x = Distance, y = ActualElapsedTime, color = UniqueCarrier))


################Distance and Season################
#Story here is to analyze how season affects the distance of a flight.
#Define season here: see the comments made when doing the season variable.
#First get the ditribution via density plot and analyze it.
#Then analyze bar plots of average and z-score distance.
#Define z-score.

#Density plot for distance.
ggplot(data = abia_df, aes(x=Distance)) + geom_density(aes(fill=factor(Season)),alpha = 1) +
  scale_color_manual(values =c('Winter' ='blue','Fall'='orange',"Summer"='Yellow','Spring'='Green')) +
  facet_wrap(~ Season,nrow =2,ncol=2) +
  labs(title="Density plot", 
       subtitle="Season vs Distance of flights",
       caption="Source: abia.csv",
       x="Distance (miles)",
       fill="Season")

#Bar plot of average distance+z score of distance

# Calculate average distance
abia_summ = abia_df %>%
  group_by(Season)  %>%  # group the data points by season
  summarize(Distance.mean = mean(Distance))  # calculate a mean for each Season

# reorder the x labels and create a variable to store the plot
avg = ggplot(abia_summ, aes(x=reorder(Season, Distance.mean), y=Distance.mean, fill = Season)) + 
  geom_bar(stat='identity') +
  labs(title="Bar Plot", 
       subtitle="Season vs Average Distance of flights",
       caption="Source: abia.csv",
       y="Average Distance (miles)",
       x = "Season",
       fill="Season")

# Create a plot for z-scores as well
# Use mutate function to change to add a z-score column
abia_summ = mutate(abia_summ, Distance.z = (Distance.mean - mean(Distance.mean))/sd(Distance.mean))

# now plot the newly defined variable
z_scores = ggplot(abia_summ, aes(x=reorder(Season, Distance.z), y=Distance.z, fill = Season)) + 
  geom_bar(stat='identity') +
  labs(title="Bar Plot", 
       subtitle="Season vs Distance of flights (z-score)",
       caption="Source: abia.csv",
       y="Distance (z-score)",
       x = "Season",
       fill="Season")


figure <- ggarrange(avg, z_scores, nrow = 2)

figure

########################Cancellation and Season#############################

canceled_flights = subset(abia_df, CancellationCode != '')

ggplot(data = canceled_flights, mapping = aes(x = as.factor(CancellationCode))) + 
  geom_bar(aes(fill=Season)) +
  facet_wrap(~ Season,nrow =2,ncol=2) +
  labs(title="Bar Plot", 
       subtitle="Cancellation reasons for each season",
       caption="Source: abia.csv",
       y="Count",
       x = "Season",
       fill="Season")



