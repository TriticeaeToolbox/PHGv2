WORKING_DIR=/data2/phg2
docker run --name pipeline_container --rm \
        -v ${WORKING_DIR}/tempFileDir:/phg/ \
        -v ${WORKING_DIR}/tempFileDir:/tempFileDir \
        -v ${WORKING_DIR}/tempFileDir/outputDir:/tempFileDir/outputDir \
        -t maizegenetics/phg:0.0.40 \
        /tassel-5-standalone/run_pipeline.pl -Xmx100G -debug -configParameters /phg/data/WC65_vcf_imputation_90K_config.txt \
	-HaplotypeGraphBuilderPlugin -configFile /phg/data/WC65_vcf_imputation_90K_config.txt -methods CONSENSUS \
		-includeVariantContexts true -includeSequences false -endPlugin \
	-ImportDiploidPathPlugin -pathMethodName 90Kin2019hapmap-path3 -endPlugin \
        -PathsToVCFHaplotypesPlugin -outputFile /phg/outputDir/WC400-all.vcf -endPlugin

