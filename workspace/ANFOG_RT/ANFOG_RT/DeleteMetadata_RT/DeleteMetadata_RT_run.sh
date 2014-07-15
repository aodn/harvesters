cd `dirname $0`
 ROOT_PATH=`pwd`
java -Xms256M -Xmx1024M -cp classpath.jar: anfog_dm.deletemetadata_rt_0_1.DeleteMetadata_RT --context=Default "$@" 