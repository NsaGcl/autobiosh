#!/usr/bin/env bash
# Script by NsaGcl | Fabian Urra Morales

rm list.txt
echo "Generating list.txt containing folder names"
for d in ./*;do [[ -d "$d" ]] && echo "${d##./}" >> list.txt; done
echo "list.txt created"
(
while read folder_name
    do
        echo "${folder_name}"
        echo
        cd ${folder_name}
        samtools view -bS minimapoutput.sam > aln.${folder_name}.bam
        samtools sort aln.${folder_name}.bam > aln.${folder_name}.sorted.bam
        echo
        echo "${folder_name} done"
        echo
        cd ..
    done < list.txt
)2<&1 | tee -a ipyrad.log
