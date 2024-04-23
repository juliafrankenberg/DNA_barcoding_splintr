JFG34: This is the bioinformatic analysis for JFG28 - In vitro SPLINTR barcoding experiment of -/+DOX Emt6.Plk4 cells. Experiment done in December 2023, and analysis in April 2024.

The first step is to generate barcode counts files for each sample, and this is done following the nextflow pipeline BARtab: https://github.com/DaneVass/BARtab?tab=readme-ov-file#performance

The second step is to further process the barcode counts files and get plots to understand the data; this is done based on an R script: https://danevass.github.io/bartools/articles/bartools_quickstart.html

Both analyses steps were developed by the authors of the SPLINTR paper (Dane Vass). 

# Step 1: BARtab pipeline

For more details on the steps of the pipeline: https://github.com/DaneVass/BARtab?tab=readme-ov-file#performance

**NOTE: this analysis is performed on QMUL apocrita; if not using it some things in these steps may need to change (e.g. running scripts). Inspect scripts I wrote before running to check file paths etc.**

## Installing the pipeline and dependencies

This is a nextflow pipeline, which means we need nextflow to run it. In apocrita nextflow exists as a module, so to use it we just need to load the module as usual: 

    module load nextflow

Try out the pipeline. This will automatically pull the pipeline, usually into ~/.nextflow/assets/

    nextflow run danevass/bartab --help

Install dependencies using singularity (Apocrita uses the new name apptainer, calls to singularity are still accepted). **NOTE: this step only needs to be done once - singularity images are saved in our common directory so they should not need to be pulled again.**
    
    export NXF_SINGULARITY_LIBRARYDIR=/data/BCI-GodinhoLab/singularity  

    singularity pull --dir $NXF_SINGULARITY_LIBRARYDIR henriettaholze-bartab-v1.4.img docker://henriettaholze/bartab:v1.4

This will pull the singularity images into the directory above. The cache (blobs from where the images are pulled) directory is automatically saved to ~/.apptainer/cache; but you can symlink it to your scratch (because it's quite heavy?):

    mkdir /data/scratch/hfy179/.apptainer

    cd ~

    ln -s /data/scratch/hfy179/.apptainer

Then, if you run:

    readlink -f ~/.apptainer

it should show:

    /data/scratch/hfy179/.apptainer

## Preparing files for the pipeline

We will need to copy the **reference fasta file** (generating by the sequencing and analysis of the re-transformed barcode libraries, JFG31 and JFG25). I copied it into ./assets, but in future we could keep it in a common lab directory (of assets, e.g. with other ref genomes etc). 

We also need to prepare the fastq files. Download the data from Novogene to a ./data directory. Unzip and check integrity of files: 

    tar -xvf file.tar
    md5sum -c MD5.txt

Then we need to create a symlink so that the **fastq files** can be accessed from one common directory. For our analysis, since the reads are 150bp long we only need the FWD reads (_1) as they will definitely contain the barcodes (60bp). So using the following sricpt to symlink samples: 

    qsub a1_prep_fq_files_single_end.sh

Then check symlink worked: 

    ls -lahd data/indir2 #or whatever name directory you chose


If for any reason we are going to merge FWD and REV sequencing reads, we need to rename the end of the fq files from _1 to _R1 and _2 to _R2, so I wrote a script for this and to symlink (but best to use only fwd read as above): 

    qsub a1_prep_fq_files_pairend.sh

We also need a **params file** , which contains some parameters used for the pipeline. See params.yaml file for what I used here, but check BARtab github for more possible options. E.g. note that I used single-end bulk.

## Run pipeline

Run the BARtab nextflow pipeline: 

    qsub a2_run_pipeline.sh

Check output files in results folder. See Github BARtab page for more information on outputs. 


# Run bartools

This can be run locally (i.e. not on apocrita)

If not done yet, install bartools following instructions on: https://danevass.github.io/bartools/articles/bartools_quickstart.html

I am currently working with the script provided above and optimising it for my samples. 

## Prepare input files

Copy text count files from the results/counts directory output of BARTab into a ./data directory. Will also need a metadata file with sample information. I wrote this one in excel manually. See the one used here as an example. 









