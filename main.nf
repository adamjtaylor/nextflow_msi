#!/usr/bin/env nextflow
 
params.in = "~/Documents/mouse-brain/SagittalMouseCerebellum.imzML"
 

process sa_auto {
 
    input:
    path 'input.imzml' from params.in
   
   """
     matlab -nodesktop -nosplash -r \
    "disp(['Processing file' $x]); \
    sa_auto($x); \
    disp("Complete") \
     exit"
 
    """
}
