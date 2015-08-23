{\rtf1\ansi\ansicpg1252\cocoartf1348\cocoasubrtf170
{\fonttbl\f0\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab720
\pard\pardeftab720

\f0\fs26 \cf0 \expnd0\expndtw0\kerning0
Codebook\
========\
Codebook was generated on 2015-08-23 18:27:24 during the same process that generated the dataset. See `run_analysis.md` or `run_analysis.html` for details on dataset creation.\
\
Variable list and descriptions\
------------------------------\
\
Variable name    | Description\
-----------------|------------\
subject          | ID the subject who performed the activity for each window sample. Its range is from 1 to 30.\
activity         | Activity name\
Domain           | Feature: Time domain signal or frequency domain signal (Time or Freq)\
Instrument       | Feature: Measuring instrument (Accelerometer or Gyroscope)\
Acceleration     | Feature: Acceleration signal (Body or Gravity)\
Variable         | Feature: Variable (Mean or SD)\
Jerk             | Feature: Jerk signal\
Magnitude        | Feature: Magnitude of the signals calculated using the Euclidean norm\
Axis             | Feature: 3-axial signals in the X, Y and Z directions (X, Y, or Z)\
Count            | Feature: Count of data points used to compute `average`\
Average          | Feature: Average of each variable for each activity and each subject\
\
Dataset structure\
-----------------\
\
```\{r\}\
str(dtTidy)\
```\
\
List the key variables in the data table\
----------------------------------------\
\
```\{r\}\
key(dtTidy)\
```\
\
Show a few rows of the dataset\
------------------------------\
\
```\{r\}\
head(dtTidy)\
```\
\
Summary of variables\
--------------------\
\
```\{r\}\
summary(dtTidy)\
```\
\
