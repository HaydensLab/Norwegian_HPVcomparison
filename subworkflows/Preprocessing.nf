#!/usr/bin/env nextflow
nextflow.enable.dsl=2


include { fastqc } from "./modules/fastqc.nf"
include { fastqc as fastqc_trimmed} from "./modules/fastqc.nf" //Alias for reuse

include { multiqc } from "./modules/multiqc.nf"
include { multiqc as multiqc_trimmed} from "./modules/multiqc.nf" //Alias for reuse

include { fastp } from "./modules/fastp.nf"

workflow Preprocessing{
    take:
    
    main:

    emit:

}