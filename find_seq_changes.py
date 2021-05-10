# this script will take an alignment of sequences
# next, it will compare the character at each position of the alignment to the character in the first sequence
# the output will be changes from all the sequences at each position to the first sequence

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
