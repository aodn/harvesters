%~d0
 cd %~dp0
java -Xms256M -Xmx1024M -cp classpath.jar; anfog_dm.harvestmetadatafilesystem_rt_0_1.HarvestMetadataFileSystem_RT --context=Default %* 