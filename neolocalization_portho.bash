#Takes the result file from portho_parse.bash and searches for possible cases of noelocalization. i.e. a case where one protein is localized to the mitochondria and one is not
#It requires a list of all proteins in the analysis which possess a presequence, with one sequence on each line
#Input : Output from portho_parser.bash, Presequence database


grep "$1" everything.proteinortho.OG.clean > "$1".tempOG

wait

awk -F "," '{print $1}' "$1".tempOG | sort | uniq > "$1".tempOG.list

while read p;do

	echo $p >> file1
	grep -w $p "$1".tempOG | wc -l >> file2

	grep -w $p "$1".tempOG | awk -F "," '{print $2}' | sort | uniq | sort > temp.sorted
	comm -12 temp.sorted preseq.sorted | wc -l >> file3
	rm temp.sorted

done < "$1".tempOG.list

paste -d "," file1 file2 file3 > "$1".og.preseq.analysis

rm "$1".tempOG
rm "$1".tempOG.list
rm file1
rm file2
rm file3

awk -F "," '$2>0 && $3>0 && $2=!$3 {print $1,$2,$3}' "$1".og.preseq.analysis > "$1".neo
awk -F "," '$2>0 && $3>0 && $2=!$3 {print $1}'       "$1".og.preseq.analysis > "$1".neo.candidates



 
