#!/bin/bash
# Use sed to get the reqested data from the given ccc report

USAGE="Usage: $0 path_to_ccc_html_file method [dataset]\n\
- Where method is any one of: dark, time, darksize, pnfsorphans, pnfsorphansize, pnfsghosts, pnfsdup\n\
- And dataset (where applicable) is any of: MWT2_UC_PHYS-HIGGS, MWT2_UC_LOCALGROUPDISK, MWT2_UC_USERDISK, MWT2_UC_TRIG-DAQ, MWT2_UC_PRODDISK, MWT2_UC_PHYS-TOP, MWT2_UC_PERF-JETS, MWT2_UC_PERF-TAU, MWT2_UC_SCRATCHDISK, MWT2_DATADISK"

if [[ $# -lt 2 ]]; then
 echo -e $USAGE
 exit 1
fi

function dataset { # Takes three arguments, the first being the path to the ccc file, the second being the data wanted (replicas, complete, UNKNOWN, EMPTY, MISSING, DAMAGED, IMCOMPLETE, OK), and the third being the name of the dataset (e.g. MWT2_UC_PHYS-HIGGS)
if [[ $# -ne 3 ]]; then
    echo "Incorrect number of args passed to 'dataset' function"
    exit 1
  fi
  case $2 in
    replicas)
      NREPLICAS=$(sed -n "s/^$3.* \(.*\) replicas,.*$/\1/p" $1)
      echo $NREPLICAS
      ;;
    complete)
      NCOMPLETE=$(sed -n "s/^$3.*, \(.*\) complete.*$/\1/p" $1)
      echo $NCOMPLETE
      ;;
    UNKNOWN|EMPTY|MISSING|DAMAGED|INCOMPLETE|OK)
      # This is really really complicated but what it does it uses the href information
      # To try to find the correct line to get the information from
      NREPLICAS=$(sed -n "s/^.*href=datasets-$3-$2-.*>\(.*\) repli.*$2.*$/\1/p" $1)
      echo $NREPLICAS
      ;;
    *)
      echo "$2 is not a valid data choice for the dataset func"
      exit 1
      ;;
  esac
}

if [[ $# -eq 3 ]]; then # We're doing a dataset
    dataset $1 $2 $3
else
    case "$2" in
	dark) # Number of dq2 orphans
	    NORPHANS=`sed -n 's/^.*>\([0-9]*\) dq2 orphans.*$/\1/p' $1`
	    echo $NORPHANS
	    ;;
	time) # Unix time of the given page (based on the "Started at ..." line at the top")
	    TIME=`sed -n 's/^.*Started at \(.*\)$/\1/p' $1`
	    echo `date --date "$TIME" +%s`
	    ;;
	darksize) # Size of the dark data (in bytes)
	    DARKSIZE=`sed -n 's/^.*dq2 orphans (\(.*\)) (dark data).*$/\1/p' $1`
	    [ -n "$DARKSIZE" ] && echo `./deunitize.py $DARKSIZE`
	    [ -z "$DARKZIZE" ] && echo
	    ;;
	pnfsorphans) # Number of PNFS orphans
	    NORPHANS=`sed -n 's/^.*>\(.*\) PNFS orphans .*$/\1/p' $1`
	    echo $NORPHANS
	    ;;
	pnfsorphansize) # Size of PNFS orphans
	    ORPHANSIZE=`sed -n 's/^.*PNFS orphans (\(.*\))<.*$/\1/p' $1`
	    [ -n "$ORPHANSIZE" ] && echo ` ./deunitize.py $ORPHANSIZE`
	    [ -z "$ORPHANSIZE" ] && echo
	    ;;
	pnfsghosts) # Number of PNFS ghosts
	    PNFSGHOSTS=`sed -n 's/^.*>\(.*\) PNFS ghosts.*$/\1/p' $1`
	    echo $PNFSGHOSTS
	    ;;
	pnfsdup) # Number of PNFS duplicates
	    PNFSDUP=`sed -n 's/^.*>\(.*\) duplicates.*$/\1/p' $1`
	    echo $PNFSDUP
	    ;;
	*)
	    echo "$2 is not a valid method"
	    exit 1
	    ;;
    esac
fi
