#!/usr/bin/env nextflow
 
params.first = 2
params.second = 4

 
/*
 * split a fasta file in multiple files
 */
process matlabAdd {
 
    input:
    'input.first' from params.first
    'input.second' from params.second
 
    output:
    'sum' into records
 
    """
    matlab -nojvm -nodisplay -nosplash
   print(input.first + input.second)
   exit;
    """
}
 
/*
 * print the channel content
 */
records.subscribe { println it }
