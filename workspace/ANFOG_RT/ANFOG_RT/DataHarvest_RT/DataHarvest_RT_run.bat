%~d0
 cd %~dp0
java -Xms256M -Xmx1024M -cp classpath.jar; anfog_dm.dataharvest_rt_0_1.DataHarvest_RT --context=Default %* 