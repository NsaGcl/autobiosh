#!/usr/bin/env bash
# Script by NsaGcl | Fabian Urra Morales
# Generate list.txt, a plain text archive with all folder names
(
rm list.txt
echo "Generating list.txt containing folder names"
for d in ./*;do [[ -d "$d" ]] && echo "${d##./}" >> list.txt; done
echo "list.txt created"
echo
echo "=============="
echo
echo "Runing Auto Phasing"
echo
echo "=============="
echo
mkdir haplotypes
while read folder_name
    do
        echo "${folder_name}"
        echo
    	# copy reference fasta into sequence folder
        cp reference.fasta ${folder_name}/reference.fasta
        cd ${folder_name}
        # BWA work, index -> map to reference -> create sam file 
	source ~/anaconda3/etc/profile.d/conda.sh
        conda activate bwa
        bwa index reference.fasta 
        bwa aln reference.fasta nr_output/extended_1_paired.fq > 1extended_1_paired.sai
        bwa aln reference.fasta nr_output/extended_2_paired.fq > 2extended_2_paired.sai
        bwa sampe reference.fasta 1extended_1_paired.sai 2extended_2_paired.sai nr_output/extended_1_paired.fq nr_output/extended_2_paired.fq > 3bwaout.sam
        # Samtools work, sam to bam -> specify read group to te header -> sort bam file -> index bamfile 
        conda activate samtools
	source ~/anaconda3/etc/profile.d/conda.sh
        samtools view -S -b 3bwaout.sam > 4samtoolsout.bam
        samtools addreplacerg -r ID:S1 -r LB:L1 -r SM:SAMPLE1 -o 5samtoolsout_grouped.bam 4samtoolsout.bam 
        samtools sort 5samtoolsout_grouped.bam -o 6samtoolsout_grouped_sorted.bam
        samtools index 6samtoolsout_grouped_sorted.bam
        # Freebayes work, create first VCF
	source ~/anaconda3/etc/profile.d/conda.sh 
        conda activate freebayes
        freebayes -f reference.fasta -F 0.1 -C 1 --pooled-continuous 6samtoolsout_grouped_sorted.bam > 7freebayes_grouped_sorted.vcf
	# WhatsHap work, get haplotypes
	source ~/anaconda3/etc/profile.d/conda.sh
        conda activate whatshap-tmp
        whatshap polyphase 7freebayes_grouped_sorted.vcf 6samtoolsout_grouped_sorted.bam --ploidy 2 --reference reference.fasta -o 8whatshap.vcf
	# Bcftools work, extract haplotypes into reference
	conda activate bcftools
	bgzip 8whatshap.vcf
	tabix 8whatshap.vcf.gz
	bcftools consensus -H 1 -f reference.fasta 8whatshap.vcf.gz > ${folder_name}-h1.fasta
	bcftools consensus -H 2 -f reference.fasta 8whatshap.vcf.gz > ${folder_name}-h2.fasta
        # Change header to folder name-h1 or folder name-h2
	awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-h1.fasta > ${folder_name}-ha1.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-h2.fasta > ${folder_name}-ha2.fasta
        cd ..
        cp ${folder_name}/${folder_name}-ha1.fasta haplotypes/
        cp ${folder_name}/${folder_name}-ha2.fasta haplotypes/
        echo
        echo "${folder_name} done"
        echo
        echo "=============="
        echo 
    done < list.txt
echo "=============="
echo
echo "Two haplotypes done"
echo
echo "=============="
echo
echo "Running three haplotypes"
echo
echo "=============="
echo 
mkdir haplotypes3
while read folder_name
    do
        echo "${folder_name}"
        echo
        cd ${folder_name}
        # Freebayes work, create first VCF
	source ~/anaconda3/etc/profile.d/conda.sh 
        conda activate freebayes
        freebayes -f reference.fasta -F 0.1 -C 1 --pooled-continuous -p 3 6samtoolsout_grouped_sorted.bam > 7freebayes_ploidy3.vcf
	# WhatsHap work, get haplotypes
	source ~/anaconda3/etc/profile.d/conda.sh
        conda activate whatshap-tmp
        whatshap polyphase 7freebayes_ploidy3.vcf 6samtoolsout_grouped_sorted.bam --ploidy 3 --reference reference.fasta -o 8whatshap_ploidy3.vcf
	# Bcftools work, extract haplotypes into reference
	conda activate bcftools
	bgzip 8whatshap_ploidy3.vcf
	tabix 8whatshap_ploidy3.vcf.gz
	bcftools consensus -H 1 -f reference.fasta 8whatshap_ploidy3.vcf.gz > ${folder_name}-p3-h1.fasta
	bcftools consensus -H 2 -f reference.fasta 8whatshap_ploidy3.vcf.gz > ${folder_name}-p3-h2.fasta
	bcftools consensus -H 3 -f reference.fasta 8whatshap_ploidy3.vcf.gz > ${folder_name}-p3-h3.fasta
        # Change header to folder name
	awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p3-h1.fasta > ${folder_name}-p3-ha1.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p3-h2.fasta > ${folder_name}-p3-ha2.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p3-h3.fasta > ${folder_name}-p3-ha3.fasta
	cd ..
        cp ${folder_name}/${folder_name}-p3-ha1.fasta haplotypes3/
        cp ${folder_name}/${folder_name}-p3-ha2.fasta haplotypes3/
        cp ${folder_name}/${folder_name}-p3-ha3.fasta haplotypes3/
        echo "${folder_name} done"
        echo
        echo "=============="
        echo 
    done < list.txt
echo "=============="
echo
echo "Three haplotypes done"
echo
echo "=============="
echo
echo "Running four haplotypes"
echo
echo "=============="
echo 
mkdir haplotypes4
while read folder_name
    do
        echo "${folder_name}"
        echo
        cd ${folder_name}
        # Freebayes work, create first VCF
	source ~/anaconda3/etc/profile.d/conda.sh 
        conda activate freebayes
        freebayes -f reference.fasta -F 0.1 -C 1 --pooled-continuous -p 4 6samtoolsout_grouped_sorted.bam > 7freebayes_ploidy4.vcf
	# WhatsHap work, get haplotypes
	source ~/anaconda3/etc/profile.d/conda.sh
        conda activate whatshap-tmp
        whatshap polyphase 7freebayes_ploidy4.vcf 6samtoolsout_grouped_sorted.bam --ploidy 4 --reference reference.fasta -o 8whatshap_ploidy4.vcf
	# Bcftools work, extract haplotypes into reference
	conda activate bcftools
	bgzip 8whatshap_ploidy4.vcf
	tabix 8whatshap_ploidy4.vcf.gz
	bcftools consensus -H 1 -f reference.fasta 8whatshap_ploidy4.vcf.gz > ${folder_name}-p4-h1.fasta
	bcftools consensus -H 2 -f reference.fasta 8whatshap_ploidy4.vcf.gz > ${folder_name}-p4-h2.fasta
	bcftools consensus -H 3 -f reference.fasta 8whatshap_ploidy4.vcf.gz > ${folder_name}-p4-h3.fasta
	bcftools consensus -H 4 -f reference.fasta 8whatshap_ploidy4.vcf.gz > ${folder_name}-p4-h4.fasta
        # Change header to folder name
	awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p4-h1.fasta > ${folder_name}-p4-ha1.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p4-h2.fasta > ${folder_name}-p4-ha2.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p4-h3.fasta > ${folder_name}-p4-ha3.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p4-h4.fasta > ${folder_name}-p4-ha4.fasta
	cd ..
        cp ${folder_name}/${folder_name}-p4-ha1.fasta haplotypes4/
        cp ${folder_name}/${folder_name}-p4-ha2.fasta haplotypes4/
        cp ${folder_name}/${folder_name}-p4-ha3.fasta haplotypes4/
        cp ${folder_name}/${folder_name}-p4-ha4.fasta haplotypes4/
        echo "${folder_name} done"
        echo
        echo "=============="
        echo 
    done < list.txt
echo "=============="
echo
echo "Four haplotypes done"
echo
echo "=============="
echo
echo "Running five haplotypes"
echo
echo "=============="
echo 
mkdir haplotypes5
while read folder_name
    do
        echo "${folder_name}"
        echo
        cd ${folder_name}
        # Freebayes work, create first VCF
	source ~/anaconda3/etc/profile.d/conda.sh 
        conda activate freebayes
        freebayes -f reference.fasta -F 0.1 -C 1 --pooled-continuous -p 5 6samtoolsout_grouped_sorted.bam > 7freebayes_ploidy5.vcf
	# WhatsHap work, get haplotypes
	source ~/anaconda3/etc/profile.d/conda.sh
        conda activate whatshap-tmp
        whatshap polyphase 7freebayes_ploidy5.vcf 6samtoolsout_grouped_sorted.bam --ploidy 5 --reference reference.fasta -o 8whatshap_ploidy5.vcf
	# Bcftools work, extract haplotypes into reference
	conda activate bcftools
	bgzip 8whatshap_ploidy5.vcf
	tabix 8whatshap_ploidy5.vcf.gz
	bcftools consensus -H 1 -f reference.fasta 8whatshap_ploidy5.vcf.gz > ${folder_name}-p5-h1.fasta
	bcftools consensus -H 2 -f reference.fasta 8whatshap_ploidy5.vcf.gz > ${folder_name}-p5-h2.fasta
	bcftools consensus -H 3 -f reference.fasta 8whatshap_ploidy5.vcf.gz > ${folder_name}-p5-h3.fasta
	bcftools consensus -H 4 -f reference.fasta 8whatshap_ploidy5.vcf.gz > ${folder_name}-p5-h4.fasta
	bcftools consensus -H 5 -f reference.fasta 8whatshap_ploidy5.vcf.gz > ${folder_name}-p5-h5.fasta
        # Change header to folder name
	awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p5-h1.fasta > ${folder_name}-p5-ha1.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p5-h2.fasta > ${folder_name}-p5-ha2.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p5-h3.fasta > ${folder_name}-p5-ha3.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p5-h4.fasta > ${folder_name}-p5-ha4.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p5-h5.fasta > ${folder_name}-p5-ha5.fasta
        cd ..
        cp ${folder_name}/${folder_name}-p5-ha1.fasta haplotypes5/
        cp ${folder_name}/${folder_name}-p5-ha2.fasta haplotypes5/
        cp ${folder_name}/${folder_name}-p5-ha3.fasta haplotypes5/
        cp ${folder_name}/${folder_name}-p5-ha4.fasta haplotypes5/
        cp ${folder_name}/${folder_name}-p5-ha5.fasta haplotypes5/
        echo "${folder_name} done"
        echo
        echo "=============="
        echo 
    done < list.txt
echo "=============="
echo
echo "Five haplotypes done"
echo
echo "=============="
echo
echo "Running six haplotypes"
echo
echo "=============="
echo 
mkdir haplotypes6
while read folder_name
    do
        echo "${folder_name}"
        echo
        cd ${folder_name}
        # Freebayes work, create first VCF
	source ~/anaconda3/etc/profile.d/conda.sh 
        conda activate freebayes
        freebayes -f reference.fasta -F 0.1 -C 1 --pooled-continuous -p 6 6samtoolsout_grouped_sorted.bam > 7freebayes_ploidy6.vcf
	# WhatsHap work, get haplotypes
	source ~/anaconda3/etc/profile.d/conda.sh
        conda activate whatshap-tmp
        whatshap polyphase 7freebayes_ploidy6.vcf 6samtoolsout_grouped_sorted.bam --ploidy 6 --reference reference.fasta -o 8whatshap_ploidy6.vcf
	# Bcftools work, extract haplotypes into reference
	conda activate bcftools
	bgzip 8whatshap_ploidy6.vcf
	tabix 8whatshap_ploidy6.vcf.gz
	bcftools consensus -H 1 -f reference.fasta 8whatshap_ploidy6.vcf.gz > ${folder_name}-p6-h1.fasta
	bcftools consensus -H 2 -f reference.fasta 8whatshap_ploidy6.vcf.gz > ${folder_name}-p6-h2.fasta
	bcftools consensus -H 3 -f reference.fasta 8whatshap_ploidy6.vcf.gz > ${folder_name}-p6-h3.fasta
	bcftools consensus -H 4 -f reference.fasta 8whatshap_ploidy6.vcf.gz > ${folder_name}-p6-h4.fasta
	bcftools consensus -H 5 -f reference.fasta 8whatshap_ploidy6.vcf.gz > ${folder_name}-p6-h5.fasta
	bcftools consensus -H 6 -f reference.fasta 8whatshap_ploidy6.vcf.gz > ${folder_name}-p6-h6.fasta
        # Change header to folder name
	awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p6-h1.fasta > ${folder_name}-p6-ha1.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p6-h2.fasta > ${folder_name}-p6-ha2.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p6-h3.fasta > ${folder_name}-p6-ha3.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p6-h4.fasta > ${folder_name}-p6-ha4.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p6-h5.fasta > ${folder_name}-p6-ha5.fasta
        awk '/^>/{print ">" substr(FILENAME,1,length(FILENAME)-6); next} 1' *-p6-h6.fasta > ${folder_name}-p6-ha6.fasta
        cd ..
        cp ${folder_name}/${folder_name}-p6-ha1.fasta haplotypes6/
        cp ${folder_name}/${folder_name}-p6-ha2.fasta haplotypes6/
        cp ${folder_name}/${folder_name}-p6-ha3.fasta haplotypes6/
        cp ${folder_name}/${folder_name}-p6-ha4.fasta haplotypes6/
        cp ${folder_name}/${folder_name}-p6-ha5.fasta haplotypes6/
        cp ${folder_name}/${folder_name}-p6-ha6.fasta haplotypes6/
        echo "${folder_name} done"
        echo
        echo "=============="
        echo 
    done < list.txt
echo "=============="
echo
echo "Six haplotypes Done"
echo
echo "=============="
echo 
echo "Check polyphase.log to get info about failed polyphasing"
echo
echo "=============="
) 2<&1 | tee -a polyphase.log
