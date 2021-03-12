library(stringr)
library(stringi)

string_rows_dataframe = function(strvec,
                                 sep='\\s+',
                                 head_row=NULL,
                                 ignore_rows=NULL,
                                 ignore_cols=NULL) {
  strvec = mapply(str_trim,strvec,'right')   #remove hanging whitespace from ends of rows
  if (! is.null(head_row)) {
    if (! (length(head_row)==1 & is.numeric(head_row))) { 
      #head_row is not null and not a row number
      #that means that head_row is a list of column names, i.e., the header
      header = head_row
    } else {
      #head_row is a row number; use the head_row^th row of the input as a header
      header = na.exclude(str_split(strvec[[head_row]],sep))[[1]]
    }
    if (! is.null(ignore_rows)) { #cull the ignored rows and/or header from input
      if (is.numeric(head_row)) {
        strvec = strvec[-c(head_row,ignore_rows)] 
      }
    } else {
      strvec = strvec[-head_row]
    }
  } else {
    header <- NULL
    if (! is.null(ignore_rows)) {
      strvec = strvec[-ignore_rows]
    }
  }
  strvec_split <- na.exclude(mapply(str_split,strvec,sep))  #split all rows with designated separator
  transposed_frame = t(data.frame(strvec_split))
  out_dframe = as.data.frame(transposed_frame,
                             row.names=FALSE,
                             fix.empty.names = TRUE)
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
                               ignore_cols=NULL) {
  strvec = readClipboard()
  string_rows_dataframe(strvec,sep,head_row,ignore_rows,ignore_cols)
}

string_dataframe = function(string,
                            sep = '\\s+',
                            head_row=NULL,
                            ignore_rows=NULL,
                            ignore_cols=NULL) {
  strvec = str_split(string,'\r?\n')[[1]] #splits a string by the newline character
  string_rows_dataframe(strvec,sep,head_row,ignore_rows,ignore_cols)
}
