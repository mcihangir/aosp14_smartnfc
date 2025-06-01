#!/bin/bash



LOGROOT=/home/mcihangir/workspace/qcm2290_4290_android14.0_ba04_r001/QSSI.14/device/empa/smartnfc/tools/bootchart_logs
TARBALL=bootchart.tgz
TMPDIR=/home/mcihangir/workspace/qcm2290_4290_android14.0_ba04_r001/QSSI.14/device/empa/smartnfc/tools/bootchart_output

rm -rf "$TMPDIR"
mkdir -p "$TMPDIR"

FILES="header proc_stat.log proc_ps.log proc_diskstats.log"

for f in $FILES; do
    cp $LOGROOT/$f $TMPDIR/$f 2>&1 > /dev/null
done
(cd $TMPDIR && tar -czf $TARBALL $FILES)
pybootchartgui ${TMPDIR}/${TARBALL}
xdg-open ${TARBALL%.tgz}.png
echo "Clean up ${TMPDIR}/ and ./${TARBALL%.tgz}.png when done"

