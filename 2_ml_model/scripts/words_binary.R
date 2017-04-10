doWords = function(newrow){

#
# Beating the Benchmark 
# Search Results Relevance @ Kaggle
# __author__ : Abhishek
# __ported to R__:gmilosev
# Tested on MS Windows Server 2012, Quad Core Xeon 3.2 Ghz, 24 Gb RAM
# R Version 3.2.0 64 bit
#

library("tm")
library("caret");
library("Metrics")
library("e1071");
library("rARPACK");
library("RWeka");
library("Matrix");
library("kernlab")
library("readr")
library("slam");
library("doParallel");
library("foreach");

python.tfidf = function(txt,smooth_idf=T,sublinear_tf=F,
                        normf=NULL,
                        min_df=1,
                        do.trace=T,
                        use_idf = F,
                        ngram_range=NULL){
  #corpus first
  corp = NULL;
  if(do.trace) print("Building corpus!");
  if (!is.na(match(class(txt),c("VCorpus","Corpus")))) corp = txt;
  if (!is.na(match(class(txt),c("VectorSource","SimpleSource","Source")))) {corp = Corpus(tolower(txt));}
  if (class(txt) == "character") {corp = VCorpus(VectorSource(tolower(txt)));}
  if (is.null(corp)) {stop(paste("Don't know what to do with", class(txt)));}
  
  #cleaning
  
  if(do.trace) print("Cleaning!");
  #corp = tm_map(corp, removeWords, stopwords('english'))
  #corp = tm_map(corp, removeNumbers)
  corp = tm_map(corp, removePunctuation)
  #corp <- tm_map(corp, content_transformer(gsub), pattern = "[0-9]+", replacement = "<number>")
  
  
  
  #document term matrix
  if(do.trace) print("Building document term matrix!");
  
  
  #ngram range
  Tokenizer = NULL;
  if (!is.null(ngram_range)){
    if(do.trace) print(paste("Using NGramTokenizer, range:",ngram_range[1],":",ngram_range[2]));
    Tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = ngram_range[1], max = ngram_range[2]))
    #Tokenizer <-function(x) unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)
    options(mc.cores=1)
    dtm = DocumentTermMatrix(corp,control=list(tokenize=Tokenizer
                                               ,removePunctuation=F
                                               ,wordLengths=c(1,10000)
                                               ,weighting=function(x) weightTf(x)
                                               ))
  } else {
    dtm = DocumentTermMatrix(corp,control=list(removePunctuation=T,wordLengths=c(1,10000),weighting=function(x) weightTf(x)));
  }
  if(do.trace) print("Converting from sparse to dense matrix!");
  m = dtm;
  # When building the vocabulary ignore terms that have a document frequency
  # strictly lower than the given threshold.
  # This value is also called cut-off in the literature.
  cs = col_sums(m>0);
  n_doc = dim(m)[1];
  if(do.trace) print("Removing sparse terms!");
  
  # drop the terms with less than min_df freq
  # hard min freq integer
  if (min_df %% 1 == 0){
    m = m[,cs>=min_df];
    cs = col_sums(m>0);
    
    if(do.trace) print(paste("TDM dim:",dim(m)[1],":",dim(m)[2]));
  } else {
    #consider it as percentage
    if (min_df > 0 && min_df <= 1){
      thr = n_doc * (1-min_df);
      if (thr < 1) thr = 1;
      m = m[,cs>=thr];
      cs = col_sums(m>0);
    } else {
      stop("Don't know what to do with min_df, not an integer and not a float 0..1");
    }
  }
  
  # Apply sublinear tf scaling, i.e. replace tf with 1 + log(tf).
  if(sublinear_tf==TRUE) {
    if(do.trace) print("Applying sublinear tf scaling!");
    m$v = 1 + log(m$v);
  }
  
  # Smooth idf weights by adding one to document frequencies, as if an
  # extra document was seen containing every term in the collection
  # exactly once. Prevents zero divisions.
  if(smooth_idf==TRUE) {
    if(do.trace) print("Applying idf smoothing!");
    n_doc = n_doc + 1;
    cs = cs + 1;
  }
  
  m[m>0] = 1
  
  # cast to sparse matrix
  # so that Diagonal * m is fast and eficient
  m = sparseMatrix(m$i,m$j,x=m$v,dims=dim(m),dimnames=dimnames(m));
  if (use_idf){
    idf = 1+log(n_doc/cs);
    d = Diagonal(length(idf),idf);
    m = m%*%d;
    d = NULL;
  }
  
  
  
  

  # return sparse matreix
  if(do.trace) print("Done!");
  return(m);
}

words_data = fread("./data/words_data.csv");





# combine query title and description into single character array
txt = words_data$product_description;

if (!is.null(newrow)){
  
  txt = c(txt, newrow)
  
}


# get document term matrix
m = python.tfidf(txt,sublinear=T,smooth_idf=T,normf="l2",min_df=20,ngram_range=c(2,2))

return (m)

}


