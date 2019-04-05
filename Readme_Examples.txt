
# NOTES:
Use of this submission code assumes that you are reserving all slots for the choosen servers in a queue.
uses bcl2fastq version 2.20.0.422


# 4 COMMAND LINE ARGUMENTS EXPECTED:
The run folder name (e.g., 190114_A00527_0033_BH3WNYDRXX)
The full path to the sample sheet
A queue to use (e.g., c6420.q or rhel7.q...
The max number of slots assigned to the machines in the queue

# Below are examples with real queues and their max slots as of 4/5/2019 1345
/mnt/research/tools/LINUX/DEMUX_BCL2FQ/SUBMITTER.BCL2FQ.sh RUN_FOLDER_NAM /PATH/TO/SampleSheetName.csv c6420.q 21
/mnt/research/tools/LINUX/DEMUX_BCL2FQ/SUBMITTER.BCL2FQ.sh RUN_FOLDER_NAM /PATH/TO/SampleSheetName.csv rhel7.q 10
/mnt/research/tools/LINUX/DEMUX_BCL2FQ/SUBMITTER.BCL2FQ.sh RUN_FOLDER_NAM /PATH/TO/SampleSheetName.csv prod.q 5

# Executing the above as written will output the constructed qsub command to the screen.
# To execute pipe to bash
/mnt/research/tools/LINUX/DEMUX_BCL2FQ/SUBMITTER.BCL2FQ.sh RUN_FOLDER_NAM /PATH/TO/SampleSheetName.csv c6420.q 21 | bash