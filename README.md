# Running AlphaFold on the Della cluster at Princeton University
This repo contains a SLURM job submission script to run AlphaFold on the Della cluster at Princeton University. This script loads the AlphaFold module and then calls the `run_alphafold.sh` wrapper, which in turn executes the `run_alphafold.py` script.

- **AlphaFold version: 2.3.1**
- **Database date: 2022-12-20**

# Clone this repo onto the Della file system
```
mkdir <project directory>; cd <project directory>
git clone https://github.com/09aaronl/alphafold_princeton-della/ .
```

# Change email notifications
After downloading `alphafold.slurm`, change the line `#SBATCH --mail-user=<netid>@princeton.edu` to include your netid. The default in the next few lines is to send an email when the SLURM job fails or ends successfully, but you can modify them to receive more or fewer emails, see see https://slurm.schedmd.com/sbatch.html for full list.

# For each AlphaFold job submission
1. Log onto Della (`ssh <netid>@della.princeton.edu`) and `cd` to the working directory from which you want to launch the job.
2. Create a text file named `proteins.txt`, containing one protein name per line.
3. For each protein to fold, create a FASTA file named `<protein>.fa`. 
    - For multimers, add all FASTA headers and sequences in the same file.
4. Create a new copy of the `alphafold.slurm` script. Edit the script to change:
    - The maximum runtime (`#SBATCH --time=02:00:00`), typically 1 h per 250 residues
    - Which proteins to fold (`#SBATCH --array=1-4`) from the `proteins.txt` file, 1-indexed, inclusive
    - Which model to use, typically `model='monomer'` or `model='multimer'`
5. Submit the job with `sbatch alphafold.slurm`
