#!/usr/bin/env nextflow
 
params.first = 2

 
/*
 * split a fasta file in multiple files
 */
process matlabAdd {
 
    input:
    stdin 'input.first' from params.first
 
    output:
    val 'sum' into records
 
    """
    matlab -nojvm -nodisplay -nosplash
   print(input.first +1)
   exit;
    """
}
 
/*
 * print the channel content
 */
records.subscribe { println it }
