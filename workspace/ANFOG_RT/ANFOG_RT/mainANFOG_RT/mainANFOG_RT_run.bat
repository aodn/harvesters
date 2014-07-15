%~d0
 cd %~dp0
java -Xms256M -Xmx1024M -cp classpath.jar; anfog_dm.mainanfog_rt_0_1.mainANFOG_RT --context=Default %* 