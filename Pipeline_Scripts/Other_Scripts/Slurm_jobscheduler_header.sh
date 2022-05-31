# Note: below is a header script for a Slurm linux job scheduler
# (4 threads on 1 node; memory 30GB; time limit of running is 48 hours)
# if there submit multiple very similar jobs, consider using array

#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=30G
#SBATCH --time=48:00:00
#SBATCH --array=0-5
#SBATCH --output=%x-%A-%a.out
