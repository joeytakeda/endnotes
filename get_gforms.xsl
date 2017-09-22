<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:jt="http://joeytakeda.github.io/ns/"
    xmlns:jc="http://james.blushingbunny.net/ns.html"
    exclude-result-prefixes="xs"
    version="2.0">
    

    <!-- CSV output isn't great, so there has to be another way to do this.
        Luckily, Google releases TSVs and ODS files.
    TSV is one way to go, but I wonder what the ODS to CSV might look like.
    -->
   <xsl:output indent="yes" encoding="UTF-8"/>
   
    <xsl:template match="/">
        <xsl:message>Creating XML files based off of Google Sheets for ease of processing.</xsl:message>
        <xsl:variable name="registration" select="unparsed-text(encode-for-uri('../Registration/Registration Form (Responses).gsheet'))"/>
        <xsl:variable name="subs" select="unparsed-text(encode-for-uri('../Submissions/Submissions Responses.gsheet'))"/>
        

        <xsl:result-document href="temp/submissions.xml" method="xml">
            <xsl:call-template name="convertTsv">
                <xsl:with-param name="input" select="jt:downloadResults(jt:getId($subs))"/>
            </xsl:call-template>
        </xsl:result-document>
        <xsl:result-document href="temp/registration.xml" method="xml">
            <xsl:call-template name="convertTsv">
                <xsl:with-param name="input" select="jt:downloadResults(jt:getId($registration))"/>
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:function name="jt:downloadResults">
        <xsl:param name="id"/>
        <xsl:value-of select="unparsed-text(concat('https://docs.google.com/spreadsheets/d/',$id,'/export?format=tsv&amp;id=',$id))"/>
    </xsl:function>
    
    
    <xsl:function name="jt:getId">
        <xsl:param name="doc"/>
        <xsl:variable name="dq">"</xsl:variable>
        <xsl:variable name="regex">"doc_id"</xsl:variable>
        <xsl:variable name="docIds" select="tokenize($doc, $regex)"/>
        <xsl:value-of select="normalize-space(translate(normalize-space(substring-before($docIds[2],'email')),concat(': ,',$dq),''))"/>
    </xsl:function>
    
    <!--The template below is taken from James Cummings work found here: http://www.tei-c.org/release/xml/tei/stylesheet/profiles/default/csv/from.xsl.-->
    <xsl:template name="convertTsv">
        <xsl:param name="input"/>
        <xsl:param name="input-encoding" select="'UTF-8'" as="xs:string"/>
        <xsl:variable name="csv"
            select="$input"/>
        <xsl:variable name="lines" select="tokenize($csv, '&#xa;')"
            as="xs:string+"/>
        <xsl:variable name="headerRow" select="jc:splitCSV($lines[1])"/>
        <table xmlns="http://joeytakeda.github.io/ns/">
            <xsl:for-each select="$lines">
                <row>
                    <xsl:if test="position()=1">
                        <xsl:attribute name="role" select="'head'"/>
                    </xsl:if>
                    <xsl:variable name="lineItems" select="jc:splitCSV(.)"
                        as="xs:string+"/>		     
                    <xsl:for-each select="$lineItems">
                        <xsl:variable name="pos" select="position()"/>
                        <cell n="{$pos}" id="{$headerRow[$pos]}">
                            <xsl:value-of select="translate($lineItems[$pos],'&#xD;','')"/>
                        </cell>
                    </xsl:for-each>
                </row>
            </xsl:for-each>
        </table>
    </xsl:template>
    
    <xsl:function name="jc:splitCSV" as="xs:string+">
        <xsl:param name="str" as="xs:string"/>
        
        <xsl:analyze-string select="concat($str, '&#x9;')"
            regex="((&quot;[^&quot;]*&quot;)+|[^\t]*)\t">
            <xsl:matching-substring>
                <xsl:variable name="temp" as="xs:string+">
                    <xsl:sequence
                        select="replace(regex-group(1), &quot;^&quot;&quot;|&quot;&quot;$|(&quot;&quot;)&quot;&quot;&quot;, &quot;$1&quot;)"
                    />
                </xsl:variable>
                <xsl:sequence select="for $n in $temp return normalize-space(translate($n,'&#xD;',''))"/>
                
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>
</xsl:stylesheet>