library(ggplot2)
library(gridExtra)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
NEI_Baltimore <- subset(NEI, fips == "24510")

point <- subset(NEI_Baltimore, type == "POINT")
nonpoint <- subset(NEI_Baltimore, type == "NONPOINT")
onroad <- subset(NEI_Baltimore, type == "ON-ROAD")
nonroad <- subset(NEI_Baltimore, type == "NON-ROAD")

total_point <- with(point, tapply(Emissions, year, sum, na.rm=TRUE))
total_nonpoint <- with(nonpoint, tapply(Emissions, year, sum, na.rm=TRUE))
total_onroad <- with(onroad, tapply(Emissions, year, sum, na.rm=TRUE))
total_nonroad <- with(nonroad, tapply(Emissions, year, sum, na.rm=TRUE))

tpoint <- data.frame(year=names(total_point), TotalEm = total_point)
tnonpoint <- data.frame(year=names(total_nonpoint), TotalEm = total_nonpoint)
tonroad <- data.frame(year=names(total_onroad), TotalEm = total_onroad)
tnonroad <- data.frame(year=names(total_nonroad), TotalEm = total_nonroad)

mrg <- merge(tpoint, tnonpoint, by = "year")
mrg <- merge(mrg, tnonroad, by = "year")
mrg <- merge(mrg, tonroad, by = "year")
names(mrg)[1] <- "year"
names(mrg)[2] <- "POINT"
names(mrg)[3] <- "NONPOINT"
names(mrg)[4] <- "NONROAD"
names(mrg)[5] <- "ONROAD"

plot1 <- qplot(year, POINT, data = mrg)
plot2 <- qplot(year, NONPOINT, data = mrg)
plot3 <-  qplot(year, ONROAD, data = mrg)
plot4 <- qplot(year, NONROAD, data = mrg)
grid.arrange(plot1, plot2, plot3, plot4, nrow=2, ncol=2)
png("plot3.png")
grid.arrange(plot1, plot2, plot3, plot4, nrow=2, ncol=2, top = "Total PM2.5 Emission in Baltimore City wrt types")
dev.off()

