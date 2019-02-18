## SnapTools
A module for working with snap files in Python.

## Introduction
snap (Single-Nucleus Accessibility Profiles) file is a hierarchically structured hdf5 file that is specially designed for storing single nucleus ATAC-seq datasets. A snap file (version 4) contains the following sessions: header (HD), cell-by-bin accessibility matrix (AM), cell-by-peak matrix (PM), cell-by-gene matrix (GM), barcode (BD) and fragment (FM). 

* HD session contains snap-file version, created date, alignment and reference genome information. 
* BD session contains all unique barcodes and corresponding meta data. 
* BM session contains cell-by-bin matrices of different resolutions (or bin sizes). 
* PM session contains cell-by-peak count matrix. PM session contains cell-by-gene count matrix. 
* FM session contains all usable fragments for each cell. Fragments are indexed for fast search. 
* Detailed information about snap file can be found here.

## Requirements 
* Python (2.7)
* pysam
* h5py
* numpy
* pybedtools

## Quick Install 
Install snaptools from source code

```bash
> git clone https://github.com/r3fang/snaptools.git
> python setup.py --user
> ./bin/snaptools

Program: snaptools (a toolkit for single nucleus ATAC-seq analysis)
Version: v1.0
Contact: Rongxin Fang 
E-mail:  r4fang@gmail.com

optional arguments:
  -h, --help        show this help message and exit

functions:

    index-genome    Index reference genome.
    align-paired-end
                    Align paired-end reads.
    align-single-end
                    Align single-end reads.
    snap-pre        Create a snap file from bam or bed file.
    snap-add-bmat   Add cell x bin count matrix to snap file.
    snap-add-pmat   Add cell x peak count matrix to snap file.
    snap-add-gmat   Add cell x gene count matrix to snap file.
    dump-fragment   Dump fragments of selected barcodes from a snap file.
    dump-barcode    Dump barcodes from a snap file.
    call-peak       Call peak using selected barcodes.
```

## Example

**Step 1. Download test example**

```
> wget http://renlab.sdsc.edu/r3fang/share/snaptools/snaptools_test.tar.gz
> tar -xf snaptools_test.tar.gz
> cd snaptools_test/
```

**Step 2. Index Reference Genome (Optional)**. 
Index the reference genome before alingment if you do not have one. (skip this step if you already have indexed genome). Here we show how to index the genome using BWA. User can choose different `--aligner `. 

```bash
> snaptools index-genome                \
	--input-fasta=mm10.fa                \
	--output-prefix=mm10                 \
    --aligner=bwa                       \
	--path-to-aligner=path_to_bwa/bin/   \
	--num-threads=3
```

**Step 3. Alignment**. 
We next align reads to the corresponding reference genome using snaptools with following command. After alignment, reads are sorted by the read names which allows for grouping reads according to the barcode (`--if-sort`). User can mutiple CPUs to speed up this step (`--num-threads`).

```bash
> snaptools align-paired-end            \
	--input-reference=mm10.fa            \
	--input-fastq1=demo.R1.fastq.gz      \
	--input-fastq2=demo.R2.fastq.gz      \
	--output-bam= demo.bam               \
	--aligner=bwa                        \
	--path-to-aligner=path_to_bwa/bin/   \
	--read-fastq-command=zcat            \
	--min-cov=0                          \
	--num-threads=5                      \
	--if-sort=True                       \
	--tmp-folder=./                      \
	--overwrite=TRUE                     
```

**Step 4. Pre-processing**. 
After alignment, we converted pair-end reads into fragments and for each fragment, we check the following attributes: 1) mapping quality score MAPQ; 2) whether two ends are appropriately paired according to the alignment flag information; 3) fragment length. We only keep the properly paired fragments whose MAPQ (`--min-mapq`) is greater than 30 with fragment length less than 1000bp (`--max-flen`). Because the reads have been sorted based on the names, fragments belonging to the same cell (or barcode) are naturally grouped together which allows for removing PCR duplicates. After alignment and filtration, we generated a snap-format (Single-Nucleus Accessibility Profiles) file that contains meta data, cell-by-bin count matrices of a variety of resolutions, cell-by-peak count matrix. Detailed information about snap file can be found in here. 

```bash
> snaptools snap-pre                     \
	--input-file=demo.bam                \
	--output-snap=demo.snap              \
	--genome-name=mm10 	                 \
	--genome-size=mm10.chrom.sizes       \
	--min-mapq=30      	                 \
	--min-flen=0       	                 \
	--max-flen=1000    	                 \
	--keep-chrm=TRUE                     \
	--keep-single=TRUE                   \
	--keep-secondary=False               \
	--overwrite=True                     \
	--min-cov=100                        \
	--verbose=True
```

**Step 5. Cell-by-Bin Matrix**. 
Using generated snap file, we next create the cell-by-bin matrix. Snap file allows for storing cell-by-bin matrices of different resolutions. In the below example, three cell-by-bin matrices are created with bin size of 1,000, 5,000 and 10,000. 

```bash
> snaptools snap-add-bmat             \
	--snap-file=demo.snap              \
	--bin-size-list 1000 5000 10000    \
	--verbose=True
```

**Step 6. Cell-by-gene Matrix**. 
We next create the cell-by-gene matrix which is later used for cluster annotation.


```bash
> snaptools snap-add-gmat             \
	--snap-file=demo.snap             \
	--gene-file=gencode.vM16.gene.bed  \
	--verbose=True
```

**Step 7. Cell-by-peak Matrix**. 
We next add the cell-by-peak matrix.

```bash
> snaptools snap-add-pmat             \
	--snap-file=demo.snap              \
	--peak-file=peaks.bed               \
	--verbose=True
```


