#BSUB -J whole_jochum_qiime2         #Set the job name to "ExampleJob3"
#BSUB -L /bin/bash                #Uses the bash login shell to initialize the job's execution environment.
#BSUB -W 24:00                     #Set the wall clock limit to 24hr
#BSUB -n 20                       #Request 40 cores
#BSUB -R "span[ptile=20]"         #Request 20 cores per node.
#BSUB -R "rusage[mem=2560]"       #Request 2560MB per process (CPU) for the job
#BSUB -M 2560                     #Set the per process enforceable memory limit to 2560MB.
#BSUB -o  /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/whole_qiimeout.%J
#BSUB -e  /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/whole_qiimerr.%J

#First Executable Line
module load Anaconda/3-5.0.0.1
source activate qiime2-2018.2
module load R_tamu/3.4.2-intel-2017A-Python-2.7.12-default-mt
#========= DADA2 =========
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux.qza \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-trunc-len-f 244 \
  --p-trunc-len-r 244 \
  --o-table table_untrimmed.qza \
  --o-representative-sequences rep-seqs_untrimmed.qza \
  --p-n-threads 0
#=============FEATURE TABLE SUMMARIZE=================
qiime feature-table summarize \
  --i-table /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/table.qza \
  --o-visualization /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/table.qzv \
  --m-sample-metadata-file /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/sample-metadata.tsv

qiime feature-table tabulate-seqs \
  --i-data /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/rep-seqs.qza \
  --o-visualization /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/rep-seqs.qzv\