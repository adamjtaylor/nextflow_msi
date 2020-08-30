#!/usr/bin/env nextflow
 
params.imzml = '/home/adamtaylor/Documents/mouse-brain/SagittalMouseCerebellum.imzML'
params.sap = '/home/adamtaylor/Documents/mouse-brain/mouse-brain-preprocessingWorkflow.sap'
params.outdir = 'processed_data'
params.f_make_datacube = 'make_datacube.m'
 
process make_datacube {

 publishDir "$params.outdir"

 input:
  path imzml from params.imzml
  path sap from params.sap
  file make_datacube from params.f_make_datacube


 output:
    file '*.mat' into records

  """
  git clone -b 'v1.4.0' --single-branch https://github.com/AlanRace/SpectralAnalysis.git
  matlab -nodesktop -nodisplay -r "make_datacube('$imzml', '$sap');exit"
  """
}


