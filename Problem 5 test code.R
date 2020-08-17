#Load in neccessary libraries
library(tm) 
library(tidyverse)
library(slam)
library(proxy)
library(stringr)

#Reminder to set relevant wd.
#> setwd("C:/Users/mattl/Desktop/Predictive Models/Group project/Predictive-Modeling-Exercises-mattl/Text analysis folder")


#################################Get the matrices###############################

#Modified code from tm_examples
#Making the training set.

## tm has many "reader" functions.  Each one has
## arguments elem, language, id
## (see ?readPlain, ?readPDF, ?readXML, etc)
## This wraps another function around readPlain to read
## plain text documents in English.
# I've stored this function as a Github "gist" at:
# https://gist.github.com/jgscott/28d9d1287a0c3c1477e2113f6758d5ff
readerPlain = function(fname){
  readPlain(elem=list(content=readLines(fname)), 
            id=fname, language='en') }

#I assume the syntax for reading this is kind of like
#* signifies look at all string.
#then the * txt reads in every text file.
file_list = Sys.glob('data/ReutersC50/C50train/*/*.txt')
#File length should be 50*50
50*50
length(file_list)
#That does indeed match. so I assume I did this modification correctly.
#Now let's try to apply the example code to the rest of the files.
author = lapply(file_list, readerPlain)

# Clean up the file names section from tm_examples.
mynames = file_list %>%
  { strsplit(., '/', fixed=TRUE) } %>%
  { lapply(., tail, n=2) } %>%
  { lapply(., paste0, collapse = '') } %>%
  unlist

#Clean up file names section. But remove the numbers+newsML.txt to get author name.
mynames2 = file_list %>%
  { strsplit(., '/', fixed=TRUE) } %>%
  { lapply(., tail, n=2) } %>%
  { lapply(., paste0, collapse = '') } %>%
  str_remove(., "[0-9]+[n][e][w][s][M][L][.][t][x][t]") %>%
  unlist

#Create two lists to put into a dataframe.
names_list = list(mynames)
names_list2 = list(mynames2)

#create a dataframe to reference for classification later
author_train = do.call(rbind, Map(data.frame, Text_File=names_list, Author=names_list2))

#Put column in index
#rownames(author_train) <- author_train$Text_File

#Remove the Text_File column
#author_train$Text_File <- NULL

# Rename the articles
#mynames - looks like it worked.
names(author) = mynames

## once you have documents in a vector, you 
## create a text mining 'corpus' with: 
documents_raw = Corpus(VectorSource(author))

## Some pre-processing/tokenization steps.
## tm_map just maps some function to every document in the corpus
my_documents = documents_raw %>%
  tm_map(content_transformer(tolower))  %>%             # make everything lowercase
  tm_map(content_transformer(removeNumbers)) %>%        # remove numbers
  tm_map(content_transformer(removePunctuation)) %>%    # remove punctuation
  tm_map(content_transformer(stripWhitespace))          # remove excess white-space


# Decided to just remove the "basic English" stop words
my_documents = tm_map(my_documents, content_transformer(removeWords), stopwords("en"))


## create a doc-term-matrix from the corpus
#I expect to see 2500 documents.
DTM_author_train = DocumentTermMatrix(my_documents)
DTM_author_train # some basic summary statistics
#Did get 2500 documents so that's a good sign that the code worked.


#Decide to remove the noise of terms
#Cut down the term count
#Remove terms that have count 0 in >93% of the documents.
DTM_author_train = removeSparseTerms(DTM_author_train, 0.99)
DTM_author_train # now ~ 3393 terms (versus ~32570 before)
#Lost 4% sparsity from 99% not bad.

# construct TF IDF weights -- might be useful if we wanted to use these
# as features in a predictive model
tfidf_author_train = weightTfIdf(DTM_author_train)

################################Create test data##############################
#Modified code from tm_examples
#Making the test set.

## tm has many "reader" functions.  Each one has
## arguments elem, language, id
## (see ?readPlain, ?readPDF, ?readXML, etc)
## This wraps another function around readPlain to read
## plain text documents in English.
# I've stored this function as a Github "gist" at:
# https://gist.github.com/jgscott/28d9d1287a0c3c1477e2113f6758d5ff
readerPlain = function(fname){
  readPlain(elem=list(content=readLines(fname)), 
            id=fname, language='en') }

#I assume the syntax for reading this is kind of like
#* signifies look at all string.
#then the * txt reads in every text file.
test_list = Sys.glob('data/ReutersC50/C50test/*/*.txt')

