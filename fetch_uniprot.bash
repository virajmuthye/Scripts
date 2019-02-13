# given a file of Uniprot identifiers, this script will download those sequences from Uniprot
# how to run this
# ./fetch_uniprot.bash <file with Uniprot identifiers> <Outputfile name>

while read p;do 
wget https://www.uniprot.org/uniprot/"$p".fasta
done < $1

cat *.fasta > "$2".pep
rm *.fasta



