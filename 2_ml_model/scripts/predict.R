

library(data.table)
library(xgboost)
library(readr)

source('./scripts/config.R')

cat("\n...train....")
X_test = fread('./data/X_valid.csv')
id_test = X_test[,id]
X_test[,id := NULL]

y_test = fread('./data/y_valid.csv')
y_test = y_test[,response]

load('./models/model.RData')

X_test[] <- lapply(X_test, as.numeric)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

cat("\n\nPREDICTING...")

# Predicting the test set
cat("\nPredicting the test set...")

data_test  = xgb.DMatrix(data.matrix(X_test), missing = NA)

preds = predict(model,data_test)

#preds = preds + temp[,adj]
#preds = exp(preds)-1

preds = data.table(id = id_test, response = preds)
setnames(preds,c(id_col,response_col))

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

cat("\n\nWRITING...")

# Writing the prediction to csv
cat("\nWriting the prediction to csv...")
write_csv(preds,path='./predictions/predictions.csv')


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

cat("\n\nFINISHED...")

plot(y_test,preds[,price],cex=0.2)

