# Create a graph for 2014's ccc dark data

# Example rrd commands 
# rrdtool create --start 1417069500 --step 86400 n_orphans.rrd DS:n_orphans:GAUGE:432000:U:U RRA:LAST:0.5:1:30
# rrdtool update n_orphans.rrd 1417415108:16785761
# rrdtool graph n_orphans.png --start 1417069500 --end `date +%s` DEF:n_orphans=n_orphans.rrd:n_orphans:LAST LINE2:n_orphans#FF0000

set -e

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 dir name datatype"
    echo "See parse_from_ccc.sh for datatypes"
    exit
fi

DATATYPE=$3
NAME=$2
PAGEDIR=$1
GRAPHNAME=./output/graphs/$NAME.rrd
PNGNAME=./output/graphs/$NAME.png

TITLE="CCC - $DATATYPE ($NAME)"
VERTLABEL="# of dq2 orphans"
HORIZLABEL=""

# Get the start and end times
oldest=$(ls -t $PAGEDIR/ccc-*html | tail -1)
STARTTIME=`expr $(./parse_from_ccc.sh $oldest time) - 1`
newest=$(ls -t $PAGEDIR/ccc-*html | head -1)
ENDTIME=`expr $(./parse_from_ccc.sh $newest time) + 1`

echo "Start time: $STARTTIME | End time: $ENDTIME"

# Remove the old graph
[ -e $GRAPHNAME ] && rm $GRAPHNAME

# Create the graph
rrdtool create $GRAPHNAME --start $STARTTIME --step 86400 DS:n_orphans:GAUGE:432000:0:U RRA:AVERAGE:.5:1:365

# Update the graph with each page's information
for file in $(ls $PAGEDIR/ccc-*.html)
 do
  time=`./parse_from_ccc.sh $file time`
  echo $file $DATATYPE
  data=`./parse_from_ccc.sh $file $DATATYPE`
	
  [ -z $data ] && data="U" # If there's no data, set it to be unknown 
	
  # Update the graph
  rrdtool update $GRAPHNAME $time:$data
  echo "Updated graph $GRAPHNAME with $data at $time" 
done

# Create the png
rrdtool graph $PNGNAME \
	--start $STARTTIME \
	--end $ENDTIME \
	--title $TITLE \
	--width 500 \
	--height 120 \
	--alt-autoscale-max \
	--vertical-label $VERTLABEL \
	--horizontal-label $HORIZLABEL \
	DEF:n_orphans=$GRAPHNAME:n_orphans:AVERAGE \
	LINE:n_orphans#FF0000
