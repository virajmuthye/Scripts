# To append to all headers of your fasta files:
sed 's/>.*/&mito/' input > output

## To get sequence lengths for all sequences in a fasta file:
```
awk '/^>/ {if (seqlen){print seqlen}; print ;seqlen=0;next; } { seqlen = seqlen +length($0)}END{print seqlen}' \
filename.fasta
```

## Split a multi-FASTA file into individual FASTA files by awk
```
awk '/^>/{s=++d".fa"} {print > s}' multi.fa
```

## Single line fasta file to multi-line fasta of 60 characteres each line
```
awk -v FS= '/^>/{print;next}{for (i=0;i<=NF/60;i++) {for (j=1;j<=60;j++) printf "%s", $(i*60 +j); print ""}}' file
fold -w 60 file
```

## rename FASTA headers using a 2-column lookup table output format: >New|Old lookup table: tab-delimited 2-column text file with Old ID in first column and New ID in second
```
awk 'FNR==NR { a[">"$1]=$2; next } $1 in a { sub(/>/,">"a[$1]"|",$1)}1' lookup.txt seqs.fasta
```

