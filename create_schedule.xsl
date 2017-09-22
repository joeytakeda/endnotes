<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:jt="http://joeytakeda.github.io/ns/"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    version="2.0">
    
    
    <xsl:output indent="no"/>
    
    <xsl:template name="createSchedulePdf">
        <xsl:result-document href="schedule.fo">
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
                        
                       <!-- <block font-size="36pt" text-align="center">Schedule</block>-->
                        
                        <xsl:call-template name="createScheduleLines"/>
                        
                        
                    </flow>
                </page-sequence>
            </fo:root>
        </xsl:result-document> 
    </xsl:template>
    
 
    
    <xsl:template name="createScheduleLines">
        <xsl:variable name="rowsToProcess" select="$scheduleRows[position() gt 1]"/>
        
        <xsl:for-each-group select="$rowsToProcess" group-by="td[2]">
            <xsl:variable name="day" select="current-grouping-key()"/>
            <xsl:variable name="dayMonth" select="if ($day='Friday') then 'May 12' else 'May 13'"/>
            
            <block page-break-before="always" font-size="11pt">
                <block text-align="center" font-size="24pt" font-weight="bold" keep-with-next.within-page="always"><xsl:value-of select="$day"/>, <xsl:value-of select="$dayMonth"/></block>
                <block font-style="italic" margin="1em 0" font-size="10pt">All events will be held at Coach House, Green College unless noted otherwise.</block>
                <xsl:for-each-group select="current-group()" group-by="td[4]">
                    <xsl:variable name="startTime" select="current-grouping-key()"/>
                    <xsl:variable name="endTime" select="current-group()[1]/td[5]"/>
                    <block-container padding=".1em 0">
                        
                        <block margin-bottom=".2em" font-size="14pt" keep-with-next.within-page="always" font-weight="bold"><xsl:value-of select="$startTime"/>-<xsl:value-of select="$endTime"/></block>
                        <xsl:for-each select="current-group()">
                            <block-container padding=".5em 0" keep-together.within-page="always" margin-left="1em">
                                <xsl:variable name="location" select="td[1]"/>
                                <xsl:variable name="name" select="td[3]"/>
                                
                                <xsl:variable name="mod" select="td[6]"/>
                                <xsl:variable name="presenterGroup" select="td[7]"/>
                                <xsl:variable name="presenters" 
                                    select="if (not($presenterGroup='')) then tokenize($presenterGroup,',\s*') else ()"/>
                                <xsl:variable name="note" select="td[8]"/>
                                <xsl:variable name="isPanel" as="xs:boolean" select="jt:isPanel($name)">
                                </xsl:variable>
                                <block>
                                    <block><inline font-weight="bold"> <xsl:choose>
                                        <xsl:when test="$name='Keynote' and $day='Friday'">
                                            <inline id="keynote_sonnetlabee"><xsl:value-of select="$name"/></inline>
                                        </xsl:when>
                                        <xsl:when test="$name='Keynote' and $day='Saturday'">
                                            <inline id="keynote_mopareles"><xsl:value-of select="$name"/></inline>
                                        </xsl:when>
                                        <xsl:otherwise><xsl:value-of select="$name"/></xsl:otherwise>
                                    </xsl:choose></inline><xsl:if test="$isPanel and not(normalize-space($mod)='TBA')"><xsl:text> (Chair: </xsl:text><xsl:value-of select="normalize-space($mod)"/><xsl:text>)</xsl:text></xsl:if></block>
                                    <!--If there is a location, render it-->
                                    <xsl:if test="not(empty($location))">
                                        <block font-style="italic">
                                            <xsl:value-of select="$location"/>
                                        </block>
                                    </xsl:if>
                                    <!--If there's a note render it first-->
                                    <xsl:if test="not(empty($note))">
                                        <block margin-top=".25em">
                                            <xsl:value-of select="$note"/>
                                        </block>
                                    </xsl:if>
                                    <!--If there are presenters, render them-->
                                    <!--We'll have to split this off with a choose
                                        for keynotes-->
                                    <xsl:if test="not(empty($presenters))">
                                        <!--Create a block with hanging indents-->
                                        <block-container margin-left="2em" 
                                            margin-top=".25em" 
                                            padding-right="1.5em" 
                                            text-indent="-1.5em">
                                            <xsl:for-each select="$presenters">
                                                <xsl:sort select="lower-case(.)" order="ascending"/>
                                                <xsl:variable name="thisPres" select="."/>
                                                
                                                <xsl:variable name="thisPresenterRow" select="$presenterRows[normalize-space(lower-case(tokenize(td[1],'\s+')[last()]))=normalize-space(lower-case($thisPres))]"/>
                                                <xsl:if test="empty($thisPresenterRow)">
                                                    <xsl:message>WARNING! Can't find <xsl:value-of select="$thisPres"/></xsl:message>
                                                </xsl:if>
                                                <xsl:variable name="thisPresenterName" select="$thisPresenterRow/td[1]"/>
                                                <xsl:variable name="presenterAffil" select="$thisPresenterRow/td[3]"/>
                                                <xsl:variable name="thisPresenterTitle" select="$thisPresenterRow/td[6]"/>
                                                
                                                <block padding-bottom=".15em">
                                                    <inline id="person_{lower-case(replace(normalize-space($thisPresenterName),'\s','_'))}"><xsl:value-of select="$thisPresenterName"/></inline> (<xsl:value-of select="normalize-space($presenterAffil)"/>): <xsl:apply-templates select="$thisPresenterTitle" mode="pdf"/></block>
                                            </xsl:for-each>
                                        </block-container>
                                    </xsl:if>
                                    
                                </block>
                                
                                
                            </block-container>
                        </xsl:for-each>
                        
                    </block-container>
                </xsl:for-each-group>
            </block>
          <!--  <xsl:if test="position() ne last()">
                <block text-align="center" margin="1em 0">
                    <fo:leader leader-pattern="rule" 
                        leader-length="75%" rule-style="solid" rule-thickness=".2pt"/>         
                </block>
            </xsl:if>-->
        </xsl:for-each-group>
    </xsl:template>
    
    
    
</xsl:stylesheet>