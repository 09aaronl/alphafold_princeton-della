#!/bin/bash

# Default settings, don't have to modify
#SBATCH --job-name=aFold
#SBATCH --output=%x.%a.%j.stdout
#SBATCH --partition=cryoem
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --ntasks-per-socket=8
#SBATCH --gres=gpu:1
#SBATCH --mem=64G

# Receive emails, MODIFY WITH YOUR NETID
#SBATCH --mail-user=<netid>@princeton.edu
#SBATCH --mail-type=FAIL    # possible values: {NONE, BEGIN, END, FAIL, ALL... see https://slurm.schedmd.com/sbatch.html for full list}
#SBATCH --mail-type=END

# MODIFY THESE SETTINGS EACH TIME
#SBATCH --time=06:00:00     # typically ~1 h per 250 residues
#SBATCH --array=1-2         # which proteins to run from 'proteins.txt', 1-indexed, inclusive


# Script, don't have to modify
version='2.3.1'
database='2022-12-20'
module purge
module load alphafold/${version}

list_proteins='proteins.txt'

idx=${SLURM_ARRAY_TASK_ID}
line=$(head -n ${idx} ${list_proteins} | tail -n +${idx})
protein=$(echo $line | awk -F ',' '{print $1}')
model=$(echo $line | awk -F ',' '{print $2}')

echo "Initializing AlphaFold"
echo "Version: ${version}"
echo "Database: ${database}"
echo

if [[ -s ${protein} ]]
then
    echo "Protein(s): ${protein}"
    echo
    run_alphafold.sh \
        -f ${protein} \
        -o . \
        -d /scratch/gpfs/DATASETS/alphafold/${database} \
        -m ${model} \
        -t ${database} \
        -g true \
        -a 0 \
        -n 8 \
        -j 5
else
    echo "ERROR: ${protein} not found"
    echo
fi
