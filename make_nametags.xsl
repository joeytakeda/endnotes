<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs"
    xmlns:jt="http://joeytakeda.github.io/ns/"
    version="2.0">
    
    
    <!-- 1 = timestamp
         2 = Name
         3 = -->
    
    <xsl:attribute-set name="center">
        <xsl:attribute name="display" select="'center'"/>
        <xsl:attribute name="text-align" select="'center'"/>
        <xsl:attribute name="vertical-align" select="'middle'"/>
    </xsl:attribute-set>
    
    <xsl:template match="/">
        <root font-family="CormorantGaramond">
            <layout-master-set>
                <!--Has to be in landscape-->
                <simple-page-master margin-bottom=".5in" margin-left="1in"
                    margin-right="1in" margin-top=".5in" master-name="Nametags"
                    page-height="8.5in" page-width="11in">
                    <region-body margin-bottom="0" margin-left="0" margin-right="0"
                        margin-top="0"/>
                </simple-page-master>
            </layout-master-set>
            
            
            <page-sequence master-reference="Nametags">
                <flow flow-name="xsl-region-body">
                    <xsl:apply-templates select="//table"/>
                </flow>
            </page-sequence>
        </root>
    </xsl:template>
    
    <xsl:template match="table">
        <xsl:variable name="rows" select="//tr[position() gt 2]"/>
        <block>
            <table border="0.1pt dashed grey" text-align="center" table-layout="fixed">
                <table-column column-width="4in" />
                <table-column column-width="4in"/>
                <table-column column-width="4in"/>
                <table-body>
                    <xsl:apply-templates select="$rows"/>
                </table-body>
            </table>
        </block>
    </xsl:template>
    
    <!--Taken, with thanks, from the Oxygen resource forum-->
    <xsl:template match="tr[position() mod 2 = 1]">
       
        <table-row height="3in">
            <xsl:call-template name="makeTag">
                <xsl:with-param name="row" select="."/>
            </xsl:call-template>
            <xsl:if test="not(empty(following-sibling::tr[1]))">
                <xsl:call-template name="makeTag">
                    <xsl:with-param name="row" select="following-sibling::tr[1]"/>
                </xsl:call-template>
            </xsl:if>
        </table-row>
        
    </xsl:template>
    
    <!--Supress-->
    <xsl:template match="tr[position() mod 2 = 0]"/>
    
    <xsl:template name="makeTag">
        <xsl:param name="row"/>
        <xsl:variable name="name" select="$row/td[2]"/>
        <xsl:variable name="inst" select="$row/td[3]"/>
        <xsl:variable name="nameLength" select="string-length($name)"/>
        <table-cell border="0.1pt dashed grey">
            <!--Name content-->
            <block-container 
                display-align="center" 
                text-align="center"
                vertical-align="middle"
                padding-bottom=".4em"
                margin-top=".6in"
                height="1.2in">
                <block display-align="center" font-size="{if ($nameLength lt 19) then '30' else '24'}pt" font-weight="bold"><xsl:value-of select="$name"/></block>
                <block font-size="{if (string-length($inst) lt 45) then 15 else 13}pt" absolute-position="absolute" margin-top=".2em"><xsl:value-of select="$inst"/></block>
                <block font-size="16pt" margin-top=".3em">Pronouns: <xsl:value-of select="$row/td[4]"/></block>
            </block-container>
            <!--Trailer block-->
            <block-container
                margin-bottom="0"
                margin-top=".14in"
                margin-left=".15in"
                margin-right=".05in">
                        <table>
                        <table-column column-number="2" width="100%"/>
                        <table-body>
                            <table-row>
                                <table-cell width=".9in" text-align="right">
                                    <block text-align="right" margin-left=".4in" margin-right=".07in">
                                        <external-graphic src="../endnotes-logo.png" content-width="scale-to-fit" height=".6in"  scaling="uniform"/>
                                    </block>
                                </table-cell>
                                <table-cell border-left=".8pt solid black">
                                    <block-container font-size="12pt" width="100%" text-align="left" margin-left=".07in" font-style="italic" margin-top=".01in" font-family="CormorantGaramond-SB">
                                        <block>On the Edge</block>
                                        <block>Borders, Boundaries, and Thresholds</block>
                                        <block>Endnotes 2017</block>
                                    </block-container>
                                    </table-cell>
                            </table-row>
       
                        </table-body>
                    </table>
<!--                <block-container display-align="after" margin-top="1em">
                   
                </block-container>-->
            </block-container>
          <!--  <block margin-top=".1in" font-size="10pt">May 12-13, 2017. Dept. of English. University of British Columbia</block>-->
        </table-cell>
        
    </xsl:template>

</xsl:stylesheet>