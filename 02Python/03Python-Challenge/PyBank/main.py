###############################################################################
# Homework                                                                    #
# This script analyzes the records to calculate each of the following:        #
# - The total number of months included in the dataset.                       #
# - The net total amount of "Profit/Losses" over the entire period            #
# - The average of the changes in "Profit/Losses" over the entire period      #
# - The greatest increase in profits (date and amount) over the entire period #
# - The greatest decrease in losses (date and amount) over the entire period  #
###############################################################################

###############################################################################
# import librarys                                                             #
###############################################################################
import csv
import os

###############################################################################
# Declare variables to store data                                             #
###############################################################################
numOfMonths = 0
totalProfitLosses = 0
lastValueProfitLooses = 0
changeProfitLosses = 0
avgChanges = 0.0
greatIncreaseAmount = 0
greatIncreaseDate = ""
greatDecreaseAmount = 0
greatDecreaseDate = ""

###############################################################################
# Open data source                                                            #
###############################################################################
budgetDataCsv = os.path.join(".","resources","budget_data.csv")

###############################################################################
# Open file and gather data                                                   #
###############################################################################
with open(budgetDataCsv, "r", encoding="UTF-8") as csvFile:
    csvReader = csv.reader(csvFile, delimiter=",")
    csvHeader = next(csvReader)
    
    ###########################################################################
    # Read data and calculate variables                                       #
    ###########################################################################
    for row in csvReader:
        # Total number of months
        numOfMonths += 1
         # Average of the changes in "Profit/Losses"
        if numOfMonths > 1:
            changeProfitLosses += int(row[1])- lastValueProfitLooses
        # Net total amount of "Profit/Losses"
        totalProfitLosses = totalProfitLosses + int(row[1])
        # Greatest increase in profits
        if ( int(row[1])- lastValueProfitLooses) > greatIncreaseAmount:
            greatIncreaseAmount = int(row[1])- lastValueProfitLooses
            greatIncreaseDate = row[0]
        # Greatest decrease in losses
        if (int(row[1])- lastValueProfitLooses) < greatDecreaseAmount:
            greatDecreaseAmount = int(row[1])- lastValueProfitLooses
            greatDecreaseDate = row[0]
        lastValueProfitLooses = int(row[1])

###############################################################################
# Calculate average changes                                                   #
###############################################################################
avgChanges = round(float(changeProfitLosses) / float(numOfMonths-1),2)

###############################################################################
# Create printable report                                                     #
###############################################################################
report = "Financial Analysis\n" + "----------------------------\n" + "Total Months: " + str(numOfMonths) + "\nTotal: $" + str(totalProfitLosses) + "\nAverage  Change: $" + str(avgChanges) + "\nGreatest Increase in Profits: " + greatIncreaseDate + "($" + str(greatIncreaseAmount) + ")\nGreatest Decrease in Profits: " + greatDecreaseDate + " ($" + str(greatDecreaseAmount) + ")\n"

###############################################################################
# Print data                                                                  #
###############################################################################
print(report)

###############################################################################
# Export file with results                                                    #
###############################################################################
resultFile = os.path.join(".","resources","resultFile.txt")

with open(resultFile, "w") as dataFile:
    dataFile.write(report)

    