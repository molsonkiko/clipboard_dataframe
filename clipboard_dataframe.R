library(stringr)
library(stringi)
library(dplyr)


string_rows_dataframe = function(strvec,
                                 sep='\\s+',
                                 head_row=NULL,
                                 ignore_rows=NULL,
                                 ignore_cols=NULL,
                                 parse_types = TRUE) {
  strvec = mapply(str_trim,strvec,'right') 
  #remove hanging whitespace from ends of rows
  if (! is.null(head_row)) {
    if (! (length(head_row)==1 & is.numeric(head_row))) { 
      #head_row is a row number
      header = head_row
    } else {
      #head
      header = na.exclude(str_split(strvec[[head_row]],sep))[[1]]
    }
    if (! is.null(ignore_rows)) {
      if (is.numeric(head_row)) {
        strvec = strvec[-c(head_row,ignore_rows)]
      }  else {
        strvec = strvec[-ignore_rows]
      }
    } else {
      if (is.numeric(head_row)) {
        strvec = strvec[-head_row]
      }
    }
  } else {
    header <- NULL
    if (! is.null(ignore_rows)) {
      strvec = strvec[-ignore_rows]
    }
  }
  
  strvec_split <- na.exclude(mapply(str_split,strvec,sep))
  transposed_frame = t(data.frame(strvec_split))
  out_dframe = as.data.frame(transposed_frame,
                             row.names=FALSE,
                             fix.empty.names = TRUE)
  
  if (parse_types==TRUE) { #Use the regular expressions below to automatically parse column types and convert them
    out_dframe <- as.data.frame(lapply(out_dframe,convert_types_list))
  }
  
  if (! is.null(ignore_cols)) {
    vvec = sapply(mapply(str_glue,ignore_cols,c("V")),
                  stri_reverse)
    #vvec is the vector ["V"+str(i) for i in ignore_cols]
    #because the default colnames for a data.frame are
    #c("V1","V2","V3","V4",...)
    out_dframe <- out_dframe %>% select(-vvec)
    if (! is.null(header)) { header = header[-ignore_cols] }
  }
  
  if (! is.null(header)) {
    colnames(out_dframe) = header
  }
  out_dframe
}

clipboard_dataframe = function(sep="\\s+",
                               head_row=NULL,
                               ignore_rows=NULL,
                               ignore_cols=NULL,
                               parse_types = TRUE) {
  strvec = readClipboard()
  string_rows_dataframe(strvec,sep,head_row,ignore_rows,ignore_cols,parse_types)
}

string_dataframe = function(string,
                            sep = '\\s+',
                            head_row=NULL,
                            ignore_rows=NULL,
                            ignore_cols=NULL,
                            parse_types = TRUE) {
  strvec = str_split(string,'\r?\n')[[1]]
  string_rows_dataframe(strvec,sep,head_row,ignore_rows,ignore_cols,parse_types)
}

numregex = '^-?\\d*\\.?\\d+$'
intregex = '^-?\\d+$'
nanregex= '(?i)(^na[n]?$|^$)' 
#(?i) at the beginning makes entire regex case-insensitive

convert_types_list <- function(list_) {
  len_ = length(list_)
  nancount = len_ - sum(is.na(str_match(list_,nanregex))[,1])
  floatcount = len_ - sum(is.na(str_match(list_,numregex))[,1])
  intcount = len_ - sum(is.na(str_match(list_,intregex))[,1])
  if (intcount == len_) { #list_ is all integers, so make it ints
    as.integer(list_)
  } else if (floatcount + nancount == len_) {
    as.numeric(list_) #if list_ is all floats and nan's, make it numeric
  } else {
    list_ #if all else fails, leave it as characters
  }
}

assorted_strings = c('a','1b','12.5','','nan','NaN','-7.8c','-1.2','-3','b',
             'na','NA','2','NaCl','naturally')

all_ints = c('39', '64', '87', '36', '22', '1', '60', '75', 
             '12', '45', '97', '5', '30', '38', '18')

nums_and_nans = c('1','','nan','2','13.4','-400.23',
                  '-0.9758769273310667', '-1.155026681824496', 
                  '-0.17578621901546307', '-0.2326359733469704', '-0.5770294020936887', 
                  '-0.08014278356830644', '-1.352910994914262', 
                  '-0.9283167810811379', '2.270282854269814')
convert_types_list_test_df = data.frame(stuff=stuff,ints=all_ints,floats=nums_and_nans)
