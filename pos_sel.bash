module load paml

# need protein and CDS sequences in one folder

while read p;do

	# protein alignment using mafft
	mafft --auto "$p".pep > "$p".aln
	
	wait
	
	# codon alignment using pal2nal
	/work/LAS/dlavrov-lab/muts/nuc_composition/coevol/all/pal2nal.v14/pal2nal.pl "$p".aln "$p".nuc -codontable 4 -output fasta -nomismatch > "$p".codon.aln
	
	wait
	
	#convert to phylip
	perl catfasta2phyml.pl -c "$p".codon.aln -s > seq.phy
	
	#run null model
	mv codeml.ctl_null codeml.ctl
	codeml
	
	wait

	mv codeml.ctl codeml.ctl_null
	grep "lnL" nullmodel | awk -F "):" '{print $2}' | awk '{print $1}' >> null_file
	


	#looking at omega values
	#for species1
	grep "4\.\.1" nullmodel | tail -1 | awk '{print $5}' >> species1_omega_null
	#for species2
	grep "4\.\.2" nullmodel | tail -1 | awk '{print $5}' >> species2_omega_null
	#for species3
	grep "4\.\.3" nullmodel | tail -1 | awk '{print $5}' >> species3_omega_null


	#run test model
	mv codeml.ctl_test codeml.ctl
	codeml
	
	wait

	mv codeml.ctl codeml.ctl_test
	grep "lnL" testmodel2 | awk -F "):" '{print $2}' | awk '{print $1}' >> test_file
	
	#looking at omega values
	#for species1
	grep "4\.\.1" testmodel2 | tail -1 | awk '{print $5}' >> species1_omega_test
	#for species2
	grep "4\.\.2" testmodel2 | tail -1 | awk '{print $5}' >> species2_omega_test
	#for species3
	grep "4\.\.3" testmodel2 | tail -1 | awk '{print $5}' >> species3_omega_test
	
	
done < gene

	paste -d, null_file test_file species1_omega_null species2_omega_null species3_omega_null species1_omega_test species2_omega_test species3_omega_test > LRT.csv


rm null_file
rm test_file
rm species1_omega_null
rm species2_omega_null
rm species3_omega_null
rm species1_omega_test
rm species2_omega_test
rm species3_omega_test
rm nullmodel
rm testmodel2
rm rub
rm rst1
rm rst
rm lnf
rm 4fold.nuc
rm 2NG.t
rm 2NG.dS
rm 2NG.dN
rm seq.phy
rm *.aln




