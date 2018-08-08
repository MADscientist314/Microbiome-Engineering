#BSUB -J whole_jochum_qiime2         #Set the job name to "ExampleJob3"
#BSUB -L /bin/bash                #Uses the bash login shell to initialize the job's execution environment.
#BSUB -W 2:00                     #Set the wall clock limit to 24hr
#BSUB -n 40                       #Request 40 cores
#BSUB -R "span[ptile=20]"         #Request 20 cores per node.
#BSUB -R "rusage[mem=2560]"       #Request 2560MB per process (CPU) for the job
#BSUB -M 2560                     #Set the per process enforceable memory limit to 2560MB.
#BSUB -o whole_qiimeout.%J              #Send stdout and stderr to "Example3Out.[jobID]"
#BSUB -e whole_qiimerr.%J

#First Executable Line
module load Anaconda/3-5.0.0.1
source activate qiime2-2018.2
module load R_tamu/3.4.2-intel-2017A-Python-2.7.12-default-mt

qiime alignment mafft \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza

qiime alignment mask \
  --i-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza

qiime phylogeny fasttree \
  --i-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza

qiime phylogeny midpoint-root \
  --i-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza

qiime diversity core-metrics-phylogenetic --i-phylogeny rooted-tree.qza --i-table table.qza --p-sampling-depth 1109 --m-metadata-file sample-metadata.tsv --output-dir ./core-metrics-results

qiime diversity alpha-group-significance --i-alpha-diversity ./core-metrics-results/faith_pd_vector.qza --m-metadata-file sample-metadata.tsv --o-visualization ./core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance --i-alpha-diversity ./core-metrics-results/faith_pd_vector.qza --m-metadata-file sample-metadata.tsv --o-visualization ./core-metrics-results/evenness-group-significance.qzv

qiime diversity beta-group-significance --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza --m-metadata-file sample-metadata.tsv --m-metadata-column Subject --o-visualization ./core-metrics-results/unweighted-unifrac-round-significance.qzv --p-pairwise

qiime emperor plot \
  --i-pcoa core-metrics-results/unweighted_unifrac_pcoa_results.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-custom-axes Round \
  --o-visualization ./core-metrics-results/unweighted-unifrac-emperor-Round.qzv

qiime emperor plot \
  --i-pcoa core-metrics-results/bray_curtis_pcoa_results.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-custom-axes DaysSinceExperimentStart \
  --o-visualization ./core-metrics-results/bray-curtis-emperor-DaysSinceExperimentStart.qzv
qiime diversity alpha-rarefaction \
  --i-table table.qza \
  --i-phylogeny rooted-tree.qza \
  --p-max-depth 4000 \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization ./alpha-rarefaction.qzv

