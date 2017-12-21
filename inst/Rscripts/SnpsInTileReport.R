# SnpsInTileReport.R
# This R program defines a WDL program in the R character
# variable 'snps_wdl'.  The WDL recognizes two parameters,
# start and end, base addresses on chr17 to define an interval
# to be queried for SNP in 1000 genomes VCF in S3.
#
# snps_wdl_tmpl is a template which will be modified to
# include an absolute path to a shell script that will invoke
# R to perform the SNP query
snps_wdl_tmpl = "task SnpsInTileReport {
  Float start
  Float end
  command {
    sh %s ${start} ${end}
  }
  output {
    File response = stdout()
  }
}
workflow CollectSnps {
  call SnpsInTileReport
}"
#
# this particular WDL will just capture the textual report as output
# by VariantAnnotation::readVcf
#
snps_wdl = sprintf(snps_wdl_tmpl, system.file("shellScripts/sitr.sh", package="wdlRunR"))
#
# wdlRunR passes program parameters as a data.frame.  Column names
# are of the form [workflowName].[taskName].[parameterName]
#
mydf = data.frame(CollectSnps.SnpsInTileReport.start=c(39e6,39.025e6),
   CollectSnps.SnpsInTileReport.end=c(39.025e6, 39.05e6))
#
library(wdlRunR)
res = cromwellBatch(wdlSource = snps_wdl, workflowInputs = mydf )

