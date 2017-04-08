
library(data.table)
library(readr)
library(caret)
library(stringr)

source('./scripts/config.R')
source('./scripts/words.R')

data = fread('./data/data_04_08_2017.csv')

data = data[price<1000000]
data = data[price>0]

words_data = data[,.(id=listing_id, query = '', product_title='', product_description = description, median_relevance = price, relevance_variance = 0)]
write_csv(words_data,path='data/words_data.csv')





#data[,(response_col):=log(get(response_col)+1)]

train_rows = which(!is.na(data[,get(response_col)]))



####DATE
data[,Date:=last_publish_date]

data[,year:=as.integer(substring(Date,1,4))]
data[,month:=as.integer(substring(Date,6,7))]
data[,day:=as.integer(substring(Date,9,10))]

data[,Date:=as.Date(Date)]
data[,weekday:=weekdays(Date)]
#data[,days_elapsed:=as.numeric(Date - as.Date('1995-01-01'))]
data[,Date:=NULL]



#####POSTCODE
#data[, c("Postcode.1", "Postcode.2") := tstrsplit(Postcode, " ", fixed=TRUE)][]
data[,Postcode.1:=outcode]

#data[, Postcode.2.1 := as.integer(substring(Postcode.2,1,1))]
#data[, Postcode.2.2 := substring(Postcode.2,2,3)]

data[,Postcode.1.1:= sapply(regmatches(Postcode.1,gregexpr("\\D+",Postcode.1)),function(x) x[1])] #str_extract(Postcode.1, "[A-Z]+")]
data[,Postcode.1.2:= sapply(regmatches(Postcode.1,gregexpr("\\d+\\D?",Postcode.1)),function(x) x[1])]

###### STREET

data[,Street:=tolower(street_name)]
data[,Street:=gsub('[[:punct:]]', '', Street) ]
for (i in 1:10){
data[,Street:=gsub('(london|middlesex|essex|croydon|surrey|isleworth|walthamstow|england|stratford|kent|harrow|wembley|enfield|e10|putney|bromley|wickham|en1|e6|ruislip|hornchurch|finchley)$', '', Street) ]
data[,Street:=gsub(' $', '', Street) ]
}




data[,House_Number:= as.integer(sapply(regmatches(Street,gregexpr("\\d+\\s",Street)),function(x) x[1]))]
data[is.na(House_Number),House_Number:=0]
data[,Road_Type:= sapply(regmatches(Street,gregexpr("\\w+$",Street)),function(x) x[1])]

data[,Commas:= sapply(regmatches(data[,Street],gregexpr("\\,",data[,Street])),function(x) length(x))]

data[,Address_Length:= nchar(Street)]


###############


id = data[,get(id_col)]
response = data[,get(response_col)]

write_csv(data,path='./data/data_enhanced.csv')

################


to_remove = c('Postcode.1', 'agent_name', 'agent_phone', 'description'
              , 'displayable_address', 'first_publish_date', 'last_publish_date', 'image_url'
              #, 'outcode'
              #, 'Street'
              , 'street_name')
data[,(to_remove):=NULL]

to_remove = which(sapply(data, function(x){length(unique(x))})==1)
data[,(to_remove):=NULL]


#############
# Convert categories variables to dummy one-hot


data[,c(id_col):=NULL]
data[,c(response_col):=NULL]

cat("\nConverting categorical variables to dummy one-hot encoded variables...")
feature.names <- names(data)
char_feat = feature.names[which(sapply(data,class) %in% c('character','logical'))]

sapply(data[,.SD,.SDcols=char_feat],function(x){length(unique(x))})


for (f in char_feat) {
  cat('\n',f)
  num_levels= length(unique(data[,get(f)]))
  
  
  if (num_levels>200){
    levels = data[,.N,by=f]#data.table(table(data[,get(f)]))
    levels[,rank:=rank(-N,ties.method="random")]
    names(levels) = c('V1','N',f)
    
    
    # 
    # m <- t(sapply(levels[,rank],function(x){ as.integer(intToBits(x))}))
    # cut = min(which(apply(m,2,sum)==0))
    # m = m[,1:(cut-1)]
    # colnames(m) = paste(f, 1:ncol(m),sep='_')
    # levels = cbind(levels,m)
    # 
    # levels[,rank:=NULL]
    # 
    
    levels[,N:=NULL]
    save(levels, file=paste0('./level_',f,'.rdata'))
    
    data = merge(data,levels,by.y='V1',by.x=f,sort=FALSE)  
    data[,c(f):=NULL]
    gc()
  }else{
    col = data.table(f = data[,as.factor(get(f))])
    names(col) = f
    dummy = dummyVars( ~ ., data = col)
    data_out = data.table(predict(dummy, newdata = col))
    save(dummy, file=paste0('./dummy_',f,'.rdata'))
    data = cbind(data,data_out)
    rm(col,dummy,data_out)
    gc()
    data[,c(f):=NULL]
  }
  
}





##########


valid_size = 0.2
valid_rows =  sample(1:nrow(data), valid_size * nrow(data))  #which(data[,year]==2015)
train_rows = which(!(train_rows %in% valid_rows))



id_train = id[train_rows]
id_valid = id[valid_rows]


struct_X_train = data.table(id = id_train, data[train_rows,])
struct_X_valid = data.table(id = id_valid, data[valid_rows,])







y_train = data.table(id = id_train, response = response[train_rows])
y_valid = data.table(id = id_valid, response = response[valid_rows])




write_csv(struct_X_train,path='data/X_train.csv')
write_csv(struct_X_valid,path='data/X_valid.csv')

write_csv(y_train,path='data/y_train.csv')
write_csv(y_valid,path='data/y_valid.csv')

#write_csv(months,path='data/adjustments.csv')



m = doWords(NULL)


m_train = m[train_rows,]
m_valid = m[valid_rows,]



m_train = cbind(Matrix(as.matrix(struct_X_train)[,2:ncol(struct_X_train)], sparse = TRUE), m_train)
m_valid = cbind(Matrix(as.matrix(struct_X_valid)[,2:ncol(struct_X_train)], sparse = TRUE), m_valid)

#m_train =Matrix(as.matrix(struct_X_train)[,2:ncol(struct_X_train)], sparse = TRUE)
#m_valid = Matrix(as.matrix(struct_X_valid)[,2:ncol(struct_X_train)], sparse = TRUE)


writeMM(m_train, file = './data/X_train_words.RData')
writeMM(m_valid, file = './data/X_valid_words.RData')


