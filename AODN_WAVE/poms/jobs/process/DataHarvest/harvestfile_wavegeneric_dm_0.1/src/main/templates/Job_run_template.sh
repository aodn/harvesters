#!/bin/sh
cd `dirname $0`
ROOT_PATH=`pwd`
java -Dtalend.component.manager.m2.repository=$ROOT_PATH/../lib -Xms256M -Xmx1024M -cp .:$ROOT_PATH:$ROOT_PATH/../lib/routines.jar:$ROOT_PATH/../lib/common-2.6.0.jar:$ROOT_PATH/../lib/commons-beanutils-1.7.0.jar:$ROOT_PATH/../lib/commons-cli-2.0-gt2-pre1.jar:$ROOT_PATH/../lib/commons-codec-1.2.jar:$ROOT_PATH/../lib/commons-collections-3.1.jar:$ROOT_PATH/../lib/commons-dbcp-1.3.jar:$ROOT_PATH/../lib/commons-httpclient-3.1.jar:$ROOT_PATH/../lib/commons-io-2.1.jar:$ROOT_PATH/../lib/commons-jxpath-1.3.jar:$ROOT_PATH/../lib/commons-lang-2.3.jar:$ROOT_PATH/../lib/commons-logging-1.1.1.jar:$ROOT_PATH/../lib/commons-pool-1.5.4.jar:$ROOT_PATH/../lib/dom4j-1.6.1.jar:$ROOT_PATH/../lib/ecore-2.6.1.jar:$ROOT_PATH/../lib/gt-api-8.5.jar:$ROOT_PATH/../lib/gt-cql-8.5.jar:$ROOT_PATH/../lib/gt-data-8.5.jar:$ROOT_PATH/../lib/gt-epsg-hsql-8.5.jar:$ROOT_PATH/../lib/gt-epsg-wkt-8.5.jar:$ROOT_PATH/../lib/gt-jdbc-8.5.jar:$ROOT_PATH/../lib/gt-jdbc-postgis-8.5.jar:$ROOT_PATH/../lib/gt-main-8.5.jar:$ROOT_PATH/../lib/gt-metadata-8.5.jar:$ROOT_PATH/../lib/gt-opengis-8.5.jar:$ROOT_PATH/../lib/gt-referencing-8.5.jar:$ROOT_PATH/../lib/gt-referencing3D-8.5.jar:$ROOT_PATH/../lib/gt-shapefile-8.5.jar:$ROOT_PATH/../lib/gt-shapefile-renderer-8.5.jar:$ROOT_PATH/../lib/gt-validation-8.5.jar:$ROOT_PATH/../lib/gt-wfs-8.5.jar:$ROOT_PATH/../lib/gt-xml-8.5.jar:$ROOT_PATH/../lib/gt-xsd-core-8.5.jar:$ROOT_PATH/../lib/gt-xsd-filter-8.5.jar:$ROOT_PATH/../lib/gt-xsd-gml2-8.5.jar:$ROOT_PATH/../lib/gt-xsd-gml3-8.5.jar:$ROOT_PATH/../lib/gt-xsd-kml-8.5.jar:$ROOT_PATH/../lib/gt-xsd-ows-8.5.jar:$ROOT_PATH/../lib/gt-xsd-sld-8.5.jar:$ROOT_PATH/../lib/gt-xsd-wfs-8.5.jar:$ROOT_PATH/../lib/gt-xsd-wps-8.5.jar:$ROOT_PATH/../lib/hsqldb-1.8.0.7.jar:$ROOT_PATH/../lib/iNetCDFInput-1.0.0-SNAPSHOT.jar:$ROOT_PATH/../lib/jai_codec-1.1.3.jar:$ROOT_PATH/../lib/jai_core-1.1.3.jar:$ROOT_PATH/../lib/jdom-1.0.jar:$ROOT_PATH/../lib/jgridshift-1.0.jar:$ROOT_PATH/../lib/jsr-275-1.0-beta-2.jar:$ROOT_PATH/../lib/jts-1.12.jar:$ROOT_PATH/../lib/log4j-1.2.17.jar:$ROOT_PATH/../lib/net.opengis.ows-8.5.jar:$ROOT_PATH/../lib/net.opengis.wfs-8.5.jar:$ROOT_PATH/../lib/netcdf-iterator-1.0.0-SNAPSHOT.jar:$ROOT_PATH/../lib/netcdfAll-4.6.4.jar:$ROOT_PATH/../lib/org.talend.sdi.jar:$ROOT_PATH/../lib/org.w3.xlink-8.5.jar:$ROOT_PATH/../lib/picocontainer-1.2.jar:$ROOT_PATH/../lib/postgis-jdbc-2.1.0SVN.jar:$ROOT_PATH/../lib/postgresql-42.2.5.jar:$ROOT_PATH/../lib/talendcsv.jar:$ROOT_PATH/../lib/vecmath-1.3.2.jar:$ROOT_PATH/../lib/xercesImpl-2.7.1.jar:$ROOT_PATH/../lib/xml-apis-xerces-2.7.1.jar:$ROOT_PATH/../lib/xpp3_min-1.1.4c.jar:$ROOT_PATH/../lib/xsd-2.6.0.jar:$ROOT_PATH/harvestfile_wavegeneric_dm_0_1.jar: aodn_wave.harvestfile_wavegeneric_dm_0_1.HarvestFile_WaveGeneric_DM  "$@"