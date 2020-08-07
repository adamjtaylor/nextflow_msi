#!/usr/bin/env nextflow
 
params.first = 2

 
/*
 * split a fasta file in multiple files
 */
process matlabAdd {
 
    output:
    val 'sum' into records
   
   """
     matlab -nodesktop -nosplash -r \
    "disp(['Hello world!. The first parameter is' ${params.first}); \
     exit"
 
    """
}
 
/*
 * print the channel content
 */
records.subscribe { println it }
