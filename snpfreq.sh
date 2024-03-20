#!/usr/bin/env bash
# Script by NsaGcl | Fabian Urra Morales
(
source ~/anaconda3/etc/profile.d/conda.sh
conda activate samtools
echo Running
samtools view -q 10 -bS Barcode84_Mapped.sorted.sam > Barcode84_Mapped.sorted.q10.sam
samtools view -q 20 -bS Barcode85_Mapped.sorted.sam > Barcode85_Mapped.sorted.q20.sam
samtools view -q 10 -bS Barcode85_Mapped.sorted.sam > Barcode85_Mapped.sorted.q10.sam
echo Running
samtools view -q 5 -bS Barcode85_Mapped.sorted.sam > Barcode85_Mapped.sorted.q5.sam
samtools view -q 1 -bS Barcode85_Mapped.sorted.sam > Barcode85_Mapped.sorted.q1.sam
samtools view -q 20 -bS Barcode86_Mapped.sorted.sam > Barcode86_Mapped.sorted.q20.sam
echo Running
samtools view -q 10 -bS Barcode86_Mapped.sorted.sam > Barcode86_Mapped.sorted.q10.sam
samtools view -q 5 -bS Barcode86_Mapped.sorted.sam > Barcode86_Mapped.sorted.q5.sam
samtools view -q 1 -bS Barcode86_Mapped.sorted.sam > Barcode86_Mapped.sorted.q1.sam
echo Running
samtools view -q 20 -bS Barcode87_Mapped.sorted.sam > Barcode87_Mapped.sorted.q20.sam
samtools view -q 10 -bS Barcode87_Mapped.sorted.sam > Barcode87_Mapped.sorted.q10.sam
samtools view -q 5 -bS Barcode87_Mapped.sorted.sam > Barcode87_Mapped.sorted.q5.sam
samtools view -q 1 -bS Barcode87_Mapped.sorted.sam > Barcode87_Mapped.sorted.q1.sam
samtools view -Sb Barcode85_Mapped.sorted.q20.sam > Barcode85_Mapped.sorted.q20.bam
echo Running
samtools view -Sb Barcode85_Mapped.sorted.q10.sam > Barcode85_Mapped.sorted.q10.bam
samtools view -Sb Barcode85_Mapped.sorted.q5.sam > Barcode85_Mapped.sorted.q5.bam
samtools view -Sb Barcode85_Mapped.sorted.q1.sam > Barcode85_Mapped.sorted.q1.bam
echo Running
samtools view -Sb Barcode86_Mapped.sorted.q20.sam > Barcode86_Mapped.sorted.q20.bam
samtools view -Sb Barcode86_Mapped.sorted.q10.sam > Barcode86_Mapped.sorted.q10.bam
echo Running
samtools view -Sb Barcode86_Mapped.sorted.q5.sam > Barcode86_Mapped.sorted.q5.bam
samtools view -Sb Barcode86_Mapped.sorted.q1.sam > Barcode86_Mapped.sorted.q1.bam
samtools view -Sb Barcode87_Mapped.sorted.q20.sam > Barcode87_Mapped.sorted.q20.bam
echo Running
samtools view -Sb Barcode87_Mapped.sorted.q10.sam > Barcode87_Mapped.sorted.q10.bam
samtools view -Sb Barcode87_Mapped.sorted.q5.sam > Barcode87_Mapped.sorted.q5.bam
echo Running
samtools view -Sb Barcode87_Mapped.sorted.q1.sam > Barcode87_Mapped.sorted.q1.bam
samtools mpileup -B Barcode84_Mapped.sorted.q20.sam Barcode85_Mapped.sorted.q20.sam Barcode86_Mapped.sorted.q20.sam Barcode87_Mapped.sorted.q20.sam > q20.mpileup
samtools mpileup -B Barcode84_Mapped.sorted.q10.sam Barcode85_Mapped.sorted.q10.sam Barcode86_Mapped.sorted.q10.sam Barcode87_Mapped.sorted.q10.sam > q10.mpileup
echo Running
samtools mpileup -B Barcode84_Mapped.sorted.q5.sam Barcode85_Mapped.sorted.q5.sam Barcode86_Mapped.sorted.q5.sam Barcode87_Mapped.sorted.q5.sam > q5.mpileup
samtools mpileup -B Barcode84_Mapped.sorted.q1.sam Barcode85_Mapped.sorted.q1.sam Barcode86_Mapped.sorted.q1.sam Barcode87_Mapped.sorted.q1.sam > q1.mpileup
perl ~/popoolation2/mpileup2sync.pl --fastq-type sanger --min-qual 20 --input q20.mpileup --output q20.sync
perl ~/popoolation2/mpileup2sync.pl --fastq-type sanger --min-qual 10 --input q10.mpileup --output q10.sync
echo Running
perl ~/popoolation2/mpileup2sync.pl --fastq-type sanger --min-qual 5 --input q5.mpileup --output q5.sync
perl ~/popoolation2/mpileup2sync.pl --fastq-type sanger --min-qual 1 --input q1.mpileup --output q1.sync
perl ~/popoolation2/snp-frequency-diff.pl --input q20.sync --output-prefix q20 --min-count 6 --min-coverage 50 --max-coverage 200
perl ~/popoolation2/snp-frequency-diff.pl --input q10.sync --output-prefix q10 --min-count 6 --min-coverage 50 --max-coverage 200
echo Running
perl ~/popoolation2/snp-frequency-diff.pl --input q5.sync --output-prefix q5 --min-count 6 --min-coverage 50 --max-coverage 200
perl ~/popoolation2/snp-frequency-diff.pl --input q1.sync --output-prefix q1 --min-count 6 --min-coverage 50 --max-coverage 200
) 2<&1 | tee -a poolseq.log
