#BUSCO does not provide mapping of BUSCO ID and Uniprot ID
#This script loops through a list of BUSCO ids and then gets the uniport ID from OrthoDB using the OrthoDB API
#filename is a list of BUSCO ids with one on each line
# USAGE #
#python download_and_process.py input_file.txt
#

import os
import sys
import requests

def download_and_process(input_file):
    # Open the input file
    with open(input_file, 'r') as file:
        lines = file.readlines()

    # Download files and save them as .tab files
    for line in lines:
        p = line.strip()  # Remove any extra whitespace/newlines
        url = f"https://www.orthodb.org/tab?id={p}&species=9606"
        response = requests.get(url)
        
        # Write the content to a file
        with open(f"{p}.tab", 'wb') as tab_file:
            tab_file.write(response.content)
    
    # Process the downloaded .tab files
    uniprot_ids = []
    for tab_file in os.listdir('.'):
        if tab_file.endswith('.tab'):
            with open(tab_file, 'r') as file:
                for line in file:
                    columns = line.strip().split('\t')
                    if len(columns) >= 7:
                        uniprot_ids.append(columns[6])  # 7th column (index 6)

    # Filter out the header and save uniprot_ids to a file
    with open(f"{input_file}_uniprot_ids", 'w') as output_file:
        for uniprot_id in uniprot_ids:
            if uniprot_id != "pub_gene_id":  # Remove the header value
                output_file.write(f"{uniprot_id}\n")

    # Remove .tab files
    for tab_file in os.listdir('.'):
        if tab_file.endswith('.tab'):
            os.remove(tab_file)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <input_file>")
    else:
        input_file = sys.argv[1]
        download_and_process(input_file)




