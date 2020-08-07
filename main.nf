#!/usr/bin/env nextflow
 
params.first = Channel.from(1, 2, 3)

 
/*
 * split a fasta file in multiple files
 */
process matlabAdd {
 
    output:
    val 'sum' into records
   
   """
     matlab -nodesktop -nosplash -r \
    "disp(['Hello world!. The first parameter is' ${params.first}); \
    ${params.first} +1
     exit"
 
    """
}
 
/*
 * print the channel content
 */
records.subscribe { println it }
