<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xpath-default-namespace="http://www.w3.org/1999/xhtml"
            xmlns="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs"
            xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:jt="http://joeytakeda.github.io/ns/"
            xmlns:xh="http://www.w3.org/1999/xhtml"
            version="2.0">
           
           <xsl:template name="createBioPdf">

               <xsl:result-document href="bios.fo">
                 
                   <xsl:call-template name="makePdfNoAbs"/>
               </xsl:result-document>
           </xsl:template>
                
    <!--       
           <xsl:template name="makeHtml" exclude-result-prefixes="#all">
                       <!-\-This just needs to be a fragment for Wordpress-\->
                       <!-\-<xsl:result-document href="../products/wordpress/bios.html" method="xml">-\->
                                   <xh:html>
                                               <xh:h1>Presenters: Abstracts and Bios</xh:h1>
                                               <!-\-<p>Download in PDF</p>-\->
                                               <xsl:call-template name="createBiosWP" exclude-result-prefixes="#all"/>
                                   </xh:html>
                                 
                       <!-\-</xsl:result-document>-\->
           </xsl:template>-->
            
            <!--<xsl:template name="createBiosWP" exclude-result-prefixes="#all">
                   <xsl:for-each select="$presenterRows">
                               <xsl:variable name="name" select="td[1]"/>
                               <xsl:variable name="affil" select="td[3]"/>
                               <xsl:variable name="bio" select="td[5]"/>
                               <xsl:variable name="title" select="td[6]"/>
                               <xsl:variable name="abstract" select="td[7]"/>
                               
                       <xh:div>
                           <xh:p><xh:span style="font-weight:bold"><xsl:value-of select="$name"/></xh:span></xh:p>
                           <xh:p><xsl:value-of select="$affil"/></xh:p>
                           <xh:p><xh:span class="font-weight:bold">Bio:</xh:span> <xsl:apply-templates select="$bio"/></xh:p>
                           <xh:div>
                                <xh:p><xh:span class="font-weight:bold">Title: </xh:span><xsl:apply-templates select="$title"/></xh:p>
                                 <xh:p><xsl:apply-templates select="$abstract" mode="html"/></xh:p>
                           </xh:div>
                           
                       </xh:div>
                   </xsl:for-each>
            </xsl:template>-->
            
            
            <xsl:template name="makePdfNoAbs">
                       
                                    <fo:root font-family="CormorantGaramond">
                                                
                                                <layout-master-set>
                                                            <!--Has to be in landscape-->
                                                            <simple-page-master margin-bottom="1in"
                                                                        margin-left="1in" margin-right="1in"
                                                                        margin-top=".75in" master-name="Bios"
                                                                        page-height="11in" page-width="8.5in">
                                                                        <fo:region-body region-name="xsl-region-body"/>
                                                                        
                                                                        <!--<fo:region-after region-name="xsl-region-after" extent=".5in"/>-->
                                                            </simple-page-master>
                                                            
                                                </layout-master-set>
                                                
                                                
                                                <page-sequence master-reference="Bios">
                                                            <!-- <fo:static-content flow-name="xsl-region-after">
                                                            <block background-color="grey"><inline font-size="14pt">Endnotes</inline></block>
                                                </fo:static-content>-->
                                                            <flow flow-name="xsl-region-body">
                                                                        
                                                                        <block font-size="28pt" text-align="center">Presenters</block>
                                                                        
                                                                        <xsl:call-template name="createBiosBody"/>
                                                                                   
                                                                        
                                                                        
                                                            </flow>
                                                </page-sequence>
                                    </fo:root>
                            
            </xsl:template>
            
<!--            <xsl:template name="makePdfWithAbstracts">
                        
                                    <fo:root font-family="CormorantGaramond">
                                                
                                                <layout-master-set>
                                                            <!-\-Has to be in landscape-\->
                                                            <simple-page-master margin-bottom="1in"
                                                                        margin-left="1in" margin-right="1in"
                                                                        margin-top=".75in" master-name="Bios"
                                                                        page-height="11in" page-width="8.5in">
                                                                        <fo:region-body region-name="xsl-region-body"/>
                                                                        
                                                                        <!-\-<fo:region-after region-name="xsl-region-after" extent=".5in"/>-\->
                                                            </simple-page-master>
                                                            
                                                </layout-master-set>
                                                
                                                
                                                <page-sequence master-reference="Bios">
                                                           <!-\- <fo:static-content flow-name="xsl-region-after">
                                                            <block background-color="grey"><inline font-size="14pt">Endnotes</inline></block>
                                                </fo:static-content>-\->
                                                            <flow flow-name="xsl-region-body">
                                                                        
                                                                        <block font-size="36pt" text-align="center">Presenters</block>
                                                                        
                                                                        <xsl:call-template name="createBios">
                                                                                    <xsl:with-param name="abstracts" select="true()"/>
                                                                        </xsl:call-template>
                                                                        
                                                            </flow>
                                                </page-sequence>
                                    </fo:root>
                        
            </xsl:template>
            
            -->
            
            
            <xsl:template name="createBiosBody">
                        <xsl:for-each select="$presenterRows">
                           
                                    <xsl:sort order="ascending" select="tokenize(td[1],'\s+')[last()]"/>
                                    <!--Currently sorting by last name, but that 
                                    might not be the best way of doing it....
                                    -->
                                    <xsl:variable name="pos" select="position()"/>
                                    <xsl:variable name="name" select="td[1]"/>
                                    <xsl:variable name="affil" select="td[3]"/>
                                    <xsl:variable name="bio" select="td[5]"/>
                                    <xsl:variable name="title" select="td[6]"/>
                                   
                                   
                                                <block-container margin-top="1em" id="{lower-case(replace(normalize-space($name),'\s','_'))}" font-size="12pt">
                                                                        <xsl:attribute name="keep-together.within-page" select="'always'"/>
                                                            
                                                            <!--Title block-->
                                                            <block-container 
                                                                        keep-together.within-page="always">
                                                                        <block font-weight="bold" margin-bottom=".3em">
                                                                                    <xsl:value-of select="$name"/>
                                                                        </block>
                                                                        <block margin-bottom=".3em">
                                                                                    <xsl:value-of select="$affil"/>
                                                                        </block>
                                                                <block margin-bottom=".3em" keep-with-next.within-page="always">
                                                                    <inline font-weight="bold">Paper title:</inline>
                                                                    <xsl:text> </xsl:text>
                                                                    <xsl:apply-templates select="$title" mode="pdf"/>
                                                                </block>
                                                                        <block><inline font-weight="bold">Bio</inline>:<xsl:text> </xsl:text>
                                                                                    <xsl:apply-templates
                                                                                                select="$bio" mode="pdf"/></block>
                                                             
                                                            </block-container>
                                                </block-container>
                                    
                                    <xsl:if test="$pos ne last()">
                                                <block text-align="center" margin-top=".1em">
                                                            <fo:leader leader-pattern="rule" 
                                                                        leader-length="75%" rule-style="solid" rule-thickness=".2pt"/>         
                                                </block>
                                                
                                                      
                                               <!-- <block text-align="center" absolute-position="fixed" margin-top=".4em">
                                                            <external-graphic src="../endnotes-logo.png" content-height="scale-to-fit" height=".2in" content-width=".2in" scaling="uniform"/>
                                                </block>-->
                                    </xsl:if>
                        </xsl:for-each>
                        
            </xsl:template>
            
            
            
            
</xsl:stylesheet>
