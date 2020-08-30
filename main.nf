#!/usr/bin/env nextflow
 
params.imzml =  '/home/adamtaylor/Documents/mouse-brain/SagittalMouseCerebellum.imzML'
params.sap = '/home/adamtaylor/Documents/mouse-brain/mouse-brain-preprocessingWorkflow.sap'
params.outdir = 'processed_data'
params.f_make_datacube = "$workflow.projectDir/make_datacube.m"
params.f_clustering = "$workflow.projectDir/clustering.m"

imzml_ibd_pair = params.imzml.replaceFirst(/imzml/, "{imzml,ibd}")

imzml_ch = Channel.fromFilePairs(imzml_ibd_pair)

process make_datacube {


 input:
  set sampleId, file(imzml) from imzml_ch
  val sap from params.sap
  path f_make_datacube from params.f_make_datacube

 output:
    file '${sampleId}.mat' into res1

  """
  git clone -b 'v1.4.0' --single-branch https://github.com/AlanRace/SpectralAnalysis.git
  matlab -nodesktop -nodisplay -r "make_datacube('${sampleId}.imzML', '$sap');exit"
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
