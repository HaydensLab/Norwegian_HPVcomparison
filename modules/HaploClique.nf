process HaploClique{ //currently unused
    container "community.wave.seqera.io/library/haploclique:1.3.1--5baeef280bc3b4ba"
    tag("${sampleid}")

    input:
    tuple val(sampleid), path(bam_path)

    output:
    tuple val(sampleid), path("*"), emit: "haploclique_out", optional: true

    script:
    """
    haploclique "${bam_path}"
    """
}