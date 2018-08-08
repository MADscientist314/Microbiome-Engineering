##NECESSARY JOB SPECIFICATIONS
#BSUB -J jochum_qiime         #Set the job name to "ExampleJob3"
#BSUB -L /bin/bash           #Uses the bash login shell to initialize the job's execution environment.
#BSUB -W 24:00               #Set the wall clock limit to 24hr
#BSUB -n 40                  #Request 40 cores
#BSUB -R "span[ptile=20]"    #Request 20 cores per node.
#BSUB -R "rusage[mem=12000]"  #Request 2560MB per process (CPU) for the job
#BSUB -M 12000                #Set the per process enforceable memory limit to 2560MB.
#BSUB -o qout.%J      #Send stdout and stderr to "Example3Out.[jobID]"
#BSUB -e qerr.%J
#First Executable Line

module load Anaconda/3-5.0.0.1
source activate qiime2-2018.2
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path hmme.org \
  --output-path demux.qza \
  --source-format PairedEndFastqManifestPhred33

#qiime tools import \
#--input-path /scratch/datasets/greengenes_release/gg_13_5/gg_13_8_otus/rep_set_aligned/97_otus.fasta \
#--output-path /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/greengenes/gg_aligned_97_otus.qza \
#--type 'FeatureData[Sequence]'\

#qiime tools import \
#--input-path /scratch/datasets/greengenes_release/gg_13_5/gg_13_8_otus/rep_set_aligned/97_otus.fasta \
#--output-path /scratch/group/ykjolab/jochumHMMEqiime/HMME_QIIME/artifacts/greengenes/gg_aligned_97_otus.qza \
#--type 'FeatureData[Sequence]'\
