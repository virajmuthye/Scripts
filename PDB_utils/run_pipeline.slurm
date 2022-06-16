#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=100GB
#SBATCH --time=24:00:00
#SBATCH --partition=synergy

####### Set environment variables ###############

####### Run your script #########################

./pipeline.sh



