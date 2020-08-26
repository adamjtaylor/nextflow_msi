#!/usr/bin/env nextflow
 
params.in = "$HOME/mouse-brain/SagittalMouseCerebellum.imzML"
 

process sa_auto {
 
    input:
    path x from params.in
   
   """
     matlab -nodesktop -nosplash -r \
    "disp(['Processing file' $x]); \
    sa_auto($x); \
    disp("Complete") \
     exit"
 
    """
}
