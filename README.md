# Running AlphaFold on the Della cluster at Princeton University
This repo contains a SLURM job submission script to run AlphaFold on the Della cluster at Princeton University. This script loads the AlphaFold module and then calls the `run_alphafold.sh` wrapper, which in turn executes the `run_alphafold.py` script. These scripts have been kindly written by Matthew Cahn (MOL) and can be found at `/tigress/MOLBIO/local/src/alphafold-<version>/run_alphafold.sh`. He also has SLURM script examples at `example-alphafold-<version>-norelax.cmd`

- **AlphaFold version: 2.3.1**
- **Database date: 2022-12-20**

# Check that you have access to the Della computing cluster and the Della cryo-EM compute nodes
Open a Terminal window on your computer (Mac), wsl window (Windows Subsystem for Linux), or internet browser and go to http://mydella.princeton.edu
- For Terminal or wsl, try to log onto Della: `ssh <netid>@della.princeton.edu`. If there are no errors, you have access to Della
- For MyDella, click on the tabs at the top for 'Clusters' and then 'Della Cluster Shell Access'. If there are no errors, you have access to Della
After connecting to Della, check your group association: `groups <netid>`. If you see 'cryoem', you likely have access to the compute nodes.

# If you don't have access to the Della computing cluster or the Della cryo-EM compute nodes
Email Research Computing: cses@princeton.edu
- Send them your name, netid, sponsor/PI
- Ask for Della access if you don't already have it, and provide your primary group affiliation ('molbio' for MOL/Ploss, 'genomics' for LSI/Adamson)
- If you are in Ploss lab, also ask to be added to the 'ploss' group
- Let them know that you will be using AlphaFold, and ask them to add you to the 'cryoem' group and for access to QOS della-cryoem
```
Dear Research Computing,

I am a <student/postdoc/staff> (<netid>, sonpsor: Alexander Ploss). I will be working with AlphaFold on the Della cluster, so could you please create an account for me on Della, with the primary group 'molbio', additional groups 'ploss' and 'cryoem', and permit me access to the QOS della-cryoem?

Thank you,
<name>
```

# Log onto the Della cluster and create a project directory
1. Log onto Della (`ssh <netid>@della.princeton.edu` for Terminal (Mac) or wsl (Windows Subsystem for Linux) or using http://mydella.princeton.edu
2. Navigate to your personal directory on the scratch volume, typically `cd /scratch/gpfs/<netid>`
3. Create a new project directory with `mkdir <project-directory>; cd <project-directory>`
4. Clone this github repo into the directory with `git clone https://github.com/09aaronl/alphafold_princeton-della/ .`
5. List the contents of your project directory with `ls`. You should see 6 files:
```
alphafold.slurm  EXAMPLE_protein1.fa  EXAMPLE_proteins12.fa  EXAMPLE_proteins.txt  LICENSE  README.md
```

# Set up your proteins to fold
6. **RECOMMENDED**: As a test run, you can use the EXAMPLE files provided. Enter the command `cp EXAMPLE_proteins.txt proteins.txt` and then **SKIP** steps 7 and 8 until the test run completes successfully.

7. Using a text editor like nano or vim, create a text file named `proteins.txt`, containing one file name per line, a comma, and the mode to use. Names can be individual proteins ('monomer' mode) or multiple proteins to co-fold together ('multimer' mode). For example:
```
protein1.fa,monomer
protein2.fa,monomer
proteins12.fa,multimer
...
proteinN.fa,monomer
```

8. For each fold, create a FASTA file matching the file name in `proteins.txt`. EMBOSS has a nice tools for converting text to FASTA format: https://www.ebi.ac.uk/jdispatcher/sfc/emboss_seqret
- A **monomer** (`protein1.fa`) should look like:
```
>protein1
MPRTEINSEQWITHTESTWRAPPINGAFTEREIGHTYCHARACTERSPRTEINSEQWITH
TESTWRAPPINGAFTEREIGHTYCHARACTERSPRTEINSEQWITHTESTWRAPPINGAF
TEREIGHTYCHARACTERS
```

- For **multimers** (`proteins12.fa`), add all FASTA headers and sequences in the same file:
```
>protein1
MPRTEINSEQWITHTESTWRAPPINGAFTEREIGHTYCHARACTERSPRTEINSEQWITH
TESTWRAPPINGAFTEREIGHTYCHARACTERSPRTEINSEQWITHTESTWRAPPINGAF
TEREIGHTYCHARACTERS
>protein2
MSECNDPRTEINSEQFRCFLDINGSECNDPRTEINSEQFRCFLDINGSECNDPRTEINSE
QFRCFLDINGSECNDPRTEINSEQFRCFLDING
```

# Edit the SLURM job submission script
9. Edit the script with a text editor:
- Change the line `#SBATCH --mail-user=<netid>@princeton.edu` to include your netid
- Change the line `#SBATCH --time=06:00:00` to the maximum expected runtime, typically 1 h per 250 residues
    - **This does not need to be edited for the test run with the EXAMPLE files**
- Change the line `#SBATCH --array=1-2` to specify which lines to fold from the `proteins.txt` file, 1-indexed, inclusive
    - **This does not need to be edited for the test run with the EXAMPLE files**
10. Submit the job with `sbatch alphafold.slurm` and you can monitor the job status periodically with `squeue --me`
11. When the job ends due to failure or success, you will receive an email notification, and `squeue --me` should return nothing
12. List the contents of your project directory with `ls`. You should see a new folder for each fold, containing PDB files with your predicted structures!
