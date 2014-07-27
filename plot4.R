library("ggplot2")

create_plot <- function(data_list) {
  g <- qplot(year, x, data = t, geom="bar", stat = "identity")
  g2 <- g + ggtitle("Coal Emissions per Year in the US") + ylab("Tons PM2.5") + xlab("Year")
  ggsave(filename="plot4.png", plot=g2)
}

aggregateOnYear <- function(data_frame) {
  aggregate(data_frame$Emissions, by=list(type=data_frame$type, year=data_frame$year), FUN=sum)  
}

isCoal <- function(shortName) {
  grepl("(Comb.*(Coal|Lignite))|Charcoal Grilling|(Fuel Use.*(Coal|Lignite))|Coal[ -]fired", shortName)
}

subsetToCoal <- function(data_frame) {
  SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")
  coalCodes <- factor(subset(SCC, isCoal(Short.Name))$SCC)
  subset( NEI, SCC %in% f)
}

readData <- function() {
  NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
  NEI$year <- as.factor(NEI$year)
  NEI$SCC <- as.factor(NEI$SCC)
}

runScript <- function() {
  create_plot(aggregateOnYear(subsetToCoal(readData())))
}