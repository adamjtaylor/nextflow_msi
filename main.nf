#!/usr/bin/env nextflow
 
params.imzml = '/home/adamtaylor/Documents/mouse-brain/SagittalMouseCerebellum.imzML'
params.sap = '/home/adamtaylor/Documents/mouse-brain/mouse-brain-preprocessingWorkflow.sap'
params.outdir = 'processed_data'
params.f_make_datacube = params.opsFile = "$workflow.projectDir/make_datacube.m"
 
process make_datacube {

 publishDir "$params.outdir"

 input:
  val imzml from params.imzml
  val sap from params.sap
  path f_make_datacube from params.f_make_datacube

 output:
    file '*.mat' into records

  """
  git clone -b 'v1.4.0' --single-branch https://github.com/AlanRace/SpectralAnalysis.git
  matlab -nodesktop -nodisplay -r "make_datacube('$imzml', '$sap');exit"
  """
}


