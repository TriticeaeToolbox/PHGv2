WORKING_DIR=/data2/phg2
docker run --name create_directory --rm \
        -v ${WORKING_DIR}/tempFileDir:/phg/ \
        -v ${WORKING_DIR}/tempFileDir:/tempFileDir \
        -v ${WORKING_DIR}/tempFileDir/outputDir:/tempFileDir/outputDir \
        -t maizegenetics/phg:0.0.40 \
        /tassel-5-standalone/run_pipeline.pl -debug -configParameters /phg/data/WC65config.txt \
        -CheckDBVersionPlugin -outputDir /phg/outputDir -endPlugin \
        -LiquibaseUpdatePlugin -outputDir /phg/outputDir -endPlugin
