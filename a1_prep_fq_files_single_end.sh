#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=8G
#$ -l h_rt=1:0:0
#$ -cwd
#$ -t 1-30
#$ -o output_job/
#$ -e errors_job/


## This is not working perfectly

#If not unzipped yet do this:
#tar -xvf data/X204SC23124766-Z01-F001.tar

# make a list with a list of the paths of the raw data files
mkdir -p assets/lists
find -type f | grep -Ei "*_R1.fq.gz" | cut -c 3- > assets/lists/raw_data_path_R1.txt


#then use this list for the symlink:
LIST=assets/lists/raw_data_path_R1.txt
SAMPLE=$(sed -n "${SGE_TASK_ID}p" $LIST)
INDIR="data/indir2" 

# setup directory if it does not already exist
if [ ! -d $INDIR ]; then
    mkdir $INDIR
fi


# symlink fq files to one common directory
echo "Creating symlink for $SAMPLE in directory $INDIR"
ln -s "$PWD/$SAMPLE" "$INDIR/"

# Check if symlink was created successfully
ls -l "$INDIR/"







