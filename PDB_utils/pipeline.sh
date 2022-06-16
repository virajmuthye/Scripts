# This script required PDBtools to be downloaded. http://www.bonvinlab.org/pdb-tools/
# This script requires a list of PDB structures for analysis.
# You also need to know the acronym used in Uniprot. i.e. for human, it is "_HUMAN". e.g. "PI16_HUMAN"

# make folders to store results
mkdir good_chains
mkdir bad_chains
mkdir structures

wait

# download pdb structures using the batch download script provided by PDB
for file in *.txt;do
  	./batch_download.sh \
  	-f $file -p 
done
 
wait

# uncompress the PDB files
gzip -d *.gz

wait

# map chains to Uniprot IDs
for file in *.pdb;do
	python id2map.py $file 
done > species_chain.csv

wait

# find chains that map to the organism (good chains)
awk -F, '{print $1}' species_chain.csv | sort | uniq > species_chain.lst

#split pdb structures into chains using PDBtools - change the path to the executables
for file in *.pdb;do
	python /bulk/worm_lab/viraj/mimicry/pfal3d7/pdb-tools-2.0.0-rc1/pdbtools/pdb_splitchain.py $file
done

wait

#move all the "good" chains to one folder
while read p;do
	mv "$p".pdb good_chains/.
done < species_chain.lst

mv *_*pdb bad_chains/.
mv *.pdb structures/.

echo "done"

