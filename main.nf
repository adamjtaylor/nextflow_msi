#!/usr/bin/env nextflow
 
params.first = 2
params.second = 4

/* A trivial matlab script adding two numbers
 
/*
 * A trivial Perl script producing a list of numbers pair
 */
process matlabTask {
    echo = true
 
    shell:
    '''
    #!/usr/bin/env bash
 
   matlab -nojvm -nodisplay -nosplash
   print($first+$second)
   exit;
 
    '''
}
 
