#!/usr/bin/env nextflow
 
params.first = 2
params.second = 4

 
/*
 * split a fasta file in multiple files
 */
process matlabAdd {
 
    input:
    stdin 'input.first' from params.first
    stdin 'input.second' from params.second
 
    output:
    val 'sum' into records
 
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
