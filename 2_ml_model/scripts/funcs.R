get_next_words = function(snippet, lookup_list){
  
  
  
  return (lookup_list[which(grepl(paste0('^',snippet), lookup_list))])
  
  
  
}
  
get_next_words('a private', m@Dimnames$Terms)
