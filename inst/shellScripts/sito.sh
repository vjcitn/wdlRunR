Rscript -e "library(VariantAnnotation); library(ldblock); \
    p1 = ScanVcfParam(which=GRanges('17', IRanges($1, $2))); \
    saveRDS(rowRanges(readVcf(s3_1kg(17), param=p1)), $3)"
