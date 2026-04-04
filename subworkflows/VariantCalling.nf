#!/usr/bin/env nextflow
nextflow.enable.dsl=2


// process CliqueSNV{

// }

// process ShoRAH{


// }

// process GATKHaplotypecaller{

// }

process LoFreqIndelQual{

    tag("${sampleid}")

    container 'nanozoo/lofreq:2.1.5--229539a'

    input:
    path(ref_genome)
    tuple val(sampleid), path(bam_path)

    output:
    tuple val (sampleid), path("${sampleid}.indelqual.bam"), emit: IndelQual_BAM

    script:
    """
    lofreq indelqual --dindel -f ${ref_genome} -o "${sampleid}.indelqual.bam" ${bam_path}
    """
}


process LofreqVarCall{
//ENSURE BED FILE IS PROVIDED IN CASE OF VARIANT CALLING NOT ON ENTIRE GENOME (specify locations in a bed file that are being tested to avoid bonferroni problems)

    tag("${sampleid}")

    container 'nanozoo/lofreq:2.1.5--229539a'

    input:
    path(ref_genome)
    tuple val(sampleid), path(recalibrated_bam)

    output:
    path("${sampleid}_variants.vcf"), emit: LoFreq_VCF_out, optional: true

    script:
    """
    ##lofreq call-parallel --pp-threads 8 -f ref.fa -o vars.vcf aln.bam
    lofreq call -f ${ref_genome} -o "${sampleid}_variants.vcf" ${recalibrated_bam}
    """
}



workflow VARIANT_CALLING{
    take:
    Aligned_bam_path

    main:
    Reference_channel_VCF = file(params.Ref_genome_path)
    bams_ch = Aligned_bam_path

    LoFreqIndelQual(Reference_channel_VCF, bams_ch)
    LofreqVarCall(Reference_channel_VCF, LoFreqIndelQual.out.IndelQual_BAM)

    emit:
    VCF_out = LofreqVarCall.out.LoFreq_VCF_out
}