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

col_headings = c(paste0('txt_',m@Dimnames$Terms))


tmp = cv.glmnet(X_train,y_train,nfolds=7)

model = glmnet(X_train, y_train, lambda = tmp$lambda.min)

pred <- predict(model, X_valid, s=tmp$lambda.min)

plot(pred,y_valid)

coefs = coef(model)
col_headings[order(coefs)][1:20]
