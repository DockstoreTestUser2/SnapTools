#!/usr/bin/env cwl-runner

class: CommandLineTool
id: snaptools_create_cell_by_bin_matrix
label: snaptools create cell by bin matrix
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

  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.snap_file)
        writable: true

inputs:
  snap_file:
    type: File
    inputBinding:
      position: 1
      prefix: --snap-file
    doc: The SNAP file in which to place the cell by bin matrix.

  bin_size_list:
    type: string[]?
    inputBinding:
      prefix: --bin-size-list
      position: 2
    doc: A list of bin size(s) to create in the cell-by-bin count matrix.

  tmp_folder:
    type: string?
    inputBinding:
      position: 11
      prefix: --tmp-folder
    doc: Directory to store temporary files.

  verbose:
    type: string?
    inputBinding:
      position: 13
      prefix: --verbose
    doc: A boolen tag; if true output the progress.

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.snap_file.basename)

baseCommand: [snaptools, snap-add-bmat]
