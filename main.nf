#!/usr/bin/env nextflow
 
params.in = "$HOME/mouse-brain/SagittalMouseCerebellum.imzML"
 

process sa_auto {
 
    input:
    path x from params.in
    
    """
    matlab -nodesktop -nosplash -r \	     matlab -nodesktop -nosplash -r "dummy($x); exit;"
    "disp(['Processing file' $x]); \	
    dummy($x); \	
    disp("Complete") \	
    exit" \	
    """
}
