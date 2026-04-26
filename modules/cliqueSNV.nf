process cliqueSNV{
    tag("${sampleid}")
    container "community.wave.seqera.io/library/cliquesnv_samtools:25cd3de642f742dc"

    input:
    val(platform)
    tuple val(sampleid), path(bam_path) //input the metadata and path to the bam file which will be converted back to the sam as an intermediate step.
    //Input also takes patch_num (Coverage_and_stats environment variable) but does not use it in order to minimise channels used

    output:
    tuple val(sampleid), path("snv_output/*"), emit: "CliqueSNV_out", optional: true //tuple for sampleid specific folder output with all contents

    script:
    //first generate a method variable to specify either pacbio or illumina 
    method = "snv-${platform}"
    """
    samtools view -h -o "${sampleid}.sam" ${bam_path}
    cliquesnv -m ${method} -rn -in "${sampleid}.sam" #use clique-snv.jar for local use but this container has it in conda
    """
}