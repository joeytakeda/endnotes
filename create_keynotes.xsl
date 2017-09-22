<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:jt="http://joeytakeda.github.io/ns/"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    version="2.0">
    
  
  <xsl:template name="createKeynotesPdf">
      <xsl:result-document href="keynotes.fo">
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
                      <block-container keep-together.within-page="always">
                          <block font-size="36pt" text-align="center">Keynotes</block>
                          
                          <xsl:call-template name="createKeynotesBody"/>
                      </block-container>
                      
                  </flow>
              </page-sequence>
          </fo:root>
      </xsl:result-document>
  </xsl:template>
    
    <xsl:template name="createKeynotesBody">
        <xsl:for-each select="$keynotesRows">
            <xsl:variable name="name" select="td[1]"/>
            <xsl:variable name="bio" select="td[2]"/>
            <xsl:variable name="title" select="td[3]"/>
            <xsl:variable name="keynoteScheduleRow" select="$scheduleRows[normalize-space(tokenize(td[6],'\s+')[last()])=normalize-space(tokenize($name,'\s+')[last()])]" as="element()"/>
          
            <xsl:variable name="loc" select="$keynoteScheduleRow/td[1]"/>
            <xsl:variable name="day" select="$keynoteScheduleRow/td[2]"/>
            <xsl:variable name="dayName" select="if ($day='Friday') then 'May 12' else 'May 13'"/>
            <xsl:variable name="start" select="$keynoteScheduleRow/td[4]"/>
            <xsl:variable name="end" select="$keynoteScheduleRow/td[5]"/>
            <block-container padding="1em">
               <block text-align="left" font-size="18pt" margin-bottom=".5em"><xsl:value-of select="$name"/></block>
               <block margin-bottom=".5em"><xsl:value-of select="$title"/></block>
               <block font-weight="bold" margin-bottom="1em"><xsl:value-of select="string-join((concat($start,'-',$end),$day,$dayName,$loc),', ')"/></block>
                <block><xsl:apply-templates select="$bio" mode="pdf"/></block>
           </block-container>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>