process Stats_and_Coverage{
    tag("${sampleid}")
    container "community.wave.seqera.io/library/samtools:1.23.1--d76a06ff3aefee52"

    input:
    tuple val(sampleid), path(bam_path)

    output:
    env('patch_num'), emit: "BAM_splitting", optional: true
    path("${sampleid}.stats"), emit: "BAM_stats", optional: true
    path("${sampleid}.coverage"), emit: "BAM_coverage", optional: true

    script:
    //takes sum of depth divide by number of lines (average depth)
    //then divides by 750 to calculate the total number of splits the data requires for savage
    //then generates a stats output for the bam file
    """
    AVERAGE_COVERAGE=\$(samtools coverage ${bam_path} > "${sampleid}.coverage"
    awk 'NR>1 {sum+=\$7; count++} END {print (sum/count)}' ${sampleid}.coverage)
    
    patch_num=\$(awk -v x="\$AVERAGE_COVERAGE" 'BEGIN {print int((x+749)/750)}')
    samtools stats ${bam_path} > "${sampleid}.stats"
    echo "${sampleid} has an average depth of \$AVERAGE_COVERAGE \n\n Savage splitting: \$patch_num"
    """
}