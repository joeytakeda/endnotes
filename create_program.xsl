<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:jt="http://joeytakeda.github.io/ns/"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    version="2.0">
    
    <xsl:output indent="no"/>
    
    <xsl:include href="create_schedule.xsl"/>
    <xsl:include href="create_bios.xsl"/>
    <xsl:include href="create_keynotes.xsl"/>
    <xsl:include href="create_intro.xsl"/>
    
    <xsl:variable name="presenters" select="doc('temp/presenters.html')"/>
    <xsl:variable name="presenterRows" select="$presenters//tbody/descendant::tr"/>
    
    <xsl:variable name="schedule" select="doc('temp/schedule.html')"/>
    <xsl:variable name="scheduleRows" select="$schedule//tbody/descendant::tr"/>
    
    <xsl:variable name="keynotesDoc" select="doc('temp/keynotes.html')"/>
    <xsl:variable name="keynotesRows" select="$keynotesDoc//tbody/descendant::tr"/>
    
    <xsl:variable name="introDoc" select="doc('temp/intro.html')"/>
    <xsl:variable name="intro" select="$introDoc//html"/>
    
    <xsl:template match="/">
        
        <xsl:call-template name="createIntroPdf"/>
        <xsl:call-template name="createBioPdf"/>
        <xsl:call-template name="createSchedulePdf"/>
        <xsl:call-template name="createKeynotesPdf"/>
        <xsl:call-template name="createProgramPdf"/>
      
        
    </xsl:template>
    
    <xsl:template name="createProgramPdf">
        <xsl:result-document href="program.fo">
            <fo:root font-family="CormorantGaramond">
                
                <layout-master-set>
                    
                    <fo:simple-page-master margin-bottom="1in"
                        margin-left="1in" margin-right="1in"
                        margin-top="1in"
                        page-height="11in" page-width="8.5in" master-name="Cover">
                        <fo:region-body region-name="cover-body"/>
                    </fo:simple-page-master>
                    
                    
                    <simple-page-master master-name="page-even"
                        margin-bottom=".75in"
                        margin-left="1in" margin-right="1in"
                        margin-top="1.5in"
                        page-height="11in" page-width="8.5in">
                        <region-body region-name="xsl-region-body"/>
                        <region-before extent="-1in" region-name="header-even"/>
                    </simple-page-master>
                    
                    <simple-page-master master-name="page-odd"
                        margin-bottom=".75in"
                        margin-left="1in" margin-right="1in"
                        margin-top="1.5in"
                        page-height="11in" page-width="8.5in">
                        <region-body region-name="xsl-region-body"/>
                        <region-before extent="-1in" region-name="header-odd" />
                    </simple-page-master>
                    
                    <page-sequence-master master-name="program">
                        <repeatable-page-master-alternatives>
                            <conditional-page-master-reference odd-or-even="even"
                                master-reference="page-even"/>
                            <conditional-page-master-reference odd-or-even="odd"
                                master-reference="page-odd"/>
                        </repeatable-page-master-alternatives>
                    </page-sequence-master>
                </layout-master-set>
                
         
                <page-sequence master-reference="Cover" force-page-count="no-force">
                    <!--Change force-page-count="end-on-even" if a blank page after the cover
                        is wanted-->
                    <flow flow-name="cover-body">
                        <block font-size="48"  text-align="center" font-weight="bold">ENDNOTES 2017</block>
                    </flow>
                </page-sequence>
                
                <page-sequence master-reference="program" initial-page-number="0">
                    <static-content flow-name="header-even">
                        <block text-align="right" border-bottom="black inset medium" padding-bottom=".1em" font-size="11.5pt">
                            <!--             <inline><external-graphic padding-top=".2in" src="../endnotes-logo.png" content-width="scale-to-fit" width=".23in"  scaling="uniform" alignment-adjust="-.092in"/></inline>
               
                        <inline padding-left="2.9in" width=".5in" margin-bottom="1in"><page-number /></inline>
               -->
                            <inline>On the Edge: Borders, Boundaries, and Thresholds in an Age of Unease</inline><inline font-size="130%" padding=".5em">  |  </inline><inline><external-graphic padding-top=".2in" src="../endnotes-logo.png" content-width="scale-to-fit" width=".2in"  scaling="uniform" alignment-adjust="-.04in"/></inline>
                            
                        </block>
                    </static-content>
                    <static-content flow-name="header-odd">
                        <block text-align="left" border-bottom="black inset medium" padding-bottom=".1em" font-size="11.5pt">
                            <!--             <inline><external-graphic padding-top=".2in" src="../endnotes-logo.png" content-width="scale-to-fit" width=".23in"  scaling="uniform" alignment-adjust="-.092in"/></inline>
               
                        <inline padding-left="2.9in" width=".5in" margin-bottom="1in"><page-number /></inline>
               -->
                            <inline><external-graphic padding-top=".2in" src="../endnotes-logo.png" content-width="scale-to-fit" width=".2in"  scaling="uniform" alignment-adjust="-.04in"/></inline><inline font-size="130%" padding=".5em">  |  </inline><inline font-size="110%">Endnotes 2017, University of British Columbia</inline>
                            
                        </block>
                    </static-content>
                    
                    <flow flow-name="xsl-region-body">
                        
                       <!-- <block-container page-break-before="always">
                            <block font-size="28pt" text-align="center">Introduction</block>
                            <xsl:call-template name="createIntroBody"/>
                        </block-container>-->
                        
                        <block-container page-break-before="always">
                          <!--  <block font-size="28pt" text-align="center">Schedule</block>-->
                            <xsl:call-template name="createScheduleLines"/>
                        </block-container>
                        
                        <block-container page-break-before="always">
                            <block font-size="28pt" text-align="center">Keynotes</block>
                            <xsl:call-template name="createKeynotesBody"/>
                        </block-container>
                        <!--            
                        <block-container page-break-before="always">
                            <block font-size="36pt" text-align="center">Schedule ALTNERATIVE FOR DESIGN</block>
                            <xsl:call-template name="createScheduleTable"/>
                        </block-container>-->
                        
                        <block-container page-break-before="always">
                            <block font-size="28pt" text-align="center">Presenter Biographies</block>
                            <xsl:call-template name="createBiosBody"/>
                            
                        </block-container>
                        
                        <block-container page-break-before="always">
                            <block font-size="28pt">Map? Schedule at a glance? Anything else?</block>
                        </block-container>
                        
                    </flow>
                    
                    
                    
                </page-sequence>
                
            </fo:root>
        </xsl:result-document>
        
    </xsl:template>
    
    
    <!--Templates for HTML output. Not sure how best to do this yet.-->
    <xsl:template match="span[@style='font-style:italic;']" mode="html">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="html"/>
        </xsl:copy>
    </xsl:template>
    
    <!--Templates for converting the XHTML5 styling
        from Google into FO-->
    <xsl:template match="body" mode="pdf">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    <xsl:template match="span[@style='font-style:italic;']" mode="pdf">
        <inline font-style="italic">
            <xsl:apply-templates mode="#current"/>
        </inline>
    </xsl:template>
    
    <xsl:template match="span[@style='font-weight:bold;']" mode="pdf">
        <inline font-weight="bold">
            <xsl:apply-templates mode="#current"/>
        </inline>
    </xsl:template>
    
    <xsl:template match="p" mode="pdf">
        <xsl:variable name="content" select="string-length(normalize-space(.))"/>
        <xsl:variable name="priorContent" select="if (preceding-sibling::p[1]/string-length(normalize-space(.))=0) then false() else true()"/>
        <block padding="{if ($content gt 0) then '.25em' else if ($priorContent) then '.5em' else '.75em'}">
            <xsl:apply-templates mode="#current"/>
        </block>
    </xsl:template>
    
    <xsl:template match="ul" mode="pdf">
        <list-block padding="-.5em 0">
          <xsl:apply-templates mode="#current"/>
        </list-block>
    </xsl:template>
    
    <xsl:template match="li" mode="pdf">
        <list-item padding=".075em">
            <list-item-label margin-left="1em"><block>•</block></list-item-label>
            <list-item-body margin-left="1.75em"><block><xsl:apply-templates mode="#current"/></block></list-item-body>
        </list-item>
    </xsl:template>
    
    
    
    <xsl:template match="text()" mode="pdf">
        <xsl:analyze-string select="." regex="/(\w+)/">
            <xsl:matching-substring>
                <inline font-style="italic"><xsl:value-of select="regex-group(1)"/></inline>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <!--Functions-->
    
    <xsl:function name="jt:isPanel" as="xs:boolean">
        <xsl:param name="name"/>
        <xsl:value-of select="if (starts-with($name,'Reception') or starts-with($name,'Break') or starts-with($name,'Registration') or starts-with($name,'Keynote') or starts-with($name,'Lunch')) then false() else true()"/>
    </xsl:function>
</xsl:stylesheet>