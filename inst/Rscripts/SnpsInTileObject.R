# SnpsInTileObject.R
# This R program defines a WDL program in the R character
# variable 'snps_wdl'.  The WDL recognizes three parameters,
# 'start' and 'end' and 'outpath'.  'start' and 'end' are base 
# addresses on chr17 to define an interval
# to be queried for SNP in 1000 genomes VCF in S3.
# 'outpath' is the local name of an RDS file to be generated with
# the result of readVCF
#
# snps_wdl_tmpl is a template which will be modified to
# include an absolute path to a shell script that will invoke
# R to perform the SNP query
snps_wdl_tmpl = "task SnpsInTileObject {
  Float start
  Float end
  String outpath
  command {
    sh %s ${start} ${end} ${outpath}
  }
  output {
    File response = stdout()
  }
}
workflow CollectSnps {
  call SnpsInTileObject
}"
#
# this particular WDL will export as RDS the output of
# VariantAnnotation::readVcf
#
snps_wdl = sprintf(snps_wdl_tmpl, system.file("shellScripts/sito.sh", package="wdlRunR"))
#
# wdlRunR passes program parameters as a data.frame.  Column names
# are of the form [workflowName].[taskName].[parameterName]
#
mydf = data.frame(CollectSnps.SnpsInTileObject.start=c(39e6,39.025e6),
   CollectSnps.SnpsInTileObject.end=c(39.025e6, 39.05e6), CollectSnps.SnpsInTileObject.outpath=c("\\\'tile1.rds\\\'", "\\\'tile2.rds\\\'"), stringsAsFactors=FALSE)
#
library(wdlRunR)
res = cromwellBatch(wdlSource = snps_wdl, workflowInputs = mydf )
#
# eventually cromwellQuery will tell the status of these jobs
# and provide paths to outputs

