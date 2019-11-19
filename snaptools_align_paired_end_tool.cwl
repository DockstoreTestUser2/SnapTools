#!/usr/bin/env cwl-runner

class: CommandLineTool
id: snaptools_align_paired_end
label: snaptools align paired end reads
cwlVersion: v1.0

$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/

dct:creator:
  '@id':  https://orcid.org/0000-0001-5173-4627
  foaf:name: Walter Shands
  foaf:mbox: jshands@ucsc.edu

requirements:
  DockerRequirement:
    dockerPull: "snaptools:1.2.3"
  ResourceRequirement:
    coresMin: 1
    ramMin: 1024
    outdirMin: 100000

  #InitialWorkDirRequirement:
  #  listing:
  #    - $(inputs.input_reference)

inputs:
  input_reference:
    type: File
    inputBinding:
      position: 1
      prefix: --input-reference
    secondaryFiles: [".bwt", ".sa", ".ann", ".pac", ".amb"]
    doc: The genome reference file to be indexed.

  input_fastq1:
    type: File
    inputBinding:
      position: 1
      prefix: --input-fastq1
    doc: The first paired end fastq file to be aligned.

  input_fastq2:
    type: File
    inputBinding:
      position: 2
      prefix: --input-fastq2
    doc: The second paired end fastq file to be aligned.

  output_bam:
    type: string
    inputBinding:
      position: 3
      prefix: --output-bam
    default: "snaptools_alignment.bam"
    doc: The name to use for the output bam file containing unfiltered alignments.

  aligner:
    type: string?
    inputBinding:
      position: 4
      prefix: --aligner
    default: "bwa"
    doc: The name of the aligner, e.g. 'bwa'.

  path_to_aligner:
    type: string?
    inputBinding:
      position: 5
      prefix: --path-to-aligner
    default: "/tools"
    doc: The file system path to the aligner.

  aligner_options:
    type: string[]?
    inputBinding:
      prefix: --aligner-options
      position: 6
    doc: List of strings indicating options you would like passed to aligner.

  read_fastq_command:
    type: string?
    inputBinding:
      position: 7
      prefix: --read_fastq-command
    doc: Command line to execute for each of the input files.

  min_cov:
    type: string?
    inputBinding:
      position: 8
      prefix: --min-cov
    doc: Minimum number of fragments per barcode.

  num_threads:
    type: string?
    inputBinding:
      position: 9
      prefix: --num-threads
    doc: The number of threads to use.

  if_sort:
    type: string?
    inputBinding:
      position: 10
      prefix: --if-sort
    doc: Whether to sort the bam file based on the read name.

  tmp_folder:
    type: string?
    inputBinding:
      position: 11
      prefix: --tmp-folder
    doc: Directory to store temporary files.

  overwrite:
    type: string?
    inputBinding:
      position: 12
      prefix: --overwrite
    doc: Whether to overwrite the output file if it already exists.

  verbose:
    type: boolean?
    inputBinding:
      position: 13
      prefix: --verbose
    doc: A boolen tag; if true output the progress.

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_bam)

baseCommand: [snaptools, align-paired-end]
