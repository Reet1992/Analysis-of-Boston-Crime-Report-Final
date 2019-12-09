set.seed(1)
require(xgboost)
require(dplyr)
require(tidyr)


boston_dat <- read.csv('./DataSet/Boston_Crime_Data/Boston_Crime_Data.csv')


bdat <- boston_dat[sample(1:nrow(boston_dat), size = 50000), ]
#colnames(bdat)[189:204]

bdat = bdat[which(bdat$Lat != -1),]
drops = c('INCIDENT_NUMBER','UCR_PART','OFFENSE_CODE','OFFENSE_DESCRIPTION','Location')
# ^ Remove features that either are a represenation of the criterion (e.g., Offense Code Group), or are copies of other features (e.g., Location).

bdat = bdat[!(names(bdat) %in% drops)]

preds = cbind.data.frame(bdat)
target = bdat$OFFENSE_CODE_GROUP

target = as.integer(target == 'Larceny')

target = target[which(!is.na(preds[,6]))]
preds = preds %>%
  filter(!is.na(preds[,6]))

bad_rows = list()
for(i in 1:ncol(preds))
{
  if(dim(table(is.na(preds[,i]))) > 1)
  {
    preds[,i] <- preds %>%
      select(colnames(preds)[i])
    bad_rows[[i]] = which(is.na(preds[,i]))
    
  }
}

bad_rows = unlist(bad_rows)

preds = preds[-c(bad_rows),]
target = target[-c(bad_rows)]


preds = preds[,-c(which(colnames(preds) %in% c('OFFENSE_CODE_GROUP', 'Larceny', 'Larceny_Fraction', 'OCCURRED_ON_DATE')))]


preds_cats = preds[,c(unlist(lapply(preds, is.factor)))]

preds = preds[,!c(unlist(lapply(preds, is.factor)))]


#preds = preds[,which(colnames(preds) != 'OCCURRED_ON_DATE')]



preds_1hot = mltools::one_hot(as.data.table(preds_cats), sparsifyNAs = T, dropCols = T, dropUnusedLevels = T)


cat_numeric <- cbind.data.frame(preds, preds_1hot)
pred_matrix <- data.matrix(cat_numeric)


########### Model Construction

DMat <- xgb.DMatrix(data = pred_matrix, label= target)



numberOfTrainingSamples <- round(nrow(DMat) * .7)


train_data <- xgboost::slice(DMat, idxset = 1:numberOfTrainingSamples)
train_labels <- xgboost::getinfo(train_data, 'label')



test_index <- which(!(1:nrow(DMat) %in% c(1:numberOfTrainingSamples)))
test_data <- xgboost::slice(DMat, idxset = test_index)
test_labels <- train_labels <- xgboost::getinfo(object = test_data, 'label')

dtrain = train_data
dtest = test_data


model_tuned <- xgboost(data = dtrain, 
                       max.depth = 2, 
                       eta = .01, 
                       nrounds = 100, 
                       early_stopping_rounds = 3, 
                       gamma = .8,   
                       objective = 'binary:logistic',
                       booster= "gbtree",
                       verbose = 0,
                       colsample_bytree = .6,
                       min_child_weight = 1, 
                       subsample = 1
)


pred <- predict(model_tuned, dtest)

err <- mean(as.numeric(pred > 0.5) != test_labels)



model_dump <- xgb.dump(model_tuned,with_stats = T)


featurez <- dimnames(pred_matrix[,-1])[[2]]




importance_matrix <- xgb.importance(feature_names = featurez, model = model_tuned)


xgb.ggplot.importance(importance_matrix, n_clusters = c(4)) +
  theme(legend.title = element_blank(), legend.position = 'none') 

