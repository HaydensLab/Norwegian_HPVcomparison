process LoFreqIndelQual{

    tag("${sampleid}")

    container 'nanozoo/lofreq:2.1.5--229539a'

    input:
    path(ref_genome)
    tuple val(sampleid), path(bam_path)

    output:
    tuple val (sampleid), path("${sampleid}.indelqual.bam"), emit: IndelQual_BAM

    script:
    """
    lofreq indelqual --dindel -f ${ref_genome} -o "${sampleid}.indelqual.bam" ${bam_path}
    """
}