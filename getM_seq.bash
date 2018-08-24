#This script takes in a multi-fasta file, with some sequences beginning with M at position 1 and some which do not
#It first removes all sequences which completely lack a M in their sequence
#Then, for every sequence which does not begin with an M, it outputs the subsequence beginning from the first M
#Input will be the multi-fasta file, output will be another file with the same name and an extension ".M"
#Usage : ./getM_seq.bash $file 
#output: "$file".M


grep 'M' -B 1 --no-group-separator $1 | grep ">" | sed 's/>//g' > "$1".Msomewhere.list
perl -ne 'if(/^>(\S+)/){$c=$i{$1}}$c?print:chomp;$i{$_}=1 if @ARGV' "$1".Msomewhere.list $1 > "$1".Msomewhere 

awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < "$1".Msomewhere | sed 'n; d' > seqline
grep ">" "$1".Msomewhere > headerline

while read p;do
	cut -f 2- -d "M" $p >> seqline_M
done < seqline

sed -i 's/^/M/g' seqline_M

cat headerline | sed G > file1
cat seqline_M | sed G > file2
paste -d "\n" file1 file2 > "$1".M.temp
awk 'BEGIN{RS=">";FS="\n"}NR>1{seq="";for (i=2;i<=NF;i++) seq=seq""$i;a[$1]=seq;b[$1]=length(seq)}END{for (i in a) {k=sprintf("%d", (b[i]/80)+1); printf ">%s\n",i;for (j=1;j<=int(k);j++) printf "%s\n", substr(a[i],1+(j-1)*80,80)}}' "$1".M.temp > "$1".M



rm seqline
rm headerline
rm seqline_M
rm file1
rm file2
rm "$1".Msomewhere
rm "$1".Msomewhere.list
rm "$1".M.temp











