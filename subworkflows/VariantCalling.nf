#!/usr/bin/env nextflow
nextflow.enable.dsl=2


process CliqueSNV{

}

process ShoRAH{


}

process GATKHaplotypecaller{

}

process LoFreqIndelQual{

    tag("${sampleid}")

    container 'nanozoo/lofreq:2.1.5--229539a'

    input:


    output:

    script:
    """
    lofreq indelqual --dindel -f ${params.Ref_genome_path} -o ${bam_path}
    """
}

process LofreqVarCall{
//ENSURE BED FILE IS PROVIDED IN CASE OF VARIANT CALLING NOT ON ENTIRE GENOME (specify locations in a bed file that are being tested to avoid bonferroni problems)

    tag("${sampleid}")

    container 'nanozoo/lofreq:2.1.5--229539a'

    input:


    output:

    script:
    """
    lofreq indelqual --dindel -f ${params.Ref_genome_path} -o ${bam_path}
    """
}



workflow VARIANT_CALLING{
    take:
    markdup_bam_path


    main:

    emit:
    VCF_out = 
}