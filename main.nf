#!/usr/bin/env nextflow
 
params.in = Channel.fromPath( "/home/adamtaylor/Documents/mouse-brain/*.imzML" ).buffer(size:3)
params.outdir = 'my-results'
 

process sa_auto {

publishDir "$params.outdir"

 input:
val x from params.in


output:
    file '*.mat' into records

    
    """
    git clone -b 'v1.4.0' --single-branch https://github.com/AlanRace/SpectralAnalysis.git
    wget https://raw.githubusercontent.com/adamjtaylor/nextflow_msi/master/sa_auto.m
    wget https://raw.githubusercontent.com/adamjtaylor/nextflow_msi/master/preprocessingWorkflow.sap
     matlab -nodesktop -nodisplay -r "sa_auto('$x');exit"
    """
}
