library(data.table)
library(xgboost)
library(readr)
library("Matrix");

source('./scripts/config.R')

# cat("\n...train....")
# X_train = fread('./data/X_train_words.csv',header=TRUE)
# id_train = X_train[,id]
# X_train[,id := NULL]

X_train = readMM('./data/X_train_words.RData')
X_train = as(X_train, "dgCMatrix")

y_train = fread('./data/y_train.csv')
y_train = y_train[,response]

# cat("\n...valid....")
# X_valid = fread('./data/X_valid_words.csv',header=TRUE)
# id_valid = X_valid[,id]
# X_valid[,id := NULL]

X_valid = readMM('./data/X_valid_words.RData')
X_valid = as(X_valid, "dgCMatrix")

y_valid = fread('./data/y_valid.csv')
y_valid = y_valid[,response]


#X_train[,year:=NULL]
#X_valid[,year:=NULL]



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

cat("\n\nTRAINING...")

# Train the model
cat("\nSetting the parameters for the model....")
param = list(
  eta = 0.1
  , gamma = 0
  , max_depth = 5
  , min_child_weight = 1
  , subsample = 0.7
  , colsample_bytree = 0.8
  , num_parallel_tree = 1
  ,objective = 'reg:linear'
  #, monotone_constraints = c(rep(0,ncol(struct_X_train)-1), rep(-1, ncol(m)))
)

#X_train[] <- lapply(X_train, as.numeric)
#X_valid[] <- lapply(X_valid, as.numeric)

cat("\nBuilding the data matrix for the xgboost model....")
data_train = xgb.DMatrix(X_train, label=y_train, missing = NA) # X_train # 
data_valid = xgb.DMatrix(X_valid, label=y_valid, missing = NA) # X_valid # 

cat("\nSetting the arguments for the model....")
args = list(
  param = param
  , verbose = 1
  , maximize=FALSE
  , nrounds = 100000
  , early_stopping_rounds = 200
  , print_every_n=20
  , data = data_train 
  , watchlist = list(valid = data_valid)
  , eval_metric = 'rmse'
)


start_time = proc.time()[['elapsed']]
cat('\n')

cat('Training the model...')
set.seed(3)
model = do.call('xgb.train',args)

end_time = proc.time()[['elapsed']]
train_time = end_time - start_time
cat(train_time,'s\n')

score = model$bestScore

cat('Saving the model...')
save(model,file='./models/model.rdata')
save(model,file=paste0('./models/model_',sub("\\.","_",score),".rdata"))



#imp = xgb.importance(col_headings,model=model)#,data=data_train,label=y_train)
#head(imp)

#imp[which(imp$Feature %like% 'txt_')][1:50]
