#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { fastqc } from "../modules/fastqc.nf"
include { fastqc as fastqc_trimmed} from "../modules/fastqc.nf" //Alias for reuse

include { multiqc } from "../modules/multiqc.nf"
include { multiqc as multiqc_trimmed} from "../modules/multiqc.nf" //Alias for reuse

include { fastp } from "../modules/fastp.nf"

workflow PREPROCESSING{

    main:
    //Input channel inputting a flat array of the ID, Read1 path, Read2 path.
    Raw_Reads_channel = channel.fromFilePairs("${params.read_location}/*_{1,2}.fastq.gz", flat: true)//this specifies group pairs matching the pattern starts with ERR ends with _1 OR _2 it outputs an array with value 0 being ID before _1/2 and the read pair


    //upfront declaration of output channels setting as default for optional emits
    fastqc_qc_path = channel.empty()
    multiqc_out = channel.empty()
    fastp_read_tuple = channel.empty()
    fastp_out_html = channel.empty()
    fastp_out_json = channel.empty()
    fastqc_trim_qc_path = channel.empty()
    multiqc_trim_out = channel.empty()


    if(params.Run_QC == true){
    //initial raw read QC
        fastqc(Raw_Reads_channel)
        fastqc_qc_path = fastqc.out.qc_path

        multiqc(params.batch, fastqc.out.qc_path.collect())
        multiqc_out = multiqc.out

    //running fastp to remove adapters where possible
        fastp(Raw_Reads_channel)
        fastp_read_tuple = fastp.out.read_tuple
        fastp_out_html = fastp.out.html
        fastp_out_json = fastp.out.json

    //second round of post-trimming QC
        fastqc_trimmed(fastp.out.read_tuple)
        fastqc_trim_qc_path = fastqc_trimmed.out.qc_path

        multiqc_trimmed(params.batch, fastqc_trimmed.out.qc_path.collect())
        multiqc_trim_out = multiqc_trimmed.out
    }
    else if (params.Run_QC == false){
        println("Skipping QC - running fastp")
        fastp(Raw_Reads_channel) // just run fastP
        fastp_read_tuple = fastp.out.read_tuple
        fastp_out_html = fastp.out.html
        fastp_out_json = fastp.out.json
    }
    else{
        error("Invalid QC parameter input! Please provide: true or false to Run_QC parameter")
        exit(1,"Invalid QC parameter input! Please provide: true or false to Run_QC parameter")
    }


    emit:
    QCresults               = fastqc_qc_path ?: channel.empty()
    Multiqc_results         = multiqc_out ?: channel.empty()
    Fastp_trimmed           = fastp_read_tuple ?: channel.empty() //trimmed reads to go for later processing (with sample id)
    Fastp_html              = fastp_out_html ?: channel.empty() //report html
    Fastp_json              = fastp_out_json ?: channel.empty() //report json
    Trimmed_QCresults       = fastqc_trim_qc_path ?: channel.empty()
    Trimmed_multiqc_results = multiqc_trim_out ?: channel.empty()

}