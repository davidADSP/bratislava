
library(data.table)
library(readr)
library(caret)
library(stringr)
library(forecast)

source('./scripts/config.R')

data = fread('./data/pp-2017.csv',header=FALSE)


setnames(data, c('listing_id','price','date','outcode','type','age','duration','paon','saon','street','locality','town','district','county','ppd','status'))
data[,saon:=NULL]

data[,price:=as.numeric(price)]
data = data[price<1000000 & price>0 & county == 'GREATER LONDON']


#data[,(response_col):=log(get(response_col)+1)]

train_rows = which(!is.na(data[,get(response_col)]))



####DATE
data[,Date:=date]

data[,year:=as.integer(substring(Date,1,4))]
data[,month:=as.integer(substring(Date,6,7))]
data[,day:=as.integer(substring(Date,9,10))]

data[,Date:=as.Date(Date)]
data[,weekday:=weekdays(Date)]
#data[,days_elapsed:=as.numeric(Date - as.Date('1995-01-01'))]
data[,Date:=NULL]
data[,date:=NULL]

# 
# months= data[,.(adj=as.numeric(median(get(response_col)))),by = list(year,month)]
# 
# myts <- ts(months[,adj], start=c(1995, 1), end=c(2016, 4), frequency=12) 
# myts <- window(myts, start=c(1995, 1), end=c(2015, 12)) 
# fit <- auto.arima(myts)
# adjustments = c(as.vector(myts),forecast(fit, 4)$mean)
# months[,adj:=adjustments]
# data = merge(data,months,by=c('year','month'),sort=FALSE,all.x=TRUE)
# #data[,(response_col):=Price-adj]
# data[,adj:=NULL]


#####POSTCODE
#data[, c("Postcode.1", "Postcode.2") := tstrsplit(Postcode, " ", fixed=TRUE)][]
data[,Postcode.1:=outcode]

#data[, Postcode.2.1 := as.integer(substring(Postcode.2,1,1))]
#data[, Postcode.2.2 := substring(Postcode.2,2,3)]

data[,Postcode.1.1:= sapply(regmatches(Postcode.1,gregexpr("\\D+",Postcode.1)),function(x) x[1])] #str_extract(Postcode.1, "[A-Z]+")]
data[,Postcode.1.2:= sapply(regmatches(Postcode.1,gregexpr("\\d+\\D?",Postcode.1)),function(x) x[1])]

###### STREET

data[,Street:=street]


data[,paon:= as.integer(sapply(regmatches(paon,gregexpr("\\d+",paon)),function(x) x[1]))]
data[,Road_Type:= sapply(regmatches(Street,gregexpr("\\s\\w+$",Street)),function(x) x[1])]

data[,Commas:= sapply(regmatches(data[,Street],gregexpr("\\,",data[,Street])),function(x) length(x))]

data[,Address_Length:= nchar(Street)]


###############


id = data[,get(id_col)]
response = data[,get(response_col)]

write_csv(data,path='./data/data_enhanced.csv')

################


data[, c("Postcode.1"):=NULL]
data[, c("outcode"):=NULL]

data[,Street:=NULL]
data[,street:=NULL]

#############

to_remove = which(sapply(data, function(x){length(unique(x))})<=1)
data[,(to_remove):=NULL]

# Convert categories variables to dummy one-hot 


cat("\nConverting categorical variables to dummy one-hot encoded variables...")
feature.names <- names(data)
char_feat = feature.names[which(sapply(data,class) %in% c('character','logical'))]
char_feat = char_feat[-which(char_feat == id_col)]
sapply(data[,.SD,.SDcols=char_feat],function(x){length(unique(x))})




for (f in char_feat) {
  cat('\n',f)
  num_levels= length(unique(data[,get(f)]))
  
  
  if (num_levels>200){
    levels = data[,.N,by=f]#data.table(table(data[,get(f)]))
    levels[,rank:=rank(N,ties.method="random")]
    names(levels) = c('V1','N','rank')
    m <- t(sapply(levels[,rank],function(x){ as.integer(intToBits(x))}))
    cut = min(which(apply(m,2,sum)==0))
    m = m[,1:(cut-1)]
    colnames(m) = paste(f, 1:ncol(m),sep='_')
    levels = cbind(levels,m)
    levels[,N:=NULL]
    levels[,rank:=NULL]
    data = merge(data,levels,by.y='V1',by.x=f,sort=FALSE)  
    data[,c(f):=NULL]
    gc()
  }else{
    col = data.table(f = data[,as.factor(get(f))])
    names(col) = f
    dummy = dummyVars( ~ ., data = col)
    data_out = data.table(predict(dummy, newdata = col))
    data = cbind(data,data_out)
    rm(col,dummy,data_out)
    gc()
    data[,c(f):=NULL]
  }
  
}




data[,c(id_col):=NULL]
data[,c(response_col):=NULL]

##########


valid_size = 0.2
valid_rows =  sample(1:nrow(data), valid_size * nrow(data))  #which(data[,year]==2015)
train_rows = which(!(train_rows %in% valid_rows))



id_train = id[train_rows]
id_valid = id[valid_rows]


X_train = data.table(id = id_train, data[train_rows,])
X_valid = data.table(id = id_valid, data[valid_rows,])

y_train = data.table(id = id_train, response = response[train_rows])
y_valid = data.table(id = id_valid, response = response[valid_rows])

write_csv(X_train,path='data/X_train.csv')
write_csv(X_valid,path='data/X_valid.csv')

write_csv(y_train,path='data/y_train.csv')
write_csv(y_valid,path='data/y_valid.csv')

#write_csv(months,path='data/adjustments.csv')

