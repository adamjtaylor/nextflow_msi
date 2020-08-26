#!/usr/bin/env nextflow
 
params.in = "test"
params.outdir = 'my-results'
 

process sa_auto {

publishDir "$params.outdir"

 input:
val x from params.in


output:
    file '*.mat' into records

    
    """
     matlab -nodesktop -nodisplay -r "addpath(genpath('$HOME/Documents/nextflow_msi')); sa_auto('$x');exit"
    """
}
