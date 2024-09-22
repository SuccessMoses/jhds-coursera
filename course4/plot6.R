library(ggplot2)
library(dplyr)

# Create a vector of SCC character that involves motor vehicle
# related sources only
classification <- readRDS('Source_Classification_Code.rds')
rocketmotor <- with(classification, 
                    SCC[grepl('[Rr]ocket [Mm]otor', Short.Name)]
                    ) %>% as.character

motorvehicle <- with(classification, 
                    SCC[grepl('[Mm]otor', Short.Name)]
                    ) %>% as.character


# Read the data and change 'year' to a factor variable and filter rows
# that involve Motor Vehicle sources only
data <- readRDS('summarySCC_PM25.rds') %>%
  mutate(year=as.factor(year)) %>%
  filter(fips=='24510' | fips=='06037') %>%
  filter(SCC %in% motorvehicle) %>%
  filter(SCC != rocketmotor)

# Make a box-plot showing log(Emissions) for each year 
png('plot4.png')
qplot(year, log(Emissions), data=data, geom='boxplot',
      facets = .~ fips,
      main='Total Emission from Motor Vehicle')
dev.off()
