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
#SBATCH --time=02:00:00     # typically ~1 h per 250 residues
#SBATCH --array=1-4         # which proteins to run from 'proteins.txt', 1-indexed, inclusive
model='monomer'             # possible values: {monomer, monomer_casp14, monomer_ptm, multimer}


# Script, don't have to modify
module purge
module load alphafold/2.2.4

list_proteins='proteins.txt'

idx=${SLURM_ARRAY_TASK_ID}
protein=$(head -n ${idx} ${list_proteins} | tail -n +${idx})

run_alphafold.sh \
                 -f ${protein}.fa \
                 -o . \
                 -d /scratch/gpfs/DATASETS/alphafold/2021-11-22 \
                 -m ${model} \
                 -t 2021-11-22 \
                 -g \
                 -a 0 \
                 -n 8
