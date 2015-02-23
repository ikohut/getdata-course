# getdata-course

The repository includes course work for Getting and Cleaning Data course.
There is one function run_analysis() which performs all work for handling input data and generating tidy dataset.
The function assumes that input data are located in the subfolders of working directory.
The code requires "data.table" and "dpyr" packages

Example of usage

```
write.table(run_analysis(), "output.txt", row.names = FALSE) 
```
The line above call run_analysis and store the results in file "output.txt" in working directory.