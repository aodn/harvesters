<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:talendfile="platform:/resource/org.talend.model/model/TalendFile.xsd"
    exclude-result-prefixes="xs"
    version="1.0">

    <xsl:param name="sourceRepositoryContextId"/>

    <!-- Default action is to copy node -->

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Add base and fileList parameters to existing source parameters -->

    <xsl:template match="*[local-name(.)='context'][*[local-name(.)='contextParameter'][@name='url' or @name='sourceDir']]
        [not(*[local-name(.)='contextParameter' and @name='base'])]">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <xsl:element namespace="{namespace-uri()}" name="contextParameter">
                <xsl:attribute name="comment"/>
                <xsl:attribute name="name">base</xsl:attribute>
                <xsl:attribute name="prompt">base?</xsl:attribute>
                <xsl:attribute name="promptNeeded">false</xsl:attribute>
                <xsl:attribute name="repositoryContextId"><xsl:value-of select="$sourceRepositoryContextId"/></xsl:attribute>
                <xsl:attribute name="type">id_String</xsl:attribute>
                <xsl:attribute name="value"/>
            </xsl:element>
            <xsl:if test="*[local-name(.)='contextParameter'][@name='sourceDir']">
                <xsl:element namespace="{namespace-uri()}" name="contextParameter">
                    <xsl:attribute name="comment"/>
                    <xsl:attribute name="name">fileList</xsl:attribute>
                    <xsl:attribute name="prompt">fileList?</xsl:attribute>
                    <xsl:attribute name="promptNeeded">false</xsl:attribute>
                    <xsl:attribute name="repositoryContextId"><xsl:value-of select="$sourceRepositoryContextId"/></xsl:attribute>
                    <xsl:attribute name="type">id_String</xsl:attribute>
                    <xsl:attribute name="value">/tmp/fileList</xsl:attribute>
                </xsl:element>
            </xsl:if>
        </xsl:copy>
    </xsl:template>

    <!-- Remove old source context parameters if present -->

    <xsl:template match="*[local-name(.)='contextParameter'][@name='sourceDir' or @name='include' or @name='exclude']"/>

    <!-- Add die on error parameter to ixxxFileList components -->

    <xsl:template match="*[local-name()='node'][starts-with(@componentName, 'i') and contains(@componentName, 'FileList')]
        [not(*[local-name()='elementParameter' and @name='DIE_ON_ERROR'])]">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <xsl:element namespace="{namespace-uri()}" name="elementParameter">
                <xsl:attribute name="field">CHECK</xsl:attribute>
                <xsl:attribute name="name">DIE_ON_ERROR</xsl:attribute>
                <xsl:attribute name="value">true</xsl:attribute>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <!-- add new iUpdateIndex parameters  -->

    <xsl:template match="*[local-name()='node'][@componentName='iUpdateIndex'][not(*[local-name()='elementParameter' and @name='MANIFEST_FILENAME'])]">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <xsl:element namespace="{namespace-uri()}" name="elementParameter">
                <xsl:attribute name="field">FILE</xsl:attribute>
                <xsl:attribute name="name">MANIFEST_FILENAME</xsl:attribute>
                <xsl:attribute name="value">context.fileList</xsl:attribute>
            </xsl:element>
            <xsl:element namespace="{namespace-uri()}" name="elementParameter">
                <xsl:attribute name="field">TEXT</xsl:attribute>
                <xsl:attribute name="name">BASE_PATH</xsl:attribute>
                <xsl:attribute name="value">context.base</xsl:attribute>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <!-- remove old iIndexFiles parameters -->

    <xsl:template match="*[local-name()='node'][@componentName='iUpdateIndex']/*[local-name()='elementParameter']
        [@name='LIST_MODE' or 
         @name='DIRECTORY' or 
         @name='INCLUDSUBDIR' or 
         @name='CASE_SENSITIVE' or 
         @name='ERROR' or
         @name='GLOBEXPRESSIONS' or
         @name='FILES' or
         @name='IFEXCLUDE' or
         @name='EXCLUDEFILEMASK' or
         @name='FORMAT_FILEPATH_TO_SLASH' or
         @name='ORDER_BY_NOTHING' or
         @name='ORDER_BY_FILENAME' or
         @name='ORDER_BY_FILESIZE' or
         @name='ORDER_BY_MODIFIEDDATE' or
         @name='ORDER_ACTION_ASC' or
         @name='ORDER_ACTION_DESC'
         ]"/>

    <!-- remove old iIndexFiles metadata connector (yay!) -->
    
    <xsl:template match="*[local-name()='node'][@componentName='iUpdateIndex']/*[local-name()='metadata' and @connector='FLOW']"/>

    <!-- change references to context.url to context.url + "/" + context.base in component parameter values -->
    
    <xsl:template match="*[local-name()='elementParameter' and contains(@value, 'context.url') and not(contains(@value, 'context.base'))]/@value">
        <xsl:attribute name="value">
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="."/>
                <xsl:with-param name="replace" select="'context.url'"/>
                <xsl:with-param name="by" select="'context.url + &quot;/&quot; + context.base'"/>
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template name="string-replace-all">
        <xsl:param name="text"/>
        <xsl:param name="replace"/>
        <xsl:param name="by"/>
        <xsl:choose>
            <xsl:when test="contains($text,$replace)">
                <xsl:value-of select="substring-before($text,$replace)"/>
                <xsl:value-of select="$by"/>
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="substring-after($text,$replace)"/>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="by" select="$by"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
