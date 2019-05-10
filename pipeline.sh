




#!/bin/bash


mkdir working
cd working


############# A: Genome simulation #############
############# A1: Downloading reference genome #############
mkdir reference
cd reference
#downloading genome (chr1) from ftp://ftp.ensemblgenomes.org/pub/plants/release-42/fasta/solanum_tuberosum/dna/

#wget ftp://ftp.ensemblgenomes.org/pub/plants/release-42/fasta/solanum_tuberosum/dna/Solanum_tuberosum.SolTub_3.0.dna.chromosome.1.fa.gz

#gunzip -k Solanum_tuberosum.SolTub_3.0.dna.chromosome.1.fa.gz 
 cp /mnt/LTR_userdata/majid001/msc/working/reference/Solanum_tuberosum.SolTub_3.0.dna.chromosome.1.fa .
head -n  1 Solanum_tuberosum.SolTub_3.0.dna.chromosome.1.fa > ref.fasta 
sed -n  100000,100500p Solanum_tuberosum.SolTub_3.0.dna.chromosome.1.fa >> ref.fasta 

# the letter in fasta file should be capital.
# the 100k first bases contains many Ns, so not good.

#head -n 10 ref.fasta # first 10 rows
#wc -l  ref.fasta # number of rows
#less ref.fasta # type q for exit
samtools faidx ref.fasta
cat ref.fasta.fai 
cd ..

############# A2: simulating haplotypes #############

mkdir haplotypes
python2 ../software/haplotyping_illumina/haplogenerator/haplogenerator.py -f reference/ref.fasta -o haplotypes/solanum -m "{'A':'C','C':'A','G':'T','T':'G'}"  -p 2 -v --model poisson  -s [.001,0,0]
wc -l haplotypes/solanum_varianthaplos.txt




############# B1: Sequencing reads #############
mkdir reads
art_illumina -p -na -i haplotypes/solanum_hap1.fa -l 250 -f 30 -m 300 -s 10 -o reads/reads_hap1_R
art_illumina -p -na -i haplotypes/solanum_hap2.fa -l 250 -f 30 -m 300 -s 10 -o reads/reads_hap2_R

cd reads
wc -l reads_hap1_R1.fq 
cat reads_hap1_R1.fq reads_hap2_R1.fq > R1.fastq
cat reads_hap1_R2.fq reads_hap2_R2.fq > R2.fastq
head -n 10 R1.fastq
cd ..

############# B1:mapping reads to the reference genome #############
cd reference
bowtie2-build  ref.fasta solanum
cd ../reads

bowtie2 -x ../reference/solanum -1 R1.fastq -2 R2.fastq -S aligned_reads.sam -q
#wc -l aligned_reads.sam

samtools view -bS aligned_reads.sam >aligned_reads.bam

samtools sort aligned_reads.bam -o sorted.bam 
samtools index sorted.bam

# use IGV to look at it


############# B2: Calling the variants (SNPs) #############

freebayes -f ../reference/ref.fasta -p 2 sorted.bam > variants.vcf

cat variants.vcf | grep "0/1"   > variants_het.vcf  # grep "snp"
# in future ask Sina for using break.sh! # for higher snp rate
# check the number of called variants and number of introduced snps in haplogenerator's output


############# C: Haplotyping #############

mkdir haplotyping_output
java -Xmx8g -jar ../../software/hapcompass_v0.8.2/hapcompass.jar  --ploidy 2 --bam  sorted.bam --vcf variants_het.vcf -o haplotyping_output/output

wc -l  haplotyping_output/output_MWER_solution.txt


############# D: Comparing #############

#hapcomapre




## some stats
samtools depth  sorted.bam  |  awk '{sum+=$3} END { print "Average of coverage is ",sum/NR}'


