
#Problem 2 test code
abia_df = read.csv('ABIA.csv')
attach(abia_df)

head(abia_df)
dim(abia_df)

hist(Distance)
hist(ActualElapsedTime)

cor.test(Distance,ActualElapsedTime)
par(mfrow=c(3,2))
hist(ArrDelay)
hist(DepDelay)
hist(LateAircraftDelay)
hist(SecurityDelay)
hist(NASDelay)
hist(WeatherDelay)
hist(CarrierDelay)
cor.test(SecurityDelay,DepDelay)
cor.test(WeatherDelay,ArrDelay) #slightly higher corr
cor.test(WeatherDelay,DepDelay)
cor.test(ArrDelay,DepDelay)#significant delay correlation

cwd

ggplot(data = abia_df) +
  geom_point(mapping = aes(x = ArrDelay, y = DepDelay),alpha=0.5) 
  




#11:54
#next we want to analyze
#which delays is the most frequent
#which delays have the most effect on the elapsed air time






