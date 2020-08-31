#!/usr/bin/env nextflow
 
params.imzml =  '/home/adamtaylor/Documents/mouse-brain/SagittalMouseCerebellum.imzML'
//params.sap = '/home/adamtaylor/Documents/mouse-brain/mouse-brain-preprocessingWorkflow.sap'
//params.outdir = 'processed_data'
//params.f_make_datacube = "$workflow.projectDir/make_datacube.m"
//params.f_clustering = "$workflow.projectDir/clustering.m"

imzml_ibd_pair = params.imzml.replaceFirst(/imzML/, "{imzML,ibd}")

pairs = Channel.fromFilePairs(imzml_ibd_pair, flat: true)

process make_datacube {

 input:
  set sample_id, val(ibd), val(imzml) from pairs
//  val sap from params.sap
 // path f_make_datacube from params.f_make_datacube

 output:
    val(imzml) into rec_imzml
  //  val(ibd) into rec_ibd
 //   file '${sample_id}.mat' into res1

  """
  echo $imzml > file
  echo $ibd > file
//  git clone -b 'v1.4.0' --single-branch https://github.com/AlanRace/SpectralAnalysis.git
  """
}

rec_imzml.view {Received: $it}
// rec_ibd.view {Matched: $it}

//process clustering {
//
// publishDir "$params.outdir"
//
//
// input:
//  file input_file from res1
//  path f_clustering from params.f_clustering
//  
//  output:
//   file '${input_file.baseName}.mat' into res2
//  
//  """
//  matlab -nodesktop -nodisplay -r "clustering('$input_file', 'cosine', 2, 500);exit"
//  """
//
//}
//
