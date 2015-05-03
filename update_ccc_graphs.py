#!/usr/bin/python

# This file is not completely finished
# Presently, it opens "graphlist.txt" and parses it for information about all the data and graphs that will be needed
# Then, it gets the information using parse_from_ccc.sh and prints it

# In the future, this should take a ccc report path from the commandline (the whole file from stdin) and an rrd graph location,
#  then update the rrd graph with all of the relevant information from the ccc report.
# This should be called after the ccc report creation finishes with the path for the newly created report

import sys
from subprocess import Popen, PIPE

outputdir = "output/graphs"

def update_graph(graphpath, (graphname, datatype, datasource, title, vlabel, hlabel)):
    print graphname, datatype, datasource, title, vlabel, hlabel
    if datasource == "x":
          process = Popen(["./parse_from_ccc.sh", graphpath, datatype], stdout=PIPE, stderr=PIPE)
    else:
          process = Popen(["./parse_from_ccc.sh", graphpath, datatype, datasource], stdout=PIPE, stderr=PIPE)
    out, err = process.communicate()
    print out

with open("graphlist.txt", "r") as graphtypes:
    for line in graphtypes:
         cccpath = "output/ccc-2015-02-06-0125.html"
         if line.strip(): update_graph(graphpath, line.split("|"))

