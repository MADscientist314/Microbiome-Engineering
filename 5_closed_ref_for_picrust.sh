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

#=================QIIME TOOLS IMPORT===========================
qiime tools import \
--input-path /scratch/datasets/greengenes_release/gg_13_5/gg_13_8_otus/rep_set/99_otus.fasta \
--output-path /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/gg_13_5_otu_99.qza \
--type 'FeatureData[Sequence]' \

#============= CLOSED REF FOR PICRUST ======================
qiime vsearch cluster-features-closed-reference \
--i-sequences /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/rep-seqs.qza \
--i-table /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/table.qza \
--i-reference-sequences /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/gg_13_5_otu_99.qza \
--p-perc-identity 0.97 \
--output-dir /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/closedRef_forPIcrust99

