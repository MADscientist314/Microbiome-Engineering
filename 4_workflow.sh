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
#qiime dada2 denoise-paired \
#  --i-demultiplexed-seqs demux.qza \
#  --p-trim-left-f 0 \
#  --p-trim-left-r 0 \
#  --p-trunc-len-f 244 \
#  --p-trunc-len-r 244 \
#  --o-table table_untrimmed.qza \
#  --o-representative-sequences rep-seqs_untrimmed.qza \
#  --p-n-threads 0
#=============FEATURE TABLE SUMMARIZE=================
#qiime feature-table summarize \
#  --i-table /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/table.qza \
#  --o-visualization /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/table.qzv \
#  --m-sample-metadata-file /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/sample-metadata.tsv

#qiime feature-table tabulate-seqs \
#  --i-data /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/rep-seqs.qza \
#  --o-visualization /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/rep-seqs.qzv\

#=========== GREENGENES FEATURE CLASSIFIER ================
qiime feature-classifier classify-sklearn \
--i-classifier /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/gg-13-8-99-515-806-nb-classifier.qza \
--i-reads  /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/rep-seqs.qza \
--o-classification  /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/gg-13-8-99-taxonomy.qza \
--p-reads-per-batch 0 \
--p-n-jobs -1 \
--p-pre-dispatch 2*n_jobs \
--p-confidence 0.7  \
--verbose \

#================GREENGENES METADATA TABULATE =======================
qiime metadata tabulate \
--m-input-file /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/gg-13-8-99-taxonomy.qza \
--o-visualization /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/gg-13-8-99-taxonomy.qzv \
qiime tools export /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/gg-13-8-99-taxonomy.qzv \
--output-dir /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/ \
#============= GREENGENES TAXA BAR PLOT ======================
qiime taxa barplot \
  --i-table /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/table.qza \
  --i-taxonomy /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/gg-13-8-99-taxonomy.qza \
  --m-metadata-file /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/sample-metadata.tsv \
  --o-visualization /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/gg-13-8-99-tax-bar-plots.qzv

#=================QIIME TOOLS IMPORT===========================
qiime tools import \
--input-path /scratch/datasets/greengenes_release/gg_13_5/gg_13_8_otus/rep_set/99_otus.fasta \
--output-path /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/gg_13_5_otu_99.qza \
--type 'FeatureData[Sequence]' \

#===============GREENGENES TAXA_COLLAPSE================================
for number in 1 2 3 4 5 6 7
do
    qiime taxa collapse \
        --i-table /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/table.qza \
       --i-taxonomy /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/gg-13-8-99-taxonomy.qza \
        --p-level $number \
        --output-dir '/scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/'$number

    qiime tools export '/scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/'$number'/collapsed_table.qza' \
        --output-dir '/scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/'$number
done
#============= CLOSED REF FOR PICRUST ======================
qiime vsearch cluster-features-closed-reference \
--i-sequences /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/rep-seqs.qza \
--i-table /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/table.qza \
--i-reference-sequences /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/gg_13_5_otu_99.qza \
--p-perc-identity 0.97 \
--output-dir /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/greengenes/closedRef_forPIcrust97

#=====================ANCOM DIFF ABUNDANCE==================
qiime composition add-pseudocount \
  --i-table /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/table.qza \
  --o-composition-table /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/comp-table.qza \
qiime composition ancom \
  --i-table /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/comp-table.qza \
  --m-metadata-file /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/sample-metadata.tsv \
  --m-metadata-column Subject \
  --o-visualization /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/18June18/ancom-Subject.qzv