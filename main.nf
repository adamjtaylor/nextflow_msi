#!/usr/bin/env nextflow
 
params.in = "test"
 

process sa_auto {
 input:
val x from params.in

    
    """
     matlab -nodesktop -nodisplay -r "dummy('$x');exit"
    """
}
