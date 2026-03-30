#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { BWA_Indexing } from "../modules/BWAindexer.nf"
include { Aligner } from "../modules/BWAaligner.nf"  

process IndexForIGV{
    input:
    tuple val(sampleid), path(bam_path)
    output:
    path("${sampleid}.bai"), emit: "bai"
    script:
    """
    samtools -b ${bam_path} -o "${sampleid}.bai"
    """
}

workflow BWAALIGNMENT{
    take:
    Fastp_trimmed

    main:
    Reference_channel = channel.fromPath(params.Ref_genome_path)
    BWA_Indexing(Reference_channel)
    Aligner_input_ch = Fastp_trimmed
    Aligner_indexes_ch = BWA_Indexing.out.Index_files.collect().map{ Index_files -> tuple(Index_files)}.view()
    Aligner(Aligner_input_ch, Aligner_indexes_ch)
    IndexForIGV(Aligner.out.bam)

    emit:
    Indexes = BWA_Indexing.out.Index_files
    BAM_out = Aligner.out.bam[1]
    BAI_out = IndexForIGV.out.bai
}