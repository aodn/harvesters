$fileDir = Split-Path -Parent $MyInvocation.MyCommand.Path
cd $fileDir
java '-Dtalend.component.manager.m2.repository=%cd%/../lib' '-Xms256M' '-Xmx1024M' -cp '.;../lib/routines.jar;../lib/dom4j-1.6.1.jar;../lib/gt-api-8.5.jar;../lib/gt-xsd-core-8.5.jar;../lib/gt-xsd-gml3-8.5.jar;../lib/jts-1.12.jar;../lib/log4j-1.2.17.jar;../lib/org.talend.sdi.jar;../lib/postgresql-42.2.5.jar;../lib/talend_file_enhanced_20070724.jar;../lib/talendcsv.jar;deletemetadatafile_0_1.jar;' aodn_wave.deletemetadatafile_0_1.DeleteMetadataFile  %*