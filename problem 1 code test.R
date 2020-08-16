#Raw script. Mainly just testing code and models.

green_df = read.csv('greenbuildings.csv')

head(green_df)


#Look at distribution of occupancy rate or leasing rate first.
#When using ggplot consider the facet wrap section to plot by class.
# Histogram to compare low lease rates
#Create labels for the green rating.
labels <- c("0" = "Standard Energy","1" = "Green Certified")
ggplot(data=green_df) + 
  geom_histogram(aes(x=leasing_rate, stat(count)), binwidth=10) + 
  facet_wrap(~ green_rating,labeller=labeller(green_rating = labels), nrow = 2) +
  labs(title = 'Distribution of low lease rates', x= "Occupancy Rate")


linear_model = lm(green_df2$green_rating~.,data = green_df2)
summary(linear_model)
#Use subset to get the guru's cleaned dataframe.
green_df2 <- subset(green_df, leasing_rate >= 10)

# adding a title
labels <- c("0" = "Standard Energy","1" = "Green Certified")
ggplot(data=green_df) + 
  geom_histogram(aes(x=Rent, stat(count)), binwidth=10) + 
  facet_wrap(~ green_rating,labeller=labeller(green_rating = labels), nrow = 2) +
  labs(title = 'Placeholder', x= "Rent")

#Box plot
ggplot(data=green_df2) + 
  geom_boxplot(mapping=aes(x=as.factor(green_rating), y=Rent)) +
  scale_x_discrete(labels = c('Standard Energy','Green Certified')) +
  labs(x='Building Status',title='Boxplot of Rent vs Building Status')
green_df2

#Box plot
ggplot(data=green_df2) + 
  geom_boxplot(mapping=aes(x=as.factor(green_rating), y=Electricity_Costs)) +
  scale_x_discrete(labels = c('Standard Energy','Green Certified')) +
  labs(x='Building Status',title='Boxplot of Rent vs Building Status') +
  coord_flip()



#correlation matrix
cor(green_df2)

#Let's test out plots with rent and these variables: cluster_rent, electricity_costs, total_dd_07, class_a.

#Scatterplot for rent and cluster rent. (cluster_rent)
labels <- c("0" = "Standard Energy","1" = "Green Certified")
ggplot(data = green_df2) + 
  geom_point(mapping = aes(x = Rent, y = cluster_rent),alpha=0.5) + 
  facet_wrap(~ green_rating,labeller=labeller(green_rating = labels), nrow = 2) +
  labs(y='Average rent in the local market',title = 'Scatterplot of average market rent vs rent sorted by green certifciation')

#Boxplot for rent and high class buildings (class_a)
ggplot(data = green_df2) + 
  geom_boxplot(mapping=aes(x=as.factor(class_a), y=Rent)) +
  scale_x_discrete(labels = c('Medium/Low Quality','High Quality')) + 
  facet_wrap(~ green_rating,labeller=labeller(green_rating = labels), nrow = 2) +
  labs(x='Highest Quality Buildings',y='Rent',title = 'Boxplot of Rent based on quality of the building and green certification') +
  coord_flip()

certifiedgreen_df = subset(green_df2, green_rating==1)
standard_df = subset(green_df2, green_rating==0)
dim(certifiedgreen_df)[1]
dim(standard_df)[1]




# summary(green_df$cluster_rent)
# summary(green_df$Rent)
# 
# # Another histogram for renovation
# ggplot(data=green_df) + 
#   geom_histogram(aes(x=renovated, stat(density)), binwidth=1) + facet_wrap(~ green_rating, nrow = 2)
# 
# #Histograms for class
# ggplot(data=green_df) + 
#   geom_histogram(aes(x=class_a, stat(count)), binwidth=1) + facet_wrap(~ green_rating, nrow = 2)
# 
# #Histograms for class
# ggplot(data=green_df) + 
#   geom_histogram(aes(x=class_b, stat(count)), binwidth=1) + facet_wrap(~ green_rating, nrow = 2)
