#!/usr/bin/env nextflow
 
params.in = "test"
params.outdir = 'my-results'
 

process sa_auto {

publishDir "$params.outdir"

 input:
val x from params.in


output:
    file 'test*' into records

    
    """
     matlab -nodesktop -nodisplay -r "addpath(genpath('$HOME/Documents/nextflow_msi')); dummy('$x');exit"
    """
}

records.subscribe { println "Received: " + it.text }
