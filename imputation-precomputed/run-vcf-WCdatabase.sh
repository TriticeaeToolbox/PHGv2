WORKING_DIR=/data2/phg2
docker run --name pipeline_container --rm \
        -v ${WORKING_DIR}/tempFileDir:/phg/ \
        -v ${WORKING_DIR}/tempFileDir:/tempFileDir \
        -v ${WORKING_DIR}/tempFileDir/outputDir:/tempFileDir/outputDir \
        -t maizegenetics/phg:0.0.40 \
        /tassel-5-standalone/run_pipeline.pl -Xmx100G -debug -configParameters /phg/data/WC65_vcf_config.txt \
	-HaplotypeGraphBuilderPlugin -configFile /phg/data/WC65_vcf_config.txt -methods CONSENSUS470 \
		-includeVariantContexts true -includeSequences false -endPlugin \
	-ImportDiploidPathPlugin -pathMethodName CONSENSUS -endPlugin \
        -PathsToVCFPlugin -outputFile WC400-all.vcf -endPlugin

