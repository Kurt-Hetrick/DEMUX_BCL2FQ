#!/bin/bash

## Load these just in case
module load sge gcc/7.2.0


## User defined command line arguments
RUN_FOLDER=$1
SAMPLE_SHEET=$2
QUEUE_SELECT=$3
SLOTS=$4

## Hard-coded paths...change if the script or output core path change
SCRIPTS_DIR=/mnt/research/tools/LINUX/DEMUX_BCL2FQ/
NOVASEQ_PATH=/mnt/instrument_files/novaseq/
SUBMIT_STAMP=`date '+%s'`

## Assumes that the output from bcl2fastq is going into a directory called FASTQ within the run folder
## Functio to make the FASTQ and a LOGS directory if they do not exist yet.
MAKE_DIRS_TREE() {
	mkdir -p $NOVASEQ_PATH$RUN_FOLDER/FASTQ \
	$NOVASEQ_PATH$RUN_FOLDER/FASTQ/LOGS/
}

## Function to qsub the job
BCL_2_FASTQ_ALL() {

	JOBNAME_PREFIX="BCL2FQ"
		echo \
		qsub -N $JOBNAME_PREFIX"_"$SUBMIT_STAMP \
		-pe slots $SLOTS \
		-R y \
		-q $QUEUE_SELECT \
		-o $NOVASEQ_PATH$RUN_FOLDER"/FASTQ/LOGS/"$JOBNAME_PREFIX"_"$SUBMIT_STAMP".log" \
		-e $NOVASEQ_PATH$RUN_FOLDER"/FASTQ/LOGS/"$JOBNAME_PREFIX"_"$SUBMIT_STAMP".log" \
		-m e \
		-M cidr_sequencing_notifications@lists.johnshopkins.edu \
		$SCRIPTS_DIR$JOBNAME_PREFIX.sh \
		$RUN_FOLDER $SAMPLE_SHEET

}

## EXECUTION: MAKE DIRS. RUN BCL2FQ reserving all the space
MAKE_DIRS_TREE
BCL_2_FASTQ_ALL

printf "$RUN_FOLDER\nhas finished submitting at\n`date`\nby `whoami`" \
	| mail -s "SUBMITTER.BCL2FQ.sh submitted" \
	-r bcraig2@jhmi.edu \
	cidr_sequencing_notifications@lists.johnshopkins.edu \

## END Script