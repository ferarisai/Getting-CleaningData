# Loading required packages
library("data.table")
library("reshape2")

# Rading the data from files assuming the Dataset is downloaded 
# and unzipped in the working directory of R

dtSubjectTrain <- fread("./UCI HAR Dataset/train/subject_train.txt")
dtSubjectTest  <- fread("./UCI HAR Dataset/test/subject_test.txt" )
dtActivityTrain <- fread("./UCI HAR Dataset/train/Y_train.txt")
dtActivityTest  <- fread("./UCI HAR Dataset/test/Y_test.txt" )
dtActivityLabels <-fread("./UCI HAR Dataset/activity_labels.txt")
dtFeatures <-fread("./UCI HAR Dataset/features.txt")

filetoDataTable <- function (f) {
  df <- read.table(f)
  dt <- data.table(df)
}

dtTrain <-filetoDataTable ("./UCI HAR Dataset/train/X_train.txt")
dtTest  <- filetoDataTable("./UCI HAR Dataset/test/X_test.txt")


# 1.Merging the training and the test sets to create one data set.

dtActivity <- rbind(dtActivityTest,dtActivityTrain)
setnames(dtActivity, "V1", "activityNum")
dtSubject <- rbind(dtSubjectTest,dtSubjectTrain)
setnames(dtSubject, "V1", "subject")
dtSubject <- cbind(dtSubject,dtActivity) 
dt <- rbind(dtTest,dtTrain)
setnames(dt,names(dt),dtFeatures$V2)
setnames(dtActivityLabels, names(dtActivityLabels), c("activityNum", "activityName"))

# 2.Extract only the measurements on the mean and standard deviation for each measurement. 
ext <- grepl("mean\\(\\)|std\\(\\)",names(dt))
dt<-dt[,c(ext),with = FALSE]
dt<- cbind(dtSubject,dt)
setkey(dt, subject, activityNum)
dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", V2)]

# Pivoting the Data table based on the Key Columns
dt <- data.table(melt(dt, key(dt), variable.name="featureName"))

# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 

# Merging Activity Lables to the Data using a merge on the Activity Number

dt <- merge(dt, dtActivityLabels, by="activityNum", all.x=TRUE)
setkey(dt, subject, activityNum, activityName)

grepthis <- function (regex) {
  grepl(regex, dt$featureName)
}

n <- 2
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(grepthis("^t"), grepthis("^f")), ncol=nrow(y))
dt$Domain <- factor(x %*% y, labels=c("Time", "Frequency"))
x <- matrix(c(grepthis("Acc"), grepthis("Gyro")), ncol=nrow(y))
dt$Instrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))
x <- matrix(c(grepthis("BodyAcc"), grepthis("GravityAcc")), ncol=nrow(y))
dt$Acceleration <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))
x <- matrix(c(grepthis("mean()"), grepthis("std()")), ncol=nrow(y))
dt$Variable <- factor(x %*% y, labels=c("Mean", "SD"))
## Features with 1 category
dt$Jerk <- factor(grepthis("Jerk"), labels=c("NA", "Yes"))
dt$Magnitude <- factor(grepthis("Mag"), labels=c("NA", "Yes"))
## Features with 3 categories
n <- 3
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(grepthis("-X"), grepthis("-Y"), grepthis("-Z")), ncol=nrow(y))
dt$Axis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))

# 5.From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.
setkey(dt, subject, activityName, Domain, Acceleration, Instrument, Jerk, Magnitude, Variable, Axis)
dtTidy <- dt[, list(count = .N, average = mean(value)), by=key(dt)]

write.table(dtTidy, file = "./TidyData.txt", append = FALSE,row.name=FALSE)



