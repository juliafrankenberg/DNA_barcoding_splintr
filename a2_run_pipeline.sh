#!/bin/bash
#$ -pe smp 6
#$ -l h_vmem=8G
#$ -l h_rt=2:0:0
#$ -cwd
#$ -o output_job/
#$ -e errors_job/

module load nextflow
export NXF_SINGULARITY_LIBRARYDIR=/data/BCI-GodinhoLab/singularity #not sure if this is needed here
export NXF_SINGULARITY_CACHEDIR=/data/scratch/hfy179/.apptainer/cache

OUTDIR=results

# setup output directory if it does not already exist
if [ ! -d $OUTDIR ]; then
    mkdir $OUTDIR
fi

nextflow run danevass/bartab \
    -profile singularity \
    -params-file assets/params.yaml \
    -w . 