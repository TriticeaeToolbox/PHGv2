/tassel-5-standalone/run_pipeline.pl -Xmx100G -debug -configParameters /phg/data/WC65_vcf_imputation_90K_config.txt \
        -ImputePipelinePlugin -imputeTarget pathToVCF -endPlugin > /phg/data/WC65_impute01.log

The -configParameters file specifies the input and output files for the analysis. The lines that change with each run of the imputation are
        vcfFile=                #input file
        readMethod=             #change this name for new samples
        pathMethod=             #change this name for new samples
        outVcfFile=             #output file for imputed sequence
