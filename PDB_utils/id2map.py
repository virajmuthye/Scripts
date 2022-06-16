import re
import sys

inFile = sys.argv[1]

with open(inFile,"r") as file:
	for ln in file:
		if ln.startswith("DBREF "):
			col1 = ln.split()
			col2 = col1[1] + "_" + col1[2] + "," + col1[6] + "," + col1[7]

			if "CANAL" in col2:
				print(col2)

		elif ln.startswith("DBREF1 "):
			col3 = ln.split()
			col4 = col3[1] + "_" + col3[2] + "," + col3[6] + "," + col3[6]
			col5 = col3[6].split("_")			
			

			if "CANAL" in col4:
				print(col3[1] + "_" + col3[2] + "," + col5[0] + "," + col3[6])


 


 