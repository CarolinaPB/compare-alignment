configfile: "config.yaml"

pipeline = "compare-alignment" # replace your pipeline's name

include: "rules/create_file_log.smk"

MAF = config["MAF"]
mafCoverage = "/lustre/nobackup/WUR/ABGC/derks047/progs_nobackup/mafTools/bin/mafCoverage"

workdir: config["OUTDIR"]

rule all:
    input:
        files_log,
        "coverage.txt",
        "coverage_rev.txt"


rule get_mafCoverage:
    input: 
        MAF
    output:
        "mafcoverage.txt"
    message:
        "Rule {rule} processing"
    params:
        mafCoverage = mafCoverage
    shell:
        "{params.mafCoverage} -m {input} > {output}"

rule summarize_alignments_target:
    input:
        rules.get_mafCoverage.output
    output:
        "coverage.txt"
    message:
        "Rule {rule} processing"
    shell:
        # "cat {input} |  awk '$1 ~ /^Mgal6/' | awk '$2 ~ /^[^Mgal6]/' | awk '$4 > 0.01' | sort -k1,1 -k4,4r -V > {output}"
        # "cat {input} | awk '$1 ~ /^[^scaffold]/' | awk '$2 ~ /^scaffold/' | awk '$4 > 0.01' | sort -k1,1 -k4,4r -V > {output}"
        "cat {input} | awk '$1 ~ /^[^Scaffolds]/' | awk '$2 ~ /^Scaffolds/' | awk '$4 > 0.01' | sort -k1,1 -k4,4r -V > {output}"
rule summarize_alignments_reference:
    input:
        rules.get_mafCoverage.output
    output:
        "coverage_rev.txt"
    message:
        "Rule {rule} processing"
    shell:
        # "cat {input} |  awk '$1 ~ /^[^Mgal6]/' | awk '$2 ~ /^Mgal6/' | awk '$4 > 0.01' | sort -k1,1 -k4,4r -V > {output}"
        # "cat {input} | awk '$1 ~ /^scaffold/' | awk '$2 ~ /^[^scaffold]/' | awk '$4 > 0.01' | sort -k1,1 -k4,4r -V > {output}"
        "cat {input} | awk '$1 ~ /^Scaffolds/' | awk '$2 ~ /^[^Scaffolds]/' | awk '$4 > 0.01' | sort -k1,1 -k4,4r -V > {output}"

