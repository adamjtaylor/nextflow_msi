#!/usr/bin/env nextflow
 
params.in = "$HOME/mouse-brain/SagittalMouseCerebellum.imzML"
 

process sa_auto {
 
    input:
    path x from params.in
    
    """
    matlab -nodesktop -nosplash -r "writematrix('test','/home/adamtaylor/Documents/test/test.txt'); exit;"
    """
}
