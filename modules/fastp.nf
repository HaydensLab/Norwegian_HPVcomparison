process fastp{
    container "biocontainers/fastp:v0.20.1_cv1"

    tag("${sampleid}")

    input:
    tuple val(sampleid), path(read1), path(read2)

    output:
    tuple val(sampleid), path("*_1.trimmed.fastq.gz"), path("*_2.trimmed.fastq.gz"), emit: "read_tuple"
    path("${sampleid}.html"), emit: "html", optional: true
    path("${sampleid}.json"), emit: "json", optional: true

    script:
    """
    fastp \
      -i ${read1} -I ${read2} \
      -o ${sampleid}_1.trimmed.fastq.gz \
      -O ${sampleid}_2.trimmed.fastq.gz \
      -h ${sampleid}.html \
      -j ${sampleid}.json \
    """
}