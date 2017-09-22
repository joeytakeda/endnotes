<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:jt="http://joeytakeda.github.io/ns/"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    version="2.0">
    
    
    <xsl:output indent="no"/>
    <xsl:variable name="presenters" select="doc('temp/presenters.html')"/>
    <xsl:variable name="presenterRows" select="$presenters//tbody/descendant::tr"/>
    
    <xsl:variable name="schedule" select="doc('temp/schedule.html')"/>
    <xsl:variable name="scheduleRows" select="$schedule//tbody/descendant::tr"/>
    
    <xsl:template match="/">
        <xsl:call-template name="createPanelDocuments"/>
    </xsl:template>
    
    <xsl:template name="createPanelDocuments">
        <xsl:variable name="rowsToProcess" select="$scheduleRows[jt:isPanel(td[3])][not(td[6]='')][position() gt 1]"/>
       <!-- <xsl:result-document href="temp/temp.xml">
            <tasks>
                <xsl:for-each select="$rowsToProcess">
                    <xsl:variable name="mod" select="normalize-space(tokenize(td[6],'\s+')[last()])"/>
                    <fop format="application/pdf"
                        fofile="temp/{$mod}_endnotes2017.fo"
                        outfile="../products/PDF/for_panel_chairs/{$mod}_endnotes2017.pdf"
                        userconfig="utilities/fop-2.0/conf/fop.xconf"
                    />
                </xsl:for-each>  
            </tasks>
        </xsl:result-document>
        -->
        
        <xsl:for-each select="$scheduleRows[jt:isPanel(td[3])][not(td[6]=('','TBA'))][position() gt 1]">
            <xsl:variable name="mod" select="normalize-space(td[6])"/>
            <xsl:variable name="thisRow" select="."/>
            <xsl:variable name="panelName" select="td[3]"/>
            <xsl:result-document href="temp/{normalize-space(tokenize($mod,'\s+')[last()])}_endnotes2017.fo">
                <fo:root font-family="CormorantGaramond">
                    
                    <layout-master-set>
                        <simple-page-master margin-bottom="1in"
                            margin-left="1in" margin-right="1in"
                            margin-top=".75in" master-name="Bios"
                            page-height="11in" page-width="8.5in">
                            <fo:region-body region-name="xsl-region-body"/>
                        </simple-page-master>
                        
                    </layout-master-set>
                    <page-sequence master-reference="Bios">
                        <flow flow-name="xsl-region-body">
                            
                            <xsl:call-template name="createPanelInfo">
                                <xsl:with-param name="row" select="$thisRow"/>
                            </xsl:call-template>
                            
                            
                        </flow>
                    </page-sequence>
                </fo:root>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="createPanelInfo">
        <xsl:param name="row"/>
        <xsl:variable name="start" select="$row/td[4]"/>
        <xsl:variable name="end" select="$row/td[5]"/>
        <xsl:variable name="day" select="$row/td[2]"/>
        <xsl:variable name="dayMonth" select="if ($day='Friday') then 'May 12' else 'May 13'"/>
        <xsl:variable name="name" select="$row/td[3]"/>
        <xsl:variable name="mod" select="$row/td[6]"/>
        <xsl:variable name="presenterGroup" select="$row/td[7]"/>
        <xsl:variable name="presenters" 
            select="if (not($presenterGroup='')) then tokenize($presenterGroup,',\s*') else ()"/>
        <block font-size="20pt" text-align="center">Endnotes 2017: <xsl:value-of select="$name"/></block>
        
        <block-container margin="1.5em 0">
            <block padding=".1em 0"><inline font-weight="bold">Time</inline>: <xsl:value-of select="$start"/>-<xsl:value-of select="$end"/>, <xsl:value-of select="$day"/>, <xsl:value-of select="$dayMonth"/></block>
            <block padding=".1em 0"><inline font-weight="bold">Chair</inline>: <xsl:value-of select="$mod"/></block>
            <block padding=".1em 0"><inline font-weight="bold">Location</inline>: Coach House, Green College</block>
        </block-container>
        
        <block-container margin="1.5em 0">
            <block text-align="center" font-size="16pt" margin=".5em 0">Presenters</block>
            <xsl:for-each select="$presenters">
                <xsl:sort select="lower-case(.)" order="ascending"/>
                <block-container margin="1em 0">
                    <xsl:variable name="thisPres" select="."/>
                    
                    <xsl:variable name="thisPresenterRow" select="$presenterRows[normalize-space(lower-case(tokenize(td[1],'\s+')[last()]))=normalize-space(lower-case($thisPres))]"/>
                    <xsl:variable name="thisPresenterName" select="$thisPresenterRow/td[1]"/>
                    <xsl:variable name="presenterAffil" select="$thisPresenterRow/td[3]"/>
                    <xsl:variable name="bio" select="$thisPresenterRow/td[5]"/>
                    <xsl:variable name="thisPresenterTitle" select="$thisPresenterRow/td[6]"/>
                    <xsl:variable name="abstract" select="$thisPresenterRow/td[7]"/>
                    <block padding=".1em 0"><inline font-weight="bold">Presenter</inline>: <xsl:value-of select="$thisPresenterName"/></block>
                    <block padding=".1em 0"><inline font-weight="bold">Affiliation</inline>: <xsl:value-of select="$presenterAffil"/></block>
                    <block padding=".1em 0"><inline font-weight="bold">Bio</inline>: <xsl:apply-templates mode="pdf" select="$bio"/></block>
                    <block padding=".1em 0"><inline font-weight="bold">Paper Title</inline>: <xsl:apply-templates select="$thisPresenterTitle" mode="pdf"/></block>
                    <block padding=".1em 0"><inline font-weight="bold">Abstract</inline>: <xsl:apply-templates select="$abstract" mode="pdf"/></block>
                    
                </block-container>
                <xsl:if test="position() ne last()">
                    <block text-align="center" margin=".25em 0">
                        <fo:leader leader-pattern="rule" 
                            leader-length="75%" rule-style="solid" rule-thickness=".2pt"/>         
                    </block>
                </xsl:if>
               
            </xsl:for-each>
            
               
                
        </block-container>
        
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
        <xsl:value-of select="if (starts-with($name,'Break') or starts-with($name,'Registration') or starts-with($name,'Keynote') or starts-with($name,'Lunch')) then false() else true()"/>
    </xsl:function>
    <!--    (starts-with($name,'Reception') or -->
</xsl:stylesheet>
