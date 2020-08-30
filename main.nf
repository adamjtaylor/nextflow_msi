#!/usr/bin/env nextflow
 
params.imzml = '/home/adamtaylor/Documents/mouse-brain/SagittalMouseCerebellum.imzML'
params.sap = '/home/adamtaylor/Documents/mouse-brain/mouse-brain-preprocessingWorkflow.sap'
params.outdir = 'processed_data'
 
process peak_pick {

 publishDir "$params.outdir"

 input:
  path imzml from params.imzml
  path sap from params.sap


 output:
    file '*.mat' into records

  """
  git clone -b 'v1.4.0' --single-branch https://github.com/AlanRace/SpectralAnalysis.git
  wget https://raw.githubusercontent.com/adamjtaylor/nextflow_msi/master/sa_auto.m
  matlab -nodesktop -nodisplay -r "peak_pick('$imzml', '$sap');exit"
  """
}


