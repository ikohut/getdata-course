# run_analysis() Code Book

Function run_analysis() returns data table where each row is unique for user and activity.
Response includes such columns as:
- "Activity" - text label for activity generated accordingly to activity_labels.txt from input data set
- "Subject" - it's ID of user
- columns from "tBodyAcc-mean()-X" till "fBodyBodyGyroJerkMag-std()" - average values of corresponding measurment. Comparing to original data set, current output includes on mean and std measurements. Each value is normalized in range (-1;1). Detailed information about these columns can be found in features_info.txt

