#!/usr/bin/env nextflow
nextflow.enable.dsl=2


// process  BaseRecalibrator{


// }

// process BQSR{


// }

// process GATKHaplotypecaller{
//     tag("${sampleid}")

//     container 'broadinstitute/gatk:4.6.2.0'

//     input:
//     path(ref_genome)
//     tuple val(sampleid), path(bam_path)

//     output:
//     tuple val (sampleid), path("${sampleid}.gatkHTC.bam"), emit: GATK_haplotypecaller_BAM

//     script:
//     """
    
//     """
// }


process Normalise_and_Filter{
    tag("${sampleid}")
    container 'community.wave.seqera.io/library/bcftools_samtools:1.23.1--79a710bf7bd8ea91'

    input:
    path(ref_genome)
    tuple val(sampleid), path(vcf_file)

    output:
    tuple val (sampleid), path("${sampleid}_norm_variants.vcf"), emit: Normalised_VCF_out, optional: true
    tuple val (sampleid), path("${sampleid}_filtered_norm_variants.vcf"), emit: Filtered_Normalised_VCF_out, optional: true
    script:
    """
    echo "Generating temp index for reheading"
    echo "Normalising vcf ----splitting multiallelic sites"
    samtools faidx -f $ref_genome
    bcftools reheader -f "${ref_genome}.fai" ${vcf_file} | bcftools norm -m -any -f "${ref_genome}" -o "${sampleid}_norm_variants.vcf" 

    FilterSettings='DP>=30 && AF>=0.01 && QUAL>20' #######################FIX THIS LATER IT DOESNT WORK####################

    echo "Filtering using settings: DP>=30 && AF>=0.01 && QUAL>20"
    bcftools view -i 'DP>=30 && AF>=0.01 && QUAL>20' "${sampleid}_norm_variants.vcf" > "${sampleid}_filtered_norm_variants.vcf"
    """

}

include { LofreqVarCall } from "../modules/LofreqVarCall.nf"
include { LoFreqIndelQual } from "../modules/LoFreqIndelQual.nf"

workflow VARIANT_CALLING{
    take:
    Aligned_bam_path

    main:

    Reference_channel_VCF = file(params.Ref_genome_path)
    bams_ch = Aligned_bam_path

    
    LoFreqIndelQual(Reference_channel_VCF, bams_ch)
    println("Using VariantCaller lofreq")
    LofreqVarCall(Reference_channel_VCF, LoFreqIndelQual.out.IndelQual_BAM)
    Normalise_and_Filter(Reference_channel_VCF, LofreqVarCall.out.LoFreq_VCF_out)


    emit:
    VCF_out = LofreqVarCall.out.LoFreq_VCF_out
    nVCF_out  = Normalise_and_Filter.out.Normalised_VCF_out
    fnVCF_out = Normalise_and_Filter.out.Filtered_Normalised_VCF_out
}