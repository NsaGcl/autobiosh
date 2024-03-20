#!/usr/bin/env bash
# Script by NsaGcl - Fabian Urra Morales
(
source ~/anaconda3/etc/profile.d/conda.sh
conda activate getorganelle
mkdir incomplete_pt_graphs
mkdir summary
while read folder_name
do
    echo "${folder_name} summary and incomplete plastome graph rescue"
    cd ${folder_name}
    summary_get_organelle_output.py nr_output -o ${folder_name}_nr.csv
    summary_get_organelle_output.py plastome_output -o ${folder_name}_mt.csv
    cd plastome_output
    ~/bandage/Bandage image extended_K105.assembly_graph.fastg ${folder_name}_incomplete_graph.png
    cd ..
    cd ..
    cp ${folder_name}/plastome_output/*_incomplete_graph.png incomplete_pt_graphs/
    cp ${folder_name}/${folder_name}_mt.csv summary/
    cp ${folder_name}/${folder_name}_nr.csv summary/
    echo "${folder_name} summary and incomplete plastome graph rescue DONE"
done < list.txt
echo "Done, review summary.log for extra info"
) 2<&1 | tee -a summary.log