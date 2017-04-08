source('./scripts/words.R')



preProcessNewDataPoint = function(data_to_predict){
  
  
####DATE
  data_to_predict[,Date:=last_publish_date]

  data_to_predict[,year:=as.integer(substring(Date,1,4))]
  data_to_predict[,month:=as.integer(substring(Date,6,7))]
data_to_predict[,day:=as.integer(substring(Date,9,10))]

data_to_predict[,Date:=as.Date(Date)]
data_to_predict[,weekday:=weekdays(Date)]
#data[,days_elapsed:=as.numeric(Date - as.Date('1995-01-01'))]
data_to_predict[,Date:=NULL]



#####POSTCODE
#data[, c("Postcode.1", "Postcode.2") := tstrsplit(Postcode, " ", fixed=TRUE)][]
data_to_predict[,Postcode.1:=outcode]

#data[, Postcode.2.1 := as.integer(substring(Postcode.2,1,1))]
#data[, Postcode.2.2 := substring(Postcode.2,2,3)]

data_to_predict[,Postcode.1.1:= sapply(regmatches(Postcode.1,gregexpr("\\D+",Postcode.1)),function(x) x[1])] #str_extract(Postcode.1, "[A-Z]+")]
data_to_predict[,Postcode.1.2:= sapply(regmatches(Postcode.1,gregexpr("\\d+\\D?",Postcode.1)),function(x) x[1])]

###### STREET

data_to_predict[,Street:=tolower(street_name)]
data_to_predict[,Street:=gsub('[[:punct:]]', '', Street) ]
for (i in 1:10){
  data_to_predict[,Street:=gsub('(london|middlesex|essex|croydon|surrey|isleworth|walthamstow|england|stratford|kent|harrow|wembley|enfield|e10|putney|bromley|wickham|en1|e6|ruislip|hornchurch|finchley)$', '', Street) ]
  data_to_predict[,Street:=gsub(' $', '', Street) ]
}

data_to_predict[,House_Number:= as.integer(sapply(regmatches(Street,gregexpr("\\d+\\s",Street)),function(x) x[1]))]
data_to_predict[is.na(House_Number),House_Number:=0]
data_to_predict[,Road_Type:= sapply(regmatches(Street,gregexpr("\\w+$",Street)),function(x) x[1])]

data_to_predict[,Commas:= sapply(regmatches(data_to_predict[,Street],gregexpr("\\,",data_to_predict[,Street])),function(x) length(x))]

data_to_predict[,Address_Length:= nchar(Street)]

print(data_to_predict)


################

new_description = data_to_predict[,description]

to_remove = c('Postcode.1', 'agent_name', 'agent_phone', 'description'
              , 'displayable_address', 'first_publish_date', 'last_publish_date', 'image_url'
              #, 'outcode'
              #, 'Street'
              , 'street_name')
data_to_predict[,(to_remove):=NULL]

to_remove = c('category','listing_status','price_change','year','Commas')
data_to_predict[,(to_remove):=NULL]

print(data_to_predict)

#############
# Convert categories variables to dummy one-hot

data_to_predict[,c(id_col):=NULL]
data_to_predict[,c(response_col):=NULL]

cat("\nConverting categorical variables to dummy one-hot encoded variables...")
feature.names <- names(data_to_predict)
char_feat = feature.names[which(sapply(data_to_predict,class) %in% c('character','logical'))]

#sapply(data_to_predict[,.SD,.SDcols=char_feat],function(x){length(unique(x))})


for (f in char_feat) {
  cat('\n',f)
  num_levels= length(unique(data_to_predict[,get(f)]))
  
  if (f %in% c('outcode','Road_Type','Street')){
    load(paste0('level_',f,'.rdata'))
    if (data_to_predict[,f,with=FALSE] %in% levels[,V1]){
      data_to_predict = merge(data_to_predict,levels,by.y='V1',by.x=f,sort=FALSE)  
      data_to_predict[,c(f):=NULL]
    }else{
      
      cat("can't find the value for ", f, " in the lookup table")
    }
  
  }else{
    col = data.table(f = data_to_predict[,as.factor(get(f))])
    names(col) = f
    load(paste0('dummy_',f,'.rdata'))
    data_out = data.table(predict(dummy, newdata = col))
    data_to_predict = cbind(data_to_predict,data_out)
    rm(col,dummy,data_out)
    gc()
    data_to_predict[,c(f):=NULL]
  }
  
}

print(data_to_predict)

##########

m = doWords(new_description)
print(Matrix(as.matrix(data_to_predict), sparse = TRUE))
print(m[nrow(m),,drop=FALSE])

out = cbind(Matrix(as.matrix(data_to_predict), sparse = TRUE), m[nrow(m),,drop=FALSE])
print(out)
return (out)
}
