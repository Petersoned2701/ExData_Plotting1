# Load Household Consumption Data into R and create a file with 4 separate graphs
# of Global Active Power over time, Voltage over time, sub metering over time, and
# Global Reactive Power over time.
# Assumes that the data file is in the R working directory and that user has dplyr and readr
# packages. If you do not, please install those packages.

# Using dplyr and readr
library(dplyr)
library(readr)

# Read text file in with read_delim() from readr
hcp <- read_delim("household_power_consumption.txt", delim = ";", na = "?")

# Convert Date from character to R Date format using mutate() from dplyr
hcp <- mutate(hcp, Date = as.Date(Date, format = "%d/%m/%Y"))

# Create two Date variables for the dates we want to subset
Date_1 <- as.Date("2007-02-01")
Date_2 <- as.Date("2007-02-02")

# Subset hcp over those dates and bind them into a new data frame
hcp_1 <- subset(hcp, Date == Date_1)
hcp_2 <- subset(hcp, Date == Date_2)
hcp_target <- rbind(hcp_1, hcp_2)


# Remove hcp, hcp_1, and hcp_2 from Environment as they are no longer needed
rm(hcp)
rm(hcp_1)
rm(hcp_2)

# Create a new column called Date_time that combines date and time using mutate
hcp_target <- mutate(hcp_target, Date_time = as.POSIXct(paste(hcp_target$Date, 
                                                              hcp_target$Time), format = "%Y-%m-%d %H:%M:%S"))

# Open PNG file to write plot to
png(file = "plot4.png")

# Set up the plot space for four plots
par(mfrow = c(2,2))

# Plot a line graph of Global Active Power vs. Date_time
plot(hcp_target$Date_time, hcp_target$Global_active_power, type = "l", ylab = "Global Active Power",
     xlab = "")

# Plot a line graph of Voltage vs Date_time
plot(hcp_target$Date_time, hcp_target$Voltage, type = "l", ylab = "Voltage",
     xlab = "datetime")

# Plot a line graph of Sub metering vs. Date_time
# Create a blank plot so we can add new data
plot(hcp_target$Date_time, hcp_target$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = " ")

# Populate the plot with the three sub metering variables
points(hcp_target$Date_time, hcp_target$Sub_metering_1, type = "l")
points(hcp_target$Date_time, hcp_target$Sub_metering_2, type = "l", col = "red")
points(hcp_target$Date_time, hcp_target$Sub_metering_3, type = "l", col = "blue")

# Add a legend to the top right corner
legend("topright", lty = c(1, 1, 1), col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Create a plot of Global Reactive Power over Date_time
plot(hcp_target$Date_time, hcp_target$Global_reactive_power, type = "l", ylab = "Global_reactive_power",
     xlab = "datetime")

# Close PNG file
dev.off()

# Remove hcp_target, Date_1, and Date_2 from the Environment
rm(hcp_target)
rm(Date_1)
rm(Date_2)

