library("ggplot2")

create_plot <- function(data_list) {
  g <- qplot(year, x, data = data_list, geom="bar", stat = "identity")
  g2 <- g + facet_grid(. ~ fips, labeller=fips_labeller)
  g3 <- g2 + ggtitle("Motor Vehicle Emissions by Year in Baltimore, MD and Los Angeles County, CA") + ylab("Tons PM2.5") + xlab("Year")
  ggsave(filename="plot6.png", plot=g3)
}

# The EPA website states: 
# The four sectors for on-road mobile sources include emissions from motorized vehicles 
# that are normally operated on public roadways. This includes passenger cars, motorcycles,
# minivans, sport-utility vehicles, light-duty trucks, heavy-duty trucks, and buses. 
# The sectors include emissions from parking areas as well as emissions while the vehicles 
# are moving.
subsetToMotorVehicles <- function(data_frame) {
  subset(data_frame, type == "ON-ROAD")
}

reduceToBalAndLA <- function(data_frame) {
  subset(data_frame, fips %in% c("24510", "06037")) 
}

aggregateOnYear <- function(data_frame) {
  r <- aggregate(data_frame$Emissions, by=list(fips = data_frame$fips, type=data_frame$type, year=data_frame$year), FUN=sum)
  r$fips = as.factor(r$fips)
  levels(r$fips) <- c("Los Angeles County", "Baltimore City")
  r
}

transormAndPlot <- function(data_frame) {
  create_plot(aggregateOnYear(subsetToMotorVehicles(reduceToBalAndLA(data_frame))))
}

readData <- function() {
  NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
  NEI$year <- as.factor(NEI$year)
  NEI$SCC <- as.factor(NEI$SCC)
  NEI
}

runScript <- function() {
  transormAndPlot(readData())
}