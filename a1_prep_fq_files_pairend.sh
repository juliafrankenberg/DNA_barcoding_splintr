#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=8G
#$ -l h_rt=1:0:0
#$ -cwd
#$ -t 1-60
#$ -o output_job/
#$ -e errors_job/


## This is not working perfectly

#If not unzipped yet do this:
#tar -xvf data/X204SC23124766-Z01-F001.tar


#rename files to have R1 and R2, required for the pipeline 
#IMPORTANT: test this before as it plays with the raw data, if it works uncomment the last line
find . -type f -name "*fq.gz" | while read -r file; do
    if [[ $file == *_1.fq.gz ]]; then
        newname="${file/_1.fq.gz/_R1.fq.gz}"
    elif [[ $file == *_2.fq.gz ]]; then
        newname="${file/_2.fq.gz/_R2.fq.gz}"
    else
        continue  # Skip files not matching the pattern
    fi
    echo "Renaming $file to $newname"
    # Uncomment the following line to actually rename the files
     #mv "$file" "$newname"
done

# make a list with a list of the paths of the raw data files
mkdir -p assets/lists
find -type f | grep -Ei "*fq.gz" | cut -c 3- > assets/lists/raw_data_path.txt


#then use this list for the symlink:
LIST=assets/lists/raw_data_path.txt
SAMPLE=$(sed -n "${SGE_TASK_ID}p" $LIST)
INDIR="data/indir" 

# setup directory if it does not already exist
if [ ! -d $INDIR ]; then
    mkdir $INDIR
fi


# symlink fq files to one common directory
echo "Creating symlink for $SAMPLE in directory $INDIR"
ln -s "$PWD/$SAMPLE" "$INDIR/"

# Check if symlink was created successfully
ls -l "$INDIR/"







