#!/bin/bash

CMD_DIR=`dirname $0`
TARGET_DIR=${1:-.}
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

SOURCE_REPO_ID=$(xsltproc $CMD_DIR/get-source-context-repository-id.xsl $TARGET_DIR/context/[Ss]ource_*.properties)

[ "$SOURCE_REPO_ID" ] || (echo "Could not determine source context repository id" && exit 1)

SOURCE_CONTEXT=$(find $TARGET_DIR/context -name [Ss]ource_*.item)
xsltproc $CMD_DIR/update-source-context.xsl $SOURCE_CONTEXT | xmllint --format - > $TEMP_DIR/temp.item
cp $TEMP_DIR/temp.item $SOURCE_CONTEXT

for process_item in $(find $TARGET_DIR/process -name *.item); do
    sed -e 's/iIndexFiles/iUpdateIndex/g' \
        -e 's/iNewresources/iNewFileList/g' \
        -e 's/iModifiedResources/iModifiedFileList/g' \
        -e 's/iDeletedResources/iDeletedFileList/g' \
        -e 's/iHarvestResources/iNewOrModifiedFileList/g' $process_item | \
        xsltproc --stringparam sourceRepositoryContextId "$SOURCE_REPO_ID" $CMD_DIR/update-process-item.xsl - | \
        xmllint --format - > $TEMP_DIR/temp.item
    cp $TEMP_DIR/temp.item $process_item
done

