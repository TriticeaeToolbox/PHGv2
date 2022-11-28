WORKING_DIR=/data2/phg2
docker run -i \
        -v ${WORKING_DIR}/tempFileDir:/phg/ \
        -v ${WORKING_DIR}/tempFileDir:/tempFileDir \
        -v ${WORKING_DIR}/tempFileDir/outputDir:/tempFileDir/outputDir \
        -t maizegenetics/phg:0.0.40