#That does indeed match. so I assume I did this modification correctly.
#Now let's try to apply the example code to the rest of the files.
author_test = lapply(test_list, readerPlain)

# Clean up the file names section from tm_examples.
mynames_t = test_list %>%
  { strsplit(., '/', fixed=TRUE) } %>%
  { lapply(., tail, n=2) } %>%
  { lapply(., paste0, collapse = '') } %>%
  unlist

#Clean up file names section. But remove the numbers+newsML.txt to get author name.
mynames_t2 = test_list %>%
  { strsplit(., '/', fixed=TRUE) } %>%
  { lapply(., tail, n=2) } %>%
  { lapply(., paste0, collapse = '') } %>%
  str_remove(., "[0-9]+[n][e][w][s][M][L][.][t][x][t]") %>%
  unlist

#Create two lists to put into a dataframe.
names_listt = list(mynames_t)
names_listt2 = list(mynames_t2)

#create a dataframe to reference for classification later
author_test_df = do.call(rbind, Map(data.frame, Text_File=names_listt, Author=names_listt2))

#Put column in index
#rownames(author_test) <- author_test$Text_File
#Remove the Text_File column
#author_test$Text_File <- NULL

# Rename the articles
#mynames - looks like it worked.
names(author_test) = mynames_t

## once you have documents in a vector, you 
## create a text mining 'corpus' with: 
documents_raw2 = Corpus(VectorSource(author_test))

## Some pre-processing/tokenization steps.
## tm_map just maps some function to every document in the corpus
my_documents2 = documents_raw2 %>%
  tm_map(content_transformer(tolower))  %>%             # make everything lowercase
  tm_map(content_transformer(removeNumbers)) %>%        # remove numbers
  tm_map(content_transformer(removePunctuation)) %>%    # remove punctuation
  tm_map(content_transformer(stripWhitespace))          # remove excess white-space


# Decided to just remove the "basic English" stop words
my_documents2 = tm_map(my_documents2, content_transformer(removeWords), stopwords("en"))


## create a doc-term-matrix from the corpus
#I expect to see 2500 documents.
DTM_author_test = DocumentTermMatrix(my_documents2)
DTM_author_test # some basic summary statistics
#Did get 2500 documents so that's a good sign that the code worked.


#Decide to remove the noise of terms over here as well
#Cut down the term count
#Remove terms that have count 0 in >99% of the documents.
DTM_author_test = removeSparseTerms(DTM_author_test, 0.99)
DTM_author_test # now ~ 3448 terms (versus ~33373 before)
#Lost 4% sparsity from 99% not bad.
#As noted in the assignment, there are most likely terms here that do not appear in the other document matrix.
#Accept the performance hit due to time contraints.

# construct TF IDF weights -- might be useful if we wanted to use these
# as features in a predictive model
tfidf_author_test = weightTfIdf(DTM_author_test)

####
# Fixing some train/test split issues.
####

#Problem that certain terms do not appear in the other.
#method to fix is to try and match the columns that do happen in both.

#Read in the tf-idf matrix
X_train = as.matrix(tfidf_author_train)

#Get rid of any columns with 0 values.
scrub_train = which(colSums(X_train) == 0)
X_train = X_train[,-scrub_train]

#Do same scrubbing for test set.
X_test = as.matrix(tfidf_author_test)
scrub_test = which(colSums(X_test)==0)
X_test = X_test[,-scrub_test]

#Let's try and now only condsider the columns that are in both.
train_cols = colnames(X_train)
test_cols = colnames(X_test)

match = intersect(train_cols,test_cols)
X_train = X_train[,match]
X_test = X_test[,match]


###############################PCA breakdown#####################################
# Now PCA on the cleaned x_train
#Need to do PCA here because there are way too many columns.

#Do the first 50 principal components.
pca_author = prcomp(X_train, scale=TRUE, rank=50)

#Look at the pca.
summary(pca_author)
#In total all 50 explain about 15 percent or so of the variation.
#That's not the greatest but that makes sense considering there are a lot of different documents.
#Still it seems from the example in class this is more than enough variance.

# Look at the loadings to determine what the top PCAs are talking about.

#First PCA seems to weight negative on Chinese articles/news related to China. 
#Positive for more financial news.
#So finance vs chinese news.
pca_author$rotation[order(abs(pca_author$rotation[,1]),decreasing=TRUE),1][1:25]

