    subject.train <- readLines('subject_train.txt')
    x.train <- readLines('X_train.txt')
    y.train <- readLines('y_train.txt')
    subject.test <- readLines('subject_test.txt')
    x.test <- readLines('X_test.txt')
    y.test <- readLines('y_test.txt')

## Introduction

In this article is describe the code and transformation I used to clean
up data. The data is from collected from the accelerometer and gyroscope
of the Samsung Galaxy S smartphone. The data include labels from human
activities which include Sitting, Laying Down, Walking, Walking Up,
Walking Down, etc. The data is presented in a *.txt* format. So before
we can do any type of processing we have to load the data and format it
into a data frame.

    library(dplyr)

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    data1 <- lapply(x.train, trimws) %>% as.character %>%
      strsplit('\\s+') %>% as.data.frame %>% t %>% as.data.frame

    data2 <- lapply(x.test, trimws) %>% as.character %>%
      strsplit('\\s+') %>% as.data.frame %>% t %>% as.data.frame

The data consists of *data1* which is the training set and *data2* which
is the test set. In this study, I am only interested in the measurements
on the mean and standard deviation for each meausrement. So I am going
to select columns that I am interested in and merge *data1* and *data2*
into a single *data* dataframe

    col <- readLines('features.txt') %>% strsplit('\\s+') %>%
      lapply(function(vector){vector[2]}) %>% as.character
    names(data1) <- col
    names(data2) <- col
    data1 <- data1[,grepl('-mean|-std', names(data1))]
    data2 <- data2[,grepl('-mean|-std', names(data2))]
    data <- rbind(data1, data2)

Now that I have my dataframe object, I am going to group it by
*activity* and *subject*. And summarise the dataframe with he average of
each variable for each activity and each subject.

    data <- lapply(data, as.numeric) %>% as.data.frame
    data <- group_by(data, activity, subject) %>% 
      summarise_all(mean)
    data$activity <- factor(data$activity, 
                            labels = c('WALKING', 'WALKING UPSTAIRS', 
                                       'WALKING DOWNSTAIRS', 
                                       'SITTING', 'STANDING', 
                                       'LAYING')
    )

Now my final tidy dataset should look like this

    head(data)

    ## # A tibble: 6 × 81
    ## # Groups:   activity [1]
    ##   activity subject tBodyAcc.mean...X tBodyAcc.mean...Y
    ##   <fct>      <dbl>             <dbl>             <dbl>
    ## 1 WALKING        1             0.277           -0.0174
    ## 2 WALKING        2             0.276           -0.0186
    ## 3 WALKING        3             0.276           -0.0172
    ## 4 WALKING        4             0.279           -0.0148
    ## 5 WALKING        5             0.278           -0.0173
    ## 6 WALKING        6             0.284           -0.0169
    ## # ℹ 77 more variables: tBodyAcc.mean...Z <dbl>,
    ## #   tBodyAcc.std...X <dbl>, tBodyAcc.std...Y <dbl>,
    ## #   tBodyAcc.std...Z <dbl>, tGravityAcc.mean...X <dbl>,
    ## #   tGravityAcc.mean...Y <dbl>, tGravityAcc.mean...Z <dbl>,
    ## #   tGravityAcc.std...X <dbl>, tGravityAcc.std...Y <dbl>,
    ## #   tGravityAcc.std...Z <dbl>, tBodyAccJerk.mean...X <dbl>,
    ## #   tBodyAccJerk.mean...Y <dbl>, tBodyAccJerk.mean...Z <dbl>, …
