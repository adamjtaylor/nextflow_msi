#!/usr/bin/env nextflow
 
params.in = "$HOME/mouse-brain/SagittalMouseCerebellum.imzML"
 

process sa_auto {
 
    input:
    path 'input.imzml' from params.in
   
   """
     matlab -nodesktop -nosplash -r \
    "disp(['Processing file' $input.imzml]); \
    sa_auto($input.imzml); \
    disp("Complete") \
     exit"
 
    """
}
