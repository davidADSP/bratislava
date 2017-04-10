# install.packages(c("data.table"))
# install.packages("jsonlite")
# install.packages("svSocket")

library("xgboost");
library("data.table");
library("jsonlite");
library(data.table)
library(readr)
library(caret)
library(stringr)
library("Matrix");

source('./scripts/config.R')
source('./scripts/preprocess_newdata_new.R')
#library("svSocket");

dx = fread("data/data_04_08_2017.csv");
load('./models/model.RData')


#DAVID here we plug your models
getForecastedPrices = function(data_to_predict){
  #print(1)
  processed_data_to_predict = preProcessNewDataPoint(data_to_predict)
  #print(2)
  dummy_test  = xgb.DMatrix(processed_data_to_predict, missing = NA)
  #print(3)
  pred = predict(model,dummy_test)
  #print(4)
  print(pred);
  return (pred)
}

getUniqueCategories = function(){
  categories = unique(dx$category);
}

getUniqueBathrooms = function(){
  unq = unique(dx$num_bathrooms);
  unq = unq[order(unq)];
  ret_dx = data.table("name"=unq, "value"=unq);
  return(toJSON(ret_dx));
}


getUniqueBedrooms = function(){
  unq = unique(dx$num_beedrooms);
  unq = unq[order(unq)];
  ret_dx = data.table("name"=unq, "value"=unq);
  return(toJSON(ret_dx));
}


getUniqueNumOfFloors = function(){
  unq = unique(dx$num_floors);
  unq = unq[order(unq)];
  ret_dx = data.table("name"=unq, "value"=unq);
  return(toJSON(ret_dx));
}

getUniqueNumOfRecepts = function(){
  unq = unique(dx$num_recepts);
  unq = unq[order(unq)];
  ret_dx = data.table("name"=unq, "value"=unq);
  return(toJSON(ret_dx));
}


getUniquePropertyTypes = function(){
  unq = unique(dx$property_type);
  unq = unq[order(unq)];
  ret_dx = data.table("name"=unq, "value"=unq);
  return(toJSON(ret_dx));
}


getUniqueStreets = function(data){
  data = gsub("getUniqueStreets;","",data);
  unq = unique(dx$street_name);
  unq = unq[grep(data,unq,ignore.case=TRUE)];
  unq = unq[order(unq)];
  unq = unq[unq!=""];
  ret_dx = data.table("name"=unq, "value"=unq);
  return(toJSON(ret_dx));
}


getpreds = function(data){
  data = gsub("getpreds;","",data);
  obj =  fromJSON(data);
  #get outcode
  street = obj[2,2];
  #will just get at random stuff related to street
  vx = dx[dx$street_name == street];
  #print(street)
  vx = vx[1,];
  data_to_predict = data.table(
    "listing_id" = 0,
    "agent_name" = "David Conway & Co Ltd",
    "agent_phone" = "020 3478 3581",
    "category" = "Residential",
    "description" = obj[7,2],
    "displayable_address" = obj[2,2],
    "first_publish_date" = "2017-04-08",
    "image_url" = "http://image_shack.com",
    "last_publish_date" = "2017-04-08",
    "latitude" = vx$latitude,
    "listing_status"="sale",
    "longitude" = vx$longitude,
    "new_home" = "true",
    "num_bathrooms" = as.integer(obj[4,2]),
    "num_beedrooms" = as.integer(obj[3,2]),
    "num_floors" = as.integer(obj[6,2]),
    "num_recepts" = as.integer(obj[5,2]),
    "outcode" = vx$outcode,
    "post_town" = vx$post_town,
    "price" = 300000, #0,
    "price_change" = "",
    "property_type" = obj[1,2],
    "status" = "for_sale",
    "street_name" = obj[2,2]
  );
  forecast_value = getForecastedPrices(data_to_predict);
  ret_dx = data.table("name"=1, "value"=forecast_value);
  return(toJSON(ret_dx));
}



#get socket server here
server = function(){
  while(TRUE){
    writeLines("Listening...")
    con <- socketConnection(host="localhost", port = 8089, blocking=TRUE,
                            server=TRUE, open="r+")
    data <- readLines(con, 1);
    print(data);
    response = "";
    process = FALSE;
    if(length(grep("getUniqueBathrooms",data))>0){ response = getUniqueBathrooms();process=TRUE;}
    if(length(grep("getUniqueBedrooms",data))>0){ response = getUniqueBedrooms();process=TRUE;}
    if(length(grep("getUniqueNumOfFloors",data))>0){ response = getUniqueNumOfFloors();process=TRUE;}
    if(length(grep("getUniqueNumOfRecepts",data))>0){ response = getUniqueNumOfRecepts();process=TRUE;}
    if(length(grep("getUniquePropertyTypes",data))>0){ response = getUniquePropertyTypes();process=TRUE;} 
    if(length(grep("getUniqueStreets",data))>0){ response = getUniqueStreets(data);process=TRUE;} 
    if(length(grep("getpreds",data))>0){ response = getpreds(data);process=TRUE;}
    if(process){ 
      writeLines(response, con);
    }
    else {
      writeLines('[{name="no data", value="no data"}]', con);
    }
    close(con)
  }
}
for(i in 1:100){
  tryCatch({
    server()
  }, error = function(e) {
    print(e);
  });
}















