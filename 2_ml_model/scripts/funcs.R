dummy_example = X_test[1,,drop=FALSE]
dummy_test  = xgb.DMatrix(dummy_example, missing = NA)
pred = predict(model,dummy_test)
pred
y_test[1]


dummy_example[,desc_vars_idx] = 0
dummy_test  = xgb.DMatrix(dummy_example, missing = NA)
blank_pred = predict(model,dummy_test)
blank_pred


get_next_words = function(snippet, lookup_list){
  
  return (lookup_list[which(grepl(paste0('^',snippet), lookup_list))])
  
}


snippet = 'easy access'
next_words = get_next_words(snippet, m@Dimnames$Terms)

for (i in 1:length(next_words)){
  cat('\n')
  
  col_num = which(col_headings==paste0('txt_',next_words[i]))
  
  dummy_example[col_num] = 1
  dummy_test  = xgb.DMatrix(dummy_example, missing = NA)
  new_pred = predict(model,dummy_test)
  
  cat(next_words[i], ': ', new_pred)
  
  dummy_example[,desc_vars_idx] = 0
  
  
}




