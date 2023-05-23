"""
Created on Mon May 22 10:56:13 2023

@author: viraj

This script will take a blast output in format 6 as input and output the top blast hit for each protein

For each protein, the blast results will be 
 first sorted by bit-score
 then sorted by e-value if bit scores are identical


How to use this
 
"""

import pandas as pd
import os

# function to get the first line matching the blastIDS
def find_first_line_matching(file,value):
    with open(file, 'r') as file:
        for line in file:
            if value in line:
                print(line.strip())
                break
    return None
            

# read in the blast result file in outfmt=6
blastresult_df = pd.read_csv('trialblastresult.tab', sep='\t', header=None)

# sort the file based on ID (alphabetical), then bitscore (descending), and then e-value (ascending) and save it
sortedblast_df = (blastresult_df).sort_values([1,11,10], ascending=[True, False, True])
sortedblast_df.to_csv('sorted.tsv', sep="\t", header=None)

# make a list of unique IDs 
ids=blastresult_df[blastresult_df.columns[0].tolist()]
unique_ids=list(set(ids))

# get the top hits for each IDS
for names in unique_ids:
    find_first_line_matching('sorted.tsv',names)
    
# remove the sorted file
os.remove("sorted.tsv")
