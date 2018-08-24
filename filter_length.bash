#For a given file, it filters out all sequences below 100 aa in length
for file in *.renamed.fasta;
do

mv $file "$file".temp

awk '$0 ~ ">" {print c; c=0;printf substr($0,2,100) "\t"; } $0 !~ ">" {c+=length($0);} END { print c; }' "$file".temp | awk '$2<100 {print $1}' | sort > "$file".below100.seqlengths

grep ">" "$file".temp | sed 's/>//g' | sort > "$file".all

comm -13 "$file".below100.seqlengths "$file".all > "$file".above100

perl -ne 'if(/^>(\S+)/){$c=$i{$1}}$c?print:chomp;$i{$_}=1 if @ARGV' "$file".above100 "$file".temp > $file

rm "$file".all
rm "$file".temp
rm "$file".below100.seqlengths
rm "$file".above100

done
