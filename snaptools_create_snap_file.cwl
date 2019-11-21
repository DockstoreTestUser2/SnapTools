cwlVersion: v1.0
class: Workflow

dct:creator:
  '@id':  https://orcid.org/0000-0001-5173-4627
  foaf:name: Walter Shands
  foaf:mbox: jshands@ucsc.edu

inputs:
  input_reference_genome: File
  input_fastq1: File
  input_fastq2: File

outputs:
  output:
    type: File
    outputSource: snaptools_create_cell_by_bin_matrix/output

steps:
  snaptools_index_ref_genome:
    run: snaptools_index_ref_genome_tool.cwl
    in:
      input_fasta: input_reference_genome

    out:
      [output]

  snaptools_create_ref_genome_size_file:
    run: snaptools_create_ref_genome_size_file_tool.cwl
    in: 
      ref_genome: input_reference_genome

    out: [output]

  snaptools_align_paired_end:
    run: snaptools_align_paired_end_tool.cwl
    in:
      input_reference: snaptools_index_ref_genome/output
      input_fastq1: input_fastq1
      input_fastq2: input_fastq2

    out: [output]

  snaptools_preprocess_reads:
    run: snaptools_preprocess_reads_tool.cwl
    in:
      input_file: snaptools_align_paired_end/output
      genome_size: snaptools_create_ref_genome_size_file/output

    out: [output]

  snaptools_create_cell_by_bin_matrix:
    run: snaptools_create_cell_by_bin_matrix_tool.cwl
    in:
      snap_file: snaptools_preprocess_reads/output

    out: [output]
