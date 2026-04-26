//Take input BAM and run through the following 2 programs: CliqueSNV (generating local haplotypes) and HaploClique

// process MEGAHIT{
//     container "vout/megahit:release-v1.2.9"
//     tag("${sampleid}")

//     input:
//     tuple val(sampleid), path(read1), path(read2)

//     output:
//     script:
//     """
  
//     """
// }

include { cliqueSNV } from "../modules/cliqueSNV.nf"
include { SAVAGE } from "../modules/SAVAGE.nf"
//include { HaploClique } from "../modules/HaploClique.nf"

workflow HAPLOTYPE_RECONSTRUCTION{
    take:
    Markdup_BAM
    raw_reads
    Savage_splitting
    main:
    //Haplotype SNV calls
         cliqueSNV(params.platform.toLowerCase(), Markdup_BAM) //does not take splits as input
            cliqueSNV.out.CliqueSNV_out.view()
    //Global haplotypes
            //HaploClique(Markdup_BAM)
        SAVAGE(raw_reads, Savage_splitting)

    emit:
    Haplotype_out = cliqueSNV.out.CliqueSNV_out
            //Global_Haplotype_out = HaploClique.out.haploclique_out
    Global_Haplotype_out = SAVAGE.out.SAVAGE_out

}