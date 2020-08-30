#!/usr/bin/env nextflow
 
params.imzml = '/home/adamtaylor/Documents/mouse-brain/SagitalMouseCerebellum.imzML'
params.sap = '/home/adamtaylor/Documents/mouse-brain/mouse-brain-preprocessingWorkflow.sap'
params.outdir = 'processed_data'
 
process sa_auto {

 publishDir "$params.outdir"

 input:
  val imzml from params.imzml
  val sap from params.sap


 output:
    file '*.mat' into records

  """
  git clone -b 'v1.4.0' --single-branch https://github.com/AlanRace/SpectralAnalysis.git
  wget https://raw.githubusercontent.com/adamjtaylor/nextflow_msi/master/sa_auto.m
  matlab -nodesktop -nodisplay -r "sa_auto('$imzml', '$sap');exit"
  """
}
