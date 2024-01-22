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
echo "Runing Auto Plastome Assembly | GetOrganelle"
# Ask user if they want to assembly cpDNA, Nuclear Ribosomal Cistron or both
echo "What do you want to assemble?"
echo "1: Chloroplast"
echo "2: Nuclear Ribosomal Cistron"
echo "3: Chloroplast & Nuclear Ribosomal Cistron"
echo
read -p 'Insert number (default is 3): ' assemblyopt
echo
echo "=============="
echo
if [[ -z "$assemblyopt" ]]; then
	assemblyopt=3
fi
source ~/anaconda3/etc/profile.d/conda.sh
conda activate getorganelle
if [ $assemblyopt == 1 ]
then
	echo "Assemblying Chloroplast"
        while read folder_name
        do
                echo
                echo "=============="
                echo
                echo "Assemblying ${folder_name} Chloroplast"
                cd ${folder_name}
		fq1reads=($(zgrep -c '^@.*/[0-9]$' *_1.fq.gz))
                fq2reads=($(zgrep -c '^@.*/[0-9]$' *_2.fq.gz))
                fqreads=$((fq1reads + fq2reads))
                echo "${folder_name} contains ${fqreads} reads to use"
		get_organelle_from_reads.py -1 *_1.fq.gz -2 *_2.fq.gz -o plastome_output -R 20 -k 21,45,65,85,105 -F embplant_pt -t 16
                cd ..
                echo
                echo "=============="
                echo
                echo "${folder_name} assembly finished"
        done < list.txt
        elif [ $assemblyopt == 2 ]
        then
                echo "Assemblying Nuclear Ribosomal Cistron"
                while read folder_name
                do
                        echo
                        echo "=============="
                        echo
                        echo "Assemblying ${folder_name} Nuclear Ribosomal Cistron"
                        cd ${folder_name}
	        	fq1reads=($(zgrep -c '^@.*/[0-9]$' *_1.fq.gz))
		        fq2reads=($(zgrep -c '^@.*/[0-9]$' *_2.fq.gz))
        		fqreads=$((fq1reads + fq2reads))
	        	echo "${folder_name} contains ${fqreads} reads to use"
		        echo "using all reads"
                        get_organelle_from_reads.py -1 *_1.fq.gz -2 *_2.fq.gz -o nr_output -R 15 -k 35,85,115 -F embplant_nr -t 16 --reduce-reads-for-coverage inf --max-reads inf
                        cd ..
                        echo
                        echo "=============="
                        echo
                        echo "${folder_name} assembly finished"
                done < list.txt
                elif [ $assemblyopt == 3 ]
                then
                        echo "Assemblying Chloroplast & Nuclear Ribosomal Cistron"
                        while read folder_name
                        do
                                echo
                                echo "=============="
                                echo
                                cd ${folder_name}
	                	fq1reads=($(zgrep -c '^@.*/[0-9]$' *_1.fq.gz))
        		        fq2reads=($(zgrep -c '^@.*/[0-9]$' *_2.fq.gz))
                		fqreads=$((fq1reads + fq2reads))
	                	echo "${folder_name} contains ${fqreads} reads to use"
        		        echo "using all reads"
                                echo
                                echo "=============="
                                echo 
                                echo "Assemblying ${folder_name} Nuclear Ribosomal Cistron"
                                echo 
                                echo "=============="
                                get_organelle_from_reads.py -1 *_1.fq.gz -2 *_2.fq.gz -o nr_output -R 15 -k 35,85,115 -F embplant_nr -t 16 --reduce-reads-for-coverage inf --max-reads inf
                                echo "=============="
                                echo 
                                echo "Assemblying ${folder_name} Chloroplast"
                                echo 
                                echo "=============="
                                get_organelle_from_reads.py -1 *_1.fq.gz -2 *_2.fq.gz -o plastome_output -R 20 -k 21,45,65,85,105 -F embplant_pt -t 16
                                cd ..
                                echo
                                echo "=============="
                                echo
                                echo "${folder_name} assembly finished"
                                echo 
                                echo "=============="
                        done < list.txt
                elif [ $assemblyopt == 3 || $assemblyopt == 2 || $assemblyopt == 1 ]
                        echo ==============
                        echo
                        echo "Invalid option, execute script again"
                        echo 
                        echo ==============
                then
                        echo "done"
                fi
                        echo "done"
                        echo "opt: $assemblyopt"
) 2<&1 | tee -a assembly.log
