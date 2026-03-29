#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { BWA_Indexing} from "./modules/BWAindexer.nf"
include { Aligner } from "./modules/BWAaligner.nf"  

workflow BWAalignment{
    take:

    main:
    
    emit:

}