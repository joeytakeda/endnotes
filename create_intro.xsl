<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:jt="http://joeytakeda.github.io/ns/"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    version="2.0">
    
    <xsl:template name="createIntroPdf">
        <xsl:result-document href="intro.fo">
            <fo:root font-family="CormorantGaramond">
                
                <layout-master-set>
                    <simple-page-master margin-bottom="1in"
                        margin-left="1in" margin-right="1in"
                        margin-top=".75in" master-name="Intro"
                        page-height="11in" page-width="8.5in">
                        <fo:region-body region-name="xsl-region-body"/>
                    </simple-page-master>
                    
                </layout-master-set>
                
                
                <page-sequence master-reference="Intro">
                    <flow flow-name="xsl-region-body">
                        
                        <block font-size="28pt" text-align="center">Introduction</block>
                        
                        <xsl:call-template name="createIntroBody"/>
                        
                        
                    </flow>
                </page-sequence>
            </fo:root>
        </xsl:result-document> 
     
    </xsl:template>
    
    <xsl:template name="createIntroBody">
        <block-container line-height="1.5" margin-top="1.5em">
            <xsl:apply-templates select="$intro//body" mode="pdf"/>
        </block-container>
    </xsl:template>
    
   
</xsl:stylesheet>