#!/usr/bin/env nextflow
 
params.imzml =  '/home/adamtaylor/Documents/mouse-brain/SagittalMouseCerebellum.imzML'
params.sap = '/home/adamtaylor/Documents/mouse-brain/mouse-brain-preprocessingWorkflow.sap'
params.outdir = 'processed_data'
params.f_make_datacube = "$workflow.projectDir/make_datacube.m"
params.f_clustering = "$workflow.projectDir/clustering.m"

imzml_ibd_pair = params.imzml.replaceFirst(/imzML/, "{imzML,ibd}")

pairs = Channel.fromFilePairs(imzml_ibd_pair, flat: true)

process make_datacube {

 input:
  set sample_id, path(ibd), path(imzml) from pairs
  path sap from params.sap
  path f_make_datacube from params.f_make_datacube

 output:
    val(imzml) into rec_imzml
    val(ibd) into rec_ibd
    path '*.mat' into res1

  """
  echo $imzml > file
  echo $ibd > file
  # git clone -b 'v1.4.0' --single-branch https://github.com/AlanRace/SpectralAnalysis.git
  matlab -nodesktop -nodisplay -r "make_datacube('$imzml', '$sap');exit"
  """
}

rec_imzml.view { "imzML: $it" }
rec_ibd.view { "ibd: $it" }

process clustering {

 publishDir "$params.outdir"


 input:
  path input_file from res1
  path f_clustering from params.f_clustering
  
  output:
   path '*_nf.mat' into res2
  
  """
  matlab -nodesktop -nodisplay -r "clustering('$input_file', 'cosine', 2, 500);exit"
  """

}
