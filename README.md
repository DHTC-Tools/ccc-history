# ccc-history
As-of-yet unfinished tool to graph ccc report information over time using rrdtool

----

`create_historical_graph.sh`: Creates a historical graph from all the ccc reports in the given directory using the given datatype (see `parse_from_ccc.sh` for datatypes). Shows all fundamental rrdtool functions (creating, updating, and outputting graphs).

`deunitize.py`: Takes a unitized (human-readable) byte count (e.g. 100G) and converts it to the raw number of bytes. Used by `parse_from_ccc.sh`

`graphlist.txt`: Holds information about every kind of data type that can be gathered from the ccc history reports. Contains the graph's name, datatype (see `parse_from_ccc.sh`), datasource (for datatypes that require one), graph title, graph vertical label, graph horizontal label. This is parsed by `update_ccc_graphs.py` to get the information that needs to be checked for each report.

`parse_from_ccc.sh`: Takes in a path to a ccc report html file, a datatype, and an optional data source. Outputs the information as found using regex from the ccc report. Data types/methods are the kinds of data that can be extracted from ccc reports (see the usage comment for all of them). These types correspond one-to-one to information on an html ccc report.

`update_ccc_graphs.py`: This script is incomplete. When finished, it should be called after ccc report creation finishes on the newly created report. It would iterate over each line in graphlist.txt and update the relevant graphs for each line based on the new data. Presently, this script only iterates over graphlist.txt and prints all the information it gets from a given report to stdout.
