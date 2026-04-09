//Take input BAM and run through the following 2 programs: CliqueSNV (generating local haplotypes) and HaploClique

process cliqueSNV{
    container "elasekness/cliquesnv:2.0.3"

    input:

    output:

    script:
    method = "snv-${params.platform}"
    """
    cat $method | tr '[a-z|A-Z]' '[a-z]' > $method
    echo "$method"
    ##clique-snv.jar -m ${method}
    """
}


workflow HAPLOTYPE_RECONSTRUCTION{
    take:

    main:
    cliqueSNV(params.platform.toLowerCase())

    emit:

}