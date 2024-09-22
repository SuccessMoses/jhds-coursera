#Load the neccessary library
library(ggplot2)
library(dplyr)

# Create a vector, 'coal' of SCC integer that involves 
# coal combustion-related sources
classification <- readRDS('Source_Classification_Code.rds')
coal <- with(classification, SCC[grepl('[Cc]oal', Short.Name)]) %>%
  as.character

# Read the data and change 'year' to a factor variable and filter rows
# that involve coal combution-related sources
data <- readRDS('summarySCC_PM25.rds') %>%
  mutate(year=as.factor(year)) %>%
  filter(SCC %in% coal)

# Make a box-plot showing log(Emissions) for each year 
png('plot4.png')
qplot(year, log(Emissions), data=data, geom='boxplot',
      main='Total Emission from coal combustion across the US')
dev.off()
