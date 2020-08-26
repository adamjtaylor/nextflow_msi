#!/usr/bin/env nextflow
 
params.in = "$HOME/mouse-brain/SagittalMouseCerebellum.imzML"
 

process sa_auto {

    
    """
     matlab -nodestop -nodisplay -r "dummy('test');exit"
    """
}