#Second PCA seems to focus an automobile working news.
pca_author$rotation[order(abs(pca_author$rotation[,2]),decreasing=TRUE),2][1:25]

#This one is negative. Seems to give negative ratings towards more economic news.
pca_author$rotation[order(abs(pca_author$rotation[,3]),decreasing=TRUE),2][1:25]

#Again negative. Seems to weight against protests.
pca_author$rotation[order(abs(pca_author$rotation[,4]),decreasing=TRUE),2][1:25]

#Again negative. Seems to weight against software and legislation.
pca_author$rotation[order(abs(pca_author$rotation[,5]),decreasing=TRUE),2][1:25]

#Again negative. Seems to weight against Hong Kong and minerals.
pca_author$rotation[order(abs(pca_author$rotation[,6]),decreasing=TRUE),2][1:25]

#Again negative. Seems to weight against technology and international news.
pca_author$rotation[order(abs(pca_author$rotation[,7]),decreasing=TRUE),2][1:25]

#Again negative. Seems to weight against international news.
pca_author$rotation[order(abs(pca_author$rotation[,8]),decreasing=TRUE),2][1:25]

#predict test based on the pca.


############################Model Time#########################################

#########################Logistic did not work #################################
# # Construct the feature matrix and response vector.
# # We'll take as candidate variables the leading PCs.
# # Here TFIDF + PCA + truncating the lower-order (noisier) PCs
# # is our "feature engineering" pipeline.
# 
# X1 = pca_author$x[,1:2]
# y = {author_data$Author}
# 
# # Lasso cross validation
# out1 = cv.glmnet(X1, y, family='multinomial', type.measure="class")
# 
# # Choose lambda to minimize CV error
# plot(out1$lambda, out1$cvm, log='X')
# lambda_hat = out1$lambda.min
# 
# # refit to the full data set with the "optimal" lambda
# glm1 = glmnet(X1, y, family='multinomial', lambda = lambda_hat)
# 
# # The fit
# glm1$beta
# plot(glm1$beta)
# 
# # degrees of freedom and cross-validated misclassification rate
# glm1$df
# min(out1$cvm)  

#####################Logistic = failure. Let's try out tree.
library(randomForest)

#Create a train dataframe with the PCAs and author column.
train_df = as.data.frame(cbind(pca_author$x,Author=author_train$Author))

#Create a test dataframe. Using all the TF-IDF plus author.
test_df = as.data.frame(cbind(X_test,Author=author_test_df$Author))


rf_author = randomForest(as.factor(train_df$Author)~., 
                       data=train_df, #Use train-value data
                       mtry=5, #Use 5 predictors
                       importance =TRUE)

rf_pred = predict(rf_author, data = test_df)

rf_table = as.data.frame(table(rf_pred,test_df$Author))

library('caret')

rf_confusion_matrix = confusionMatrix(table(rf_pred,test_df$Author))
rf_confusion_matrix$overall
#about 74% accuracy. Not bad at all.

####
# Naive Bayes Classifier since logistic doesn't work.
####

library(e1071)
#Create train and test dataframes for the naive bayes model.

#Same dataframes as RF.
#Create a train dataframe with the PCAs and author column.
train_df = as.data.frame(cbind(pca_author$x,Author=author_train$Author))

#Create a test dataframe. Using all the TF-IDF plus author.
test_df = as.data.frame(cbind(X_test,Author=author_test_df$Author))


NB = naiveBayes(as.factor(train_df$Author)~.,data=train_df)
NB_pred = predict(NB, as.factor(test_df$Author))

#Wait it's all AoronPressman.
#Pretty sure that's not how it's supposed to go.
#Well there was an attempt.
NB_table = as.data.frame(table(NB_pred,as.factor(author_test$Author)))

mean(NB_pred == test_df$Author)


# ####################################KNN model##################################
# library(kknn)
# 
# #Similar to RF except now the pcas for the test set must be inferred.
# #It's a prediction within a prediction so I don't expect this model to go that well.
# X_test1 = predict(pca_author,newdata=X_test)
# 
# #Create a train dataframe with the PCAs and author column.
# train_df = as.data.frame(cbind(pca_author$x,Author=author_train$Author))
# 
# #Create a test dataframe. Using all the TF-IDF plus author.
# test_df = as.data.frame(cbind(X_test1,Author=author_test_df$Author))
# 
# 
# 
# knn <- kknn(as.factor(train_df$Author)~.,train = train_df, test = test_df, k=4)
# 
# #This one also doesn't work. lol. I guess RF is our best and only model.

