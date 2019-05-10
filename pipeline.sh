#!/bin/bash



# You need samtools, 



#A: Genome simulation

#downloading genome (chr1) from ftp://ftp.ensemblgenomes.org/pub/plants/release-42/fasta/solanum_tuberosum/dna/

wget ftp://ftp.ensemblgenomes.org/pub/plants/release-42/fasta/solanum_tuberosum/dna/Solanum_tuberosum.SolTub_3.0.dna.chromosome.1.fa.gz

gunzip -k Solanum_tuberosum.SolTub_3.0.dna.chromosome.1.fa.gz 

head -n  501 Solanum_tuberosum.SolTub_3.0.dna.chromosome.1.fa > ref.fasta 

head -n 10 ref.fasta # first 10 rows
wc -l  ref.fasta # number of rows
less ref.fasta # type q for exit
samtools faidx ref.fasta
cat ref.fasta.fai 



python2 /haplogenerator/haplogenerator.py -f ref/ref.fasta -o haplogen/sim -m "{'A':'C','C':'A','G':'T','T':'G'}"  -p 3 -v --model poisson -s [.01,0,0] 
