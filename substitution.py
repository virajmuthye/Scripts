# running the script
# python substitution.py input.fasta.alignment
# will find changes in all sequences in an alignment file compared to the first sequence
# Columns: (i) sequence identifier, (ii) position in the alignment, (iii) character in this sequence, (iv) character in the reference sequence.
# https://www.biostars.org/p/302162/

import sys
from Bio import SeqIO

f = sys.argv[1]

seq_records = SeqIO.parse(f, 'fasta')
refseq_record = next(seq_records)

for seq_record in seq_records:
    for i in range(0, len(refseq_record)):
        nt1 = refseq_record[i]
        nt2 = seq_record[i]
        if nt1 != nt2:
            printseq_record.id, i+1, nt2, nt1)
