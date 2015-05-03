#!/usr/bin/env python

# Take a unitized byte argument (e.g. 100G, 12M, etc) and return the number of bytes
def deunitize(x):
    suff = "BKMGTPEZY"
    index = suff.find(x[-1]) # Index of suffix
    num = x[:-1] # Number without suffix
    if(index == -1): # Suffix not found, so just return the number
        # This is a bit weird because if the suffix isn't found it might
        #  just not be in our list, or it didn't have one at all
        # But let's just hope for the best
        return int(x)
    return int(1000 ** index * float(num)) 

import sys

if len(sys.argv) > 1:
    for x in sys.argv[1:]:
        print deunitize(x)
else:
    while True:
        l = sys.stdin.readline()
        if not l:
            break
        for t in l.split():
            try:
                print deunitize(t)
            except:
                print t
        print
