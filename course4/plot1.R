#Load 'dplyr' because we are going to be using '%>%'
library(dplyr)

#Read the data and group it by year
data <- readRDS('summarySCC_PM25.rds')
tidy_data <- group_by(data, year) %>% 
  summarise(total.emissions=sum(Emissions))

#Create a vector of total emissions for each year
emissions <- tidy_data$total.emissions
names(emissions) <- tidy_data$year

#Rescale total emissions to be measured in Millions of tons
emissions <- emissions/1000000

#Open PNG file and make the plot of total emissions
# using base R system.

png('plot1.png')
barplot(emissions, col=1:4, main='Total Emissions in the US by year', 
        xlab='Year', ylab='Emision in millions of tons')

#Close the PNG file
dev.off()
