process LofreqVarCall{
//ENSURE BED FILE IS PROVIDED IN CASE OF VARIANT CALLING NOT ON ENTIRE GENOME (specify locations in a bed file that are being tested to avoid bonferroni problems)

    tag("${sampleid}")

    container 'nanozoo/lofreq:2.1.5--229539a'

    input:
    path(ref_genome)
    tuple val(sampleid), path(recalibrated_bam)

    output:
    tuple val (sampleid), path("${sampleid}_variants.vcf"), emit: LoFreq_VCF_out, optional: true

    script:
    """
    ##lofreq call-parallel --pp-threads 8 -f ref.fa -o vars.vcf aln.bam
    lofreq call --call-indels -f ${ref_genome} -o "${sampleid}_variants.vcf" ${recalibrated_bam}
    """
}