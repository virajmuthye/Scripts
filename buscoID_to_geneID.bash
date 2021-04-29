#loops through a list of BUSCO ids and then gets the uniport ID from OrthoDB using the OrthoDB API


while read p;do
	wget "https://www.orthodb.org/tab?id=$p&species=9606" -O "$p".tab
done < $1
cat *.tab | awk -F "\t" '{print $7}' | grep -v "pub_gene_id" > "$1"_uniprot_ids
rm *.tab





