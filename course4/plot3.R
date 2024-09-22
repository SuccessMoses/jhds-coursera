#Load the neccessary library
library(ggplot2)
library(dplyr)

#Read the data and filter only rows that contains data from 
#Baltimore city, then change year to a factor variable

data <- readRDS('summarySCC_PM25.rds') %>%
  filter(fips=='24510') %>% mutate(year=as.factor(year))

# Make the plot of Emissions against year, but first take the log
# of Emissions to deal with very large outliers, create different
# panels that corrsponds to the type of emissions

png('plot3.png')
qplot(data=data, year, log(Emissions), facets = . ~type, 
      geom='boxplot')

dev.off()