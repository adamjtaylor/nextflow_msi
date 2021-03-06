#!/usr/bin/env nextflow
 
params.imzml =  '/home/adamtaylor/Documents/mouse-brain/SagittalMouseCerebellum.imzML'
params.sap = '/home/adamtaylor/Documents/mouse-brain/mouse-brain-preprocessingWorkflow.sap'
params.sa_path = '/home/adamtaylor/SpectralAnalysis'
params.nzm_multiple = 3
params.outdir = '.'

imzml_ibd_pair = params.imzml.replaceFirst(/imzML/, "{imzML,ibd}")

ch_pairs = Channel.fromFilePairs(imzml_ibd_pair, flat: true)
ch_pairs.into { ch_pairs1; ch_pairs2 }


process total_spectrum{

 input:
  set sample_id, path(ibd), path(imzml) from ch_pairs1
  path sap from params.sap
  val sa_path from params.sa_path

 output:
    val(imzml) into rec_imzml
    val(ibd) into rec_ibd
    path 'mean_spectrum.mat' into ch_mean_spectra

  """
  echo $imzml > file
  echo $ibd > file
  matlab -nodesktop -nodisplay -r "addpath(genpath('$workflow.projectDir'));total_spectrum('$imzml', '$sap', '$sa_path');exit"
  """
}

rec_imzml.view { "imzML: $it" }
rec_ibd.view { "ibd: $it" }

process peak_picking{
 
 input:
  path input_file from ch_mean_spectra
  val nzm_multiple from params.nzm_multiple
  val sa_path from params.sa_path
 
 output:
  path 'picked_peaks.mat' into ch_picked_peaks
 
 """
 matlab -nodesktop -nodisplay -r "addpath(genpath('$workflow.projectDir'));peak_picking('$input_file', $nzm_multiple, '$sa_path');exit"
 """
  
}

process make_datacube {

 input:
  set sample_id, path(ibd), path(imzml) from ch_pairs2
  path peaks from ch_picked_peaks
  val sa_path from params.sa_path
  
  output:
   path 'datacube.mat' into ch_datacube
  
  """
  matlab -nodesktop -nodisplay -r "addpath(genpath('$workflow.projectDir'));make_datacube('$imzml', '$peaks', '$sa_path');exit"
  """
}

process cluster_tissue_background {

 publishDir "$params.outdir"

 input:
  path datacube from ch_datacube
  val sa_path from params.sa_path
  
  output:
   path '*_nf.mat' into ch_final
  
  """
  matlab -nodesktop -nodisplay -r "addpath(genpath('$workflow.projectDir'));cluster_tissue_background('$datacube', 'cosine', 2, 500, '$sa_path');exit"
  """
}

