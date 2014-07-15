cd `dirname $0`
 ROOT_PATH=`pwd`
java -Xms256M -Xmx1024M -cp classpath.jar: anfog_dm.dataharvest_rt_0_1.DataHarvest_RT --context=Default "$@" 