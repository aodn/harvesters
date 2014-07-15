%~d0
 cd %~dp0
java -Xms256M -Xmx1024M -cp classpath.jar; anfog_dm.harvestfilesystemmetadata_rt_0_1.HarvestFileSystemMetadata_RT --context=Default %* 