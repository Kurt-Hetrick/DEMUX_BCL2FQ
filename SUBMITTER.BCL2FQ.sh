#!/bin/bash

## Load these just in case
module load sge gcc/7.2.0


## User defined command line arguments
## e.g., /mnt/instrument_files/novaseq/190229_A12345_0001_AHXDDHHD
FULL_PATH_TO_RUN_FOLDER=$1
SAMPLE_SHEET=$2

## Hard-coded paths...change if the script or output core path change
SCRIPTS_DIR=/mnt/research/tools/LINUX/DEMUX_BCL2FQ/
SUBMIT_STAMP=`date '+%s'`

# grab email addy

	SEND_TO=`cat $SCRIPTS_DIR/email_lists.txt`

# grab users full name

	SUBMITTER_ID=`whoami`
	PERSON_NAME=`getent passwd | awk 'BEGIN {FS=":"} $1=="'$SUBMITTER_ID'" {print $5}'`

# generate a list of queues to submit to

    QUEUE_LIST=`qstat -f -s r \
        | egrep -v "^[0-9]|^-|^queue|^ " \
        | cut -d @ -f 1 \
        | sort \
        | uniq \
        | egrep -v "all.q|cgc.q|programmers.q|bina.q|qtest.q|bigmem.q|lemon.q|prod.q|uhoh.q" \
        | datamash collapse 1 \
        | awk '{print $1}'`

## Assumes that the output from bcl2fastq is going into a directory called FASTQ within the run folder
## Function to make the FASTQ and a LOGS directory if they do not exist yet.
	MAKE_DIRS_TREE() {
		mkdir -p $FULL_PATH_TO_RUN_FOLDER/FASTQ \
		$FULL_PATH_TO_RUN_FOLDER/FASTQ/LOGS/
	}

## Function to qsub the job
BCL_2_FASTQ_ALL() {

	JOBNAME_PREFIX="BCL2FQ"
		echo \
		qsub -N $JOBNAME_PREFIX"_"$SUBMIT_STAMP \
		-l excl=true \
		-R y \
		-p -8 \
		-q $QUEUE_LIST \
		-o $FULL_PATH_TO_RUN_FOLDER"/FASTQ/LOGS/"$JOBNAME_PREFIX"_"$SUBMIT_STAMP".log" \
		-e $FULL_PATH_TO_RUN_FOLDER"/FASTQ/LOGS/"$JOBNAME_PREFIX"_"$SUBMIT_STAMP".log" \
		-m e \
		-M $SEND_TO \
		$SCRIPTS_DIR$JOBNAME_PREFIX.sh \
		$FULL_PATH_TO_RUN_FOLDER $SAMPLE_SHEET

}

## EXECUTION: MAKE DIRS. RUN BCL2FQ reserving all the space
MAKE_DIRS_TREE
BCL_2_FASTQ_ALL

printf "$FULL_PATH_TO_RUN_FOLDER\nhas finished submitting at\n`date`\nby `whoami`\n$SAMPLE_SHEET" \
	| mail -s "$PERSON_NAME has submitted SUBMITTER.BCL2FQ.sh" \
	$SEND_TO \

## END Script
