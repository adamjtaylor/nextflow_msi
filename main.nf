#!/usr/bin/env nextflow
 
params.in = "$HOME/mouse-brain/SagittalMouseCerebellum.imzML"
 

process sa_auto {
 
    input:
    path x from params.in
    
    """
     matlab -nodestop -nodisplay -r "dummy('test');exit"
    """
}
