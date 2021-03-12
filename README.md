# clipboard_dataframe
Read clipboard and raw strings to data.frame in R
<hr>
Inspired by pandas.read_clipboard() from Python's pandas. The goal is to make it easy to read string representations of small tabular data into R without having to screw around with packages like readr or whatever.<br>
Like pandas.read_clipboard, this does automatic numeric type parsing and coercion, unless you turn it off by setting parse_types to FALSE.<br>

This function is somewhat picky about its inputs; don't be surprised if you see an error due to uneven column lengths. In fact, this is guaranteed to happen if any of the entries in a column have spaces between them.<br>
One way around this is to use "\\s{2,}" as the sep instead of the default "\\s+". This will ignore single spaces between words and only delineate columns by two or more blankspace characters.
<hr>
ARGUMENTS<br>
sep: a pattern on which to split each row of the input. Default is to split on all whitespace.
head_row: Optional. Either the number of a row to be promoted to the column names, OR a string vector of column names.
<li>
If head_row is a vector of column names, its length must be equal to the number of columns BEFORE removing unwanted columns. So if your input string has five columns and you are removing two, you still need to supply a vector of names of length 5 for head_row.</li>
ignore_rows: Optional. A vector of integer row numbers to exclude from the final output data.frame.<br>
ignore_cols: Optional. A vector of integer column numbers to exclude from the final output data.frame. See comment above about this argument's interaction with head_row.
