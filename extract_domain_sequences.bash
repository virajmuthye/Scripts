# input files required
# file with fasta sequences : in afile named "alldb.fasta"
# file with pfam results
# how to run this script
# ./extract_domain_sequences.bash <input pfam result file>

IFS=$'\n'       # make newlines the only separator
set -f          # disable globbing

for i in $(cat < "$1"); do
 
	echo $i > temp1
	start=$(awk '{print $2}' temp1)
	domstart=$(($start - 1))
	end=$(awk '{print $3}' temp1)
	domlength=$(($end - $domstart))
	
      name=$(awk '{print $7}' temp1)

	seq=$(awk '{print $1}' temp1)

	echo $seq > temp2
	
	perl -ne 'if(/^>(\S+)/){$c=$i{$1}}$c?print:chomp;$i{$_}=1 if @ARGV' temp2 alldb.fasta > temp.pep

	str=$(cat temp.pep | awk '/^>/{if(N>0) printf("\n"); ++N; printf("%s\t",$0);next;} {printf("%s",$0);}END{printf("\n");}' | awk '{print $2}')
	
	echo ">""$name""_""$seq" >> "$name".fasta
	echo "${str:$domstart:$domlength}"  >> "$name".fasta 

	rm temp1
	rm temp2
	rm temp.pep

done


