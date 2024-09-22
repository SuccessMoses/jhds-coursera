# This code reads lines from .txt files, converts the raw text file
# to a dataframe, selects certain variables to work with,
# group the data based on 'activity' and 'subject',
# summarises(using the mean() function) the data by groups,
# and present this data in a tidy way where the 

# Read data and install libraries
library(dplyr)
subject.train <- readLines('subject_train.txt')
x.train <- readLines('X_train.txt')
y.train <- readLines('y_train.txt')
subject.test <- readLines('subject_test.txt')
x.test <- readLines('X_test.txt')
y.test <- readLines('y_test.txt')


# Format the data to data frame object
data1 <- lapply(x.train, trimws) %>% as.character %>%
  strsplit('\\s+') %>% as.data.frame %>% t %>% as.data.frame

data2 <- lapply(x.test, trimws) %>% as.character %>%
  strsplit('\\s+') %>% as.data.frame %>% t %>% as.data.frame

# Select coulmn that are mean or std
col <- readLines('features.txt') %>% strsplit('\\s+') %>%
  lapply(function(vector){vector[2]}) %>% as.character
names(data1) <- col
names(data2) <- col
data1 <- data1[,grepl('-mean|-std', names(data1))]
data2 <- data2[,grepl('-mean|-std', names(data2))]


# Merge train and test dataframe
data <- rbind(data1, data2)
subject <- c(subject.train, subject.test)
activity <- c(y.train, y.test)
data$subject <- subject
data$activity <- activity
data$activity <- factor(data$activity, 
                        labels = c('WALKING', 'WALKING UPSTAIRS', 
                                   'WALKING DOWNSTAIRS', 
                                   'SITTING', 'STANDING', 
                                   'LAYING')
                        )


# Group and summarise the data
data <- lapply(data, as.numeric) %>% as.data.frame
data <- group_by(data, activity, subject) %>% 
  summarise_all(mean)
data$activity <- factor(data$activity, 
                        labels = c('WALKING', 'WALKING UPSTAIRS', 
                                   'WALKING DOWNSTAIRS', 
                                   'SITTING', 'STANDING', 
                                   'LAYING')
)

