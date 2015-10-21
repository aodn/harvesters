<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:talendfile="platform:/resource/org.talend.model/model/TalendFile.xsd"
    exclude-result-prefixes="xs"
    version="1.0">

    <!-- default action is to copy node -->

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- add base and fileList parameters to existing source parameters -->

    <xsl:template match="talendfile:ContextType[contextParameter[@name='sourceDir']]">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <contextParameter comment="" name="base" prompt="base?" promptNeeded="false" type="id_String" value=""/>
            <contextParameter comment="" name="fileList" prompt="fileList?" promptNeeded="false" type="id_String" value="/tmp/fileList"/>
        </xsl:copy>
    </xsl:template>

    <!-- remove old source context parameters if present -->

    <xsl:template match="talendfile:ContextType/contextParameter[@name='sourceDir' or @name='include' or @name='exclude']"/>
</xsl:stylesheet>
