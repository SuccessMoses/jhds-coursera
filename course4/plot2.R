#Load 'dplyr' because we are going to be using '%>%'
library(dplyr)

#Read the data, filter out only rows that have fips=='24510'
# (i.e Baltimore city) and group the data by year

data <- readRDS('summarySCC_PM25.rds')
tidy_data <- filter(data, fips='24510') %>% 
  group_by(year) %>% 
  summarise(total.emissions=sum(Emissions))

#Create a vector of total emissions for each year
emissions <- tidy_data$total.emissions
names(emissions) <- tidy_data$year

#Open PNG file and make the plot of total emissions
# using base R system.

png('plot2.png')
barplot(emissions, col=1:4, 
        main='Total Emissions in Baltimore city by year', 
        xlab='Year', ylab='Total Emission in tons')

#Close the PNG file
dev.off()
