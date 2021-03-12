# clipboard_dataframe
## Read clipboard and raw strings to data.frame in R
<hr>
Inspired by pandas.read_clipboard() from Python's pandas. The goal is to make it easy to read string representations of small tabular data into R without having to mess around with packages like readr or whatever.<br>
Like pandas.read_clipboard, this does automatic numeric type parsing and coercion, unless you turn it off by setting parse_types to FALSE.<br>

This function is somewhat picky about its inputs; don't be surprised if you see an error due to uneven column lengths. In fact, this is guaranteed to happen if any of the entries in a column have spaces between them.<br>
One way around this is to use "\\s{2,}" as the sep instead of the default "\\s+". This will ignore single spaces between words and only delineate columns by two or more blankspace characters.
<hr>
<b style= 'font-size:120%'>ARGUMENTS</b>
<li>
<b>sep</b>: a pattern on which to split each row of the input. Default is to split on all whitespace.<br>
<b>head_row</b>: Optional. Either the number of a row to be promoted to the column names, OR a string vector of column names.
<ul>
  <em>If head_row is a vector of column names</em>, its length must be equal to the number of columns BEFORE removing
  unwanted columns. So if your input string has five columns and you are removing two, you still need to supply a vector of
  names of length 5 for head_row.</ul>
<b>ignore_rows</b>: Optional. A vector of integer row numbers to exclude from the final output data.frame.<br>
<b>ignore_cols</b>: Optional. A vector of integer column numbers to exclude from the final output data.frame. See comment above about this argument's interaction with head_row.<br>
  <b>parse_types</b>: Optional boolean, default TRUE. Toggles type coercion. 
  <ul>If true, uses regular expressions (in the convert_types_list) function to detect if a column is all integers, in which case it converts the column to the integer data type. If that fails, but R finds that all the entries are either string representations of numbers or strings of the form '' (empty string), 'NAN', 'na', or some case variant thereof, the function coerces the column to floats. If all those checks fail, the column is left as the character data type.</ul>
</li>
