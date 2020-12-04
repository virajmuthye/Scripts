```markdown

# PFAM analysis

This tutorial will take you through the basic steps of identifying and analyzing PFAM domains in proteins. Given a file of sequences, you would be able to identify protein domains, analyze protein domain combinations, and use domain information for functional annotation of proteins. You will also be able to build your own HMM models and search for them in your sequences of interest using HMMer.

## Identifying PFAM domains 

1. Have the FASTA file with sequences of interest ready. For the sake of this tutorial, let's use the file muts.fasta provided in this tutorial. It contains a set of orthologs of mtMutS from octocorals.

2. Download the script pfam_scan.pl from http://ftp.ebi.ac.uk/pub/databases/Pfam/Tools/
This is already installed as a module on ISU CONDO and NOVA and all you need to do is load the module. 

3. Download the PFAM HMMs

Download the latest release from http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/

	wget http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
	wget http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.dat.gz
	wget http://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/active_site.dat.gz

4. Create the binary files for PFAM-A.hmm, like so
	module load hmmer
	hmmpress Pfam-A.hmm

This will create the following files 
Pfam-A.hmm.h3f
Pfam-A.hmm.h3i
Pfam-A.hmm.h3m
Pfam-A.hmm.h3p

5. Save this in a jobscript:  pfam.slurm
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#!/bin/bash

# Copy/paste this job script into a text file and submit with the command:
#    sbatch thefilename

#SBATCH --time=12:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=16   # 16 processor core(s) per node 
#SBATCH --job-name="pfam"
#SBATCH --mail-user=vrmuthye@iastate.edu   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

module purge
module unuse /opt/rit/spack-modules/lmod/linux-rhel7-x86_64/Core
module use /opt/rit/modules
module load pfamscan

pfam_scan.pl -fasta muts.fasta -dir /work/LAS/dlavrov-lab/muts/domain_search -outfile muts.pfam -clan_overlap -e_seq 0.00001

>>>>>>>>>>>>>>>>>>>>>>>>

6. Run the jobscript
sbatch pfam.slurm



The output of this analysis will be result file as such

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
<seq id> <alignment start> <alignment end> <envelope start> <envelope end> <hmm acc> <hmm name> <type> <hmm start> <hmm end> <hmm length> <bit score> <E-value> <significance> <clan>

Corymbophyton_bruuni.mf                255    553    227    553 PF05192.19  MutS_III          Domain     6   191   191     57.6   1.9e-15   1 No_clan  
Corymbophyton_bruuni.mf                610    774    609    791 PF00488.22  MutS_V            Domain     2   168   188    113.7     1e-32   1 CL0023   
Corymbophyton_bruuni.mf                823    865    823    866 PF01844.24  HNH               Family     1    46    47     24.4   2.4e-05   1 CL0263   
Cornularia_pabloi.mf                   327    612    315    613 PF05192.19  MutS_III          Domain     5   190   191     57.1   2.9e-15   1 No_clan  
Cornularia_pabloi.mf                   671    833    669    842 PF00488.22  MutS_V            Domain     3   167   188    114.7   5.2e-33   1 CL0023   
Melithaea_erythraea.mf                 339    627    327    627 PF05192.19  MutS_III          Domain     6   191   191     60.9   1.8e-16   1 No_clan  
>>>>>>>>>>>>>>>>>>>>>>>>

## Analyze protein domain combinations

1. Download the script pfam_to_combination.bash. This file will convert the PFAM result file (the output of the previous step- muts.pfam ) into a file containing domain content for each protein in a .csv format

2. Run the script as follows: ./pfam_to_combination.bash muts.pfam 

The output file will look as such in a file witha .comb extsion (muts.pfam.comb), where the sequence and the combination are seperated by commas, and each domain is separated by semi-colons

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
seq,comb
Acanella_sp.mf,MutS_III;MutS_V
Acanthoaxis_wirtzi.mf,MutS_III;MutS_V
Acanthogorgia_breviflora.mf,HNH;MutS_III;MutS_V
Acrophytum_claviger.mf,MutS_III;MutS_V
Acrossota_amboinensis.mf,MutS_III;MutS_V
Actinoptilum_molle.mf,MutS_III;MutS_V
>>>>>>>>>>>>>>>>>>>>>>>>


3. It will also give you a list of PFAM IDs present in your sequences. This file will have a .dcgo extension (muts.pfam.dcgo). This is useful for identifying function of the proteins in dcGO (Domain Centric Gene Ontology)

Go to  http://supfam.org/SUPERFAMILY/cgi-bin/dcenrichment.cgi
Submit the file as input
Select "PFAM families" as input type in Step 1


## An alternate way to identify protein domains
1. Download curated HMM protein domain models from sources like PFAM. 

Before doing this, I recommend reading the HMMer manual "http://eddylab.org/software/hmmer/Userguide.pdf". Specifically, there's a part in the manual on how you can begin basic analysis without reading the nitty-gritties of HMMer.

For this analysis, we will search proteins for two protein domains - "HNH" and "MutS_III". We download their HMM profile from PFAM.

For this search domain name in PFAM. 
	MutS_III- http://pfam.xfam.org/family/MutS_III
	HNH- http://pfam.xfam.org/family/hnh
Now, download the model from the "Curation and model" page that shows up on the left. 
Once you have downloaded the models, simpley concatanate them into one file as follows: cat MutS_III.hmm HNH.hmm > all.hmm 

### ./identify_domains.bash
This scans the sequences for the two protein domains and outputs a tabular output of results, which we will use later to extract the protein domains. At this point, I have not filtered them on e-value or any other metric. This can easy be changed in the script. 

### ./parse_domain.bash
This extracts results for the specific domain from the result file. 

./parse_domain.bash MutS_III muts.tblout
./parse_domain.bash HNH muts.tblout

The output files are 
MutS_III.pfam
HNH.pfam

### ./extract_domain_sequences.bash
This extracts the sequences for the protein domain.
./extract_domain_sequences.bash MutS_III.pfam
./extract_domain_sequences.bash HNH.pfam
	
```




