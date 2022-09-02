#!/bin/sh
cd `dirname $0`
ROOT_PATH=`pwd`
java -Dtalend.component.manager.m2.repository=$ROOT_PATH/../lib -Xms256M -Xmx1024M -cp .:$ROOT_PATH:$ROOT_PATH/../lib/routines.jar:$ROOT_PATH/../lib/dom4j-1.6.1.jar:$ROOT_PATH/../lib/gt-api-8.5.jar:$ROOT_PATH/../lib/gt-xsd-core-8.5.jar:$ROOT_PATH/../lib/gt-xsd-gml3-8.5.jar:$ROOT_PATH/../lib/jts-1.12.jar:$ROOT_PATH/../lib/log4j-1.2.17.jar:$ROOT_PATH/../lib/org.talend.sdi.jar:$ROOT_PATH/../lib/postgresql-42.2.5.jar:$ROOT_PATH/../lib/talend_file_enhanced_20070724.jar:$ROOT_PATH/../lib/talendcsv.jar:$ROOT_PATH/deletemetadatafile_0_1.jar: aodn_wave.deletemetadatafile_0_1.DeleteMetadataFile  "$@"