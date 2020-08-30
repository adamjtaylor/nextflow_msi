#!/usr/bin/env nextflow
 
params.imzml =  '/home/adamtaylor/Documents/mouse-brain/SagittalMouseCerebellum.imzML'
params.sap = '/home/adamtaylor/Documents/mouse-brain/mouse-brain-preprocessingWorkflow.sap'
params.outdir = 'processed_data'
params.f_make_datacube = "$workflow.projectDir/make_datacube.m"
params.f_clustering = "$workflow.projectDir/clustering.m"

imzml_channel = Channel.from(params.imzml)


process make_datacube {


 input:
  var imzml from imzml_channel
  val sap from params.sap
  path f_make_datacube from params.f_make_datacube

 output:
    file '${imzml.baseName}.mat' into res1

  """
  git clone -b 'v1.4.0' --single-branch https://github.com/AlanRace/SpectralAnalysis.git
  matlab -nodesktop -nodisplay -r "make_datacube('$imzml', '$sap');exit"
  """
}

process clustering {

 publishDir "$params.outdir"


 input:
  file input_file from res1
  path f_clustering from params.f_clustering
  
  output:
   file '${input_file.baseName}.mat' into res2
  
  """
  matlab -nodesktop -nodisplay -r "clustering('$input_file', 'cosine', 2, 500);exit"
  """

}
