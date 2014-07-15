%~d0
 cd %~dp0
java -Xms256M -Xmx1024M -cp classpath.jar; anfog_dm.deletemetadata_rt_0_1.DeleteMetadata_RT --context=Default %* 