%~d0
 cd %~dp0
java -Xms256M -Xmx1024M -cp classpath.jar; anfog_dm.createwms_rt_0_1.CreateWMS_RT --context=Default %* 