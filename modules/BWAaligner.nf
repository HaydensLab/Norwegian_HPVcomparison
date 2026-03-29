process Aligner{
        
    tag("${sampleid}")

    container "community.wave.seqera.io/library/bwa_samtools:eac4ad78deba8f5d"
        
    input:
    tuple val(sampleid), path(read1), path(read2)
    path(Indexes)

    output:
    path("*.bam"), emit: "bam", optional: true
    path("*.cram"), emit: "cram", optional: true
    path("*.crai"), emit: "crai", optional: true
    path("*.csi"), emit: "csi", optional: true

    script:
    """
    read_group="@RG\\tID:Seq${sampleid}\\tSM:Seq${sampleid}\\tPL:${params.platform}\\tPI:${params.insert_size}"
    bwa mem -R \$read_group ${Indexes[0].baseName} ${read1} ${read2} | samtools view -b -S | samtools sort -n -o "${sampleid}.bam"
    """

    stub:
    """
    echo "${Indexes}"
    touch ${sampleid}.bam
    touch ${sampleid}.csi
    touch ${sampleid}.crai
    """
}