#!/usr/bin/env nextflow
nextflow.enable.dsl=2


params{
    left: Path
    right: Path
}
// process RunConfigImport{
    
// }



// process Trimming{


// }

// process Aligner{

// }

// process PostProcessing{

// }

// process VariantCalling{

// }

// process VariantFiltering{

// }

// process VariantAnnotation{

// }

process TestProcess{
    input:
    path Forward_Read
    path Reverse_Read
    
    output:
    tuple path(Forward_Read), path(Reverse_Read)

    script:
    """
    echo "Input files are ${Forward_Read} and ${Reverse_Read}"
    """
}

//each channel displays as a symlink to the previous work directory of the previous process, hence the loss of absolute file path
process Qualitycontrol{
    input:
    tuple path(Forward_Read), path(Reverse_Read)

    output:
    stdout

    script:
    """
    echo "Process 2 files are ${Forward_Read} and ${Reverse_Read}"
    """
}


workflow{


TestProcess(params.left, params.right)

TestProcess.out.view()

Qualitycontrol(TestProcess.out)

Qualitycontrol.out.view()

}

output{

}