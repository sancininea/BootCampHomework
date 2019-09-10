###############################################################################
# Homework                                                                    #
# This script analyzes the votes and calculates each of the following:        #
# - The total number of votes cast                                            #
# - A complete list of candidates who received votes                          #
# - The percentage of votes each candidate won                                #
# - The total number of votes each candidate won                              #
# - The winner of the election based on popular vote                         #
###############################################################################

###############################################################################
# import librarys                                                             #
###############################################################################
import csv
import os

###############################################################################
# Declare variables to store data                                             #
###############################################################################
totalVotes = 0
candidates = []
notInList = True
winner = ""
maxVote = 0

###############################################################################
# Open data source                                                            #
###############################################################################
electionCsv = os.path.join(".","resources","election_data.csv")

###############################################################################
# Open file and gather data                                                   #
###############################################################################
with open(electionCsv, "r", encoding="UTF-8") as csvFile:
    csvReader = csv.reader(csvFile, delimiter=",")
    csvHeader = next(csvReader)
    
    ###########################################################################
    # Read data and calculate variables                                       #
    ###########################################################################
    for row in csvReader:
        # Total votes
        totalVotes += 1
        # Add vote to the candidate
        for cand in candidates:
            if row[2] == cand['candidate']:
                cand['votes'] += 1
                notInList = False
                break
            else:
                notInList = True
        # Add new candidate if not in the list
        if notInList:
            newCandidate = {"candidate": row[2], "votes": 1}
            candidates.append(newCandidate)
            notInList = True

###############################################################################
# Calculate winner                                                            #
###############################################################################
for cand in candidates:
    if cand['votes'] > maxVote:
        winner = cand['candidate']
        maxVote = cand['votes']

###############################################################################
# Create printable report                                                     #
###############################################################################
report = "\nElection Results\n-------------------------\nTotal Votes: " + str(totalVotes) + "\n-------------------------\n"
for cand in candidates:
    report = report + cand['candidate'] + ": " + str(round(cand['votes']/totalVotes*100,3)) + "% (" + str(cand['votes']) + ")\n"
report = report + "-------------------------\nWinner: " + winner + "\n-------------------------\n"

###############################################################################
# Print data                                                                  #
###############################################################################
print(report)

###############################################################################
# Export file with results                                                    #
###############################################################################
resultFile = os.path.join(".","resources","pollResult.txt")

with open(resultFile, "w") as dataFile:
    dataFile.write(report)

    