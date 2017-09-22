<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:en="http://www.endnotes2017.wordpress.com"
    xpath-default-namespace="http://www.w3.org/1999/XSL/Format"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:variable name="foDocCollection" select="collection('temp/?select=*.fo')"/>
    
    <xsl:key name="id-to-person" match="block-container[@id]" use="@id"/>
    <xsl:output indent="no"/>
    
    <xsl:template match="/">
        <xsl:for-each select="$foDocCollection">
            <xsl:variable name="thisDocName" select="substring-before(tokenize(document-uri(.),'/')[last()],'.fo')"/>
            <xsl:result-document href="../products/wordpress/{$thisDocName}.html">
                <xsl:message>Creating HTML page for <xsl:value-of select="$thisDocName"/></xsl:message>
                <xsl:apply-templates select="//root" mode="html"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="root" mode="html">
        <html>
            <xsl:apply-templates mode="#current"/>
        </html>
    </xsl:template>
    
    <xsl:template match="block-container" mode="html">
        <div>
            <xsl:copy-of select="@id"/>
            <xsl:copy-of select="en:processAttributes(@*)"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="block" mode="html">
        <p>
            <xsl:copy-of select="en:processAttributes(@*)"/>
            <xsl:apply-templates mode="#current"/>
        </p>
    </xsl:template>
    
    <xsl:template match="inline" mode="html">
        <span>
            <xsl:copy-of select="en:processAttributes(@*)"/>
            
            <xsl:choose>
                <xsl:when test="@id">
                    <xsl:variable name="thisId" select="@id"/>
                    <xsl:choose>
                        <xsl:when test="starts-with($thisId,'person_')">
                            <xsl:variable name="idRef" select="substring-after($thisId,'person_')"/>
                            <xsl:variable name="personFound" select="$foDocCollection//root/key('id-to-person',$idRef)"/>
                            <xsl:choose>
                                <xsl:when test="$personFound">
                                <a href="bios/#{$idRef}" target="_blank"  title="{substring-after(normalize-space(string-join($personFound[1]/block-container/block[4]/descendant::text(),'')),'Bio: ')}">
                                    <xsl:apply-templates mode="#current"/>
                                </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:message>No id found for <xsl:value-of select="$idRef"/></xsl:message>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="starts-with($thisId,'keynote')">
                            <xsl:variable name="thisK" select="substring-after($thisId,'_')"/>
                            <a href="keynotes/#{$thisK}" target="_blank">
                                <xsl:apply-templates mode="#current"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates mode="#current"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="#current"/>
                </xsl:otherwise>
            </xsl:choose>
           
        </span>
    </xsl:template>
    
    <xsl:template match="leader" mode="html">
        <hr>
            <xsl:copy-of select="en:processAttributes(@*)"/>
        </hr>
    </xsl:template>
    
    <!--Fix errant extra spaces-->
    <xsl:template match="text()" mode="html">
        <xsl:value-of select="replace(replace(.,'\s+',' '),'\s\)',')')"/>
    </xsl:template>

    
    <xsl:function name="en:processAttributes" as="attribute(style)?">
        <xsl:param name="atts" as="attribute()*"/>
        <xsl:variable name="attVal" as="xs:string*">
            <xsl:for-each select="$atts">
                <xsl:variable name="thisAttName" select="local-name(.)"/>
                <!--Don't want font-family attributes added-->
                <xsl:if test="not($thisAttName = 'font-family')">
                    <xsl:if test="starts-with($thisAttName,'margin') or starts-with($thisAttName,'padding') or starts-with($thisAttName,'font-') or starts-with($thisAttName,'text-')">
                        <xsl:value-of select="concat($thisAttName,':', .,';')"/>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$thisAttName='leader-length'">
                    <xsl:value-of select="concat('width:',.,';')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="not(empty($attVal))">
            <xsl:attribute name="style" select="string-join($attVal,' ')"/>
        </xsl:if>
    
  
    </xsl:function>
    
</xsl:stylesheet>