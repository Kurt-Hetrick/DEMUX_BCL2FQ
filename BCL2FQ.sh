# ---qsub parameter settings---
# --these can be overrode at qsub invocation--

# tell sge to execute in bash
#$ -S /bin/bash

# tell sge that you are in the users current working directory
#$ -cwd

# tell sge to export the users environment variables
#$ -V

# tell sge to submit at this priority setting
#$ -p -10

# tell sge to output both stderr and stdout to the same file
#$ -j y

# export all variables, useful to find out what compute node the program was executed on


module load sge/2011.11p1 bcl2fastq/2.20.0.422

set

echo

## Standard path for the novaseq data files
NOVASEQ_PATH=/mnt/instrument_files/novaseq/

## Just the run folder name e.g., 190114_A00527_0033_BH3WNYDRXX
RUN_FOLDER=$1

## Full path to the sample sheet. Allows to define alternate sample sheet locations.
SAMPLE_SHEET=$2

## Find the total CPU count for the machine
NUM_PROC="$(echo nproc | bash)"

## Calculate 5 less CPU. This assumes that you have reserved the whole machine (all slots)
THREADS="$(expr $NUM_PROC - 5)"

## Run bcl2fastq command line args for constructed run folder path, location of sample sheet
## and calculated threads for processing. Read and writes are set to 10 each since these are simple.
## Also user guide suggests keeping these lower to avoid issues with I/O performance.

bcl2fastq --runfolder-dir $NOVASEQ_PATH$RUN_FOLDER \
--output-dir $NOVASEQ_PATH$RUN_FOLDER"/FASTQ" \
--sample-sheet=$SAMPLE_SHEET \
--loading-threads 10 \
--processing-threads $THREADS \
--writing-threads 10 \
