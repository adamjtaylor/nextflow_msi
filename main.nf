#!/usr/bin/env nextflow
 
params.first = 2

 
/*
 * split a fasta file in multiple files
 */
process matlabAdd {
 
    input:
    stdin first from params.first
 
    output:
    val 'sum' into records
 
    """
    matlab -nojvm -nodisplay -nosplash
   disp(['Hello world!. The first parameter is' $first])
   exit;
    """
}
 
/*
 * print the channel content
 */
records.subscribe { println it }
