#!/usr/bin/env nextflow
 
params.imzml_folder =  '/home/adamtaylor/Documents/mouse-brain/multiple'
params.sap = '/home/adamtaylor/Documents/mouse-brain/mouse-brain-preprocessingWorkflow.sap'
params.sa_path = '/home/adamtaylor/SpectralAnalysis'
params.nzm_multiple = 3
params.outdir = '.'


ch_imzml = Channel
    .fromFilePairs('${params.imzml_folder}/*.{imzML,ibd}')


process total_spectrum_together{

 input:
  val input_folder from params.imzml_folder
  path sap from params.sap
  val sa_path from params.sa_path

 output:
    path 'mean_spectrum_together.mat' into ch_mean_spectra

  """
  matlab -nodesktop -nodisplay -r "addpath(genpath('$workflow.projectDir'));total_spectrum_together('$input_folder', '$sap', '$sa_path');exit"
  """
}

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
  set sample_id, path(ibd), path(imzml) from ch_imzml
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

