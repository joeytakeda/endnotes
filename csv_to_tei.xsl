<?xml version="1.0"?>

<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:jc="http://james.blushingbunny.net/ns.html"
	exclude-result-prefixes="xs tei jc">

	

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
      	<p>This is taken almost wholly (with thanks and acknowledgement) from James' Cummings code found here: http://www.tei-c.org/release/xml/tei/stylesheet/profiles/default/csv/from.xsl.</p>
      </desc>
   </doc>

   <xsl:function name="jc:splitCSV" as="xs:string+">
     <xsl:param name="str" as="xs:string"/>
     <xsl:analyze-string select="concat($str, ',')"
			 regex="((&quot;[^&quot;]*&quot;)+|[^,]*),">
       <xsl:matching-substring>
	 <xsl:sequence
	     select="replace(regex-group(1), &quot;^&quot;&quot;|&quot;&quot;$|(&quot;&quot;)&quot;&quot;&quot;, &quot;$1&quot;)"
	     />
       </xsl:matching-substring>
     </xsl:analyze-string>
   </xsl:function>
   
   <xsl:template name="convertCsv">
   	<xsl:param name="input-uri"/>
   	<xsl:param name="input-encoding" select="'UTF-8'" as="xs:string"/>
     <xsl:choose>
       <xsl:when test="unparsed-text-available($input-uri, $input-encoding)">
	 <xsl:variable name="csv"
		       select="unparsed-text($input-uri, $input-encoding)"/>
	 <xsl:variable name="lines" select="tokenize($csv, '&#xa;')"
		       as="xs:string+"/>
	 <TEI xmlns="http://www.tei-c.org/ns/1.0">
	   <teiHeader>
	     <fileDesc>
	       <titleStmt>
		 <title>A TEI file automatically converted from CSV</title>
	       </titleStmt>
	       <publicationStmt>
		 <p>No publication statement</p>
	       </publicationStmt>
	       <sourceDesc>
		 <p>A TEI file automatically converted from a CSV file.</p>
		 
	       </sourceDesc>
	     </fileDesc>
	   </teiHeader>
	   <text>
	     <body>
	       <table>
	       
		 <xsl:for-each select="$lines">
		   <row>
		     <xsl:variable name="lineItems" select="jc:splitCSV(.)"
				   as="xs:string+"/>		     
		     <xsl:for-each select="$lineItems">
		       <xsl:variable name="pos" select="position()"/>
		       <cell n="{$pos}">
		       	<xsl:value-of select="replace($lineItems[$pos],'&#xD;','')"/>
		       </cell>
		     </xsl:for-each>
		   </row>
		 </xsl:for-each>
	       </table>
	     </body>
	   </text>
	 </TEI>
       </xsl:when>
       <xsl:otherwise>
	 <xsl:message terminate="yes">
	   <xsl:text>Cannot find the input csv file: </xsl:text>
	   <xsl:value-of select="$input-uri"/>
	 </xsl:message>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
