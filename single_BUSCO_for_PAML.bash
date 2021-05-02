#find single copy BUSCO from all three species
#the output of this script is the input for codeml_selection.bash

cat *_busco |  grep "Complete" | awk '{print $1}' | grep -v "#" | sort | uniq -c | awk '$1 == 3 {print $2}' > present_in_all_three

#loop through each BUSCO and make a pep and nuc file for each BUSCO
while read p;do

	grep -w $p aque_busco | awk '{print $3}' >> "$p"_list_del
	grep -w $p ndig_busco | awk '{print $3}' >> "$p"_list_del
	grep -w $p xtes_busco | awk '{print $3}' >> "$p"_list_del

	perl -ne 'if(/^>(\S+)/){$c=$i{$1}}$c?print:chomp;$i{$_}=1 if @ARGV'	"$p"_list_del allpep.db > "$p".pep
	perl -ne 'if(/^>(\S+)/){$c=$i{$1}}$c?print:chomp;$i{$_}=1 if @ARGV'	"$p"_list_del allnuc.db > "$p".nuc
	sed -i 's/[0-9]//g' "$p".pep
	sed -i 's/[0-9]//g' "$p".nuc

	rm "$p"_list_del
	
done < present_in_all_three

