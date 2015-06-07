<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:t="http://www.tei-c.org/ns/1.0"
	xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs xd t" version="2.0">
	
	<!-- ******************************************************************************
        Author: Emmanuelle Morlock
        
        Object: extracts data form a TEI/EpiDoc file for display in timemapper
        
        Info:
        - input: theores-col-2.xml
        - result: theores-col-2.csv
        
        **Change Log
        2015-05-19 EM Visible Words workshop demo
        2015-06-07 GitHub deposit
       
        
        ******************************************************************************   -->
	
	
	<!-- <xsl:output method="text"/> -->
	<xsl:strip-space elements="*"/>
	<xsl:key name="PERSONS" match="t:person" use="@xml:id"/>
	<!-- index des localisations de tous les éléments person à partir de leur identifiant -->
	<xsl:param name="dest" select="theores-col-2.csv"/>
	<xsl:param name="startCol">
		<!-- année de départ de la colonne moins une année-->
		<xsl:text>-509</xsl:text>
	</xsl:param>
	<xsl:param name="delim" select="';'"/>
	<xsl:param name="newLine">
		<xsl:text>			
		</xsl:text>
	</xsl:param>
	<xsl:param name="colTitles">
		<xsl:text>numCol;Title;Start;End;Description;Web Page;Media;Media Caption;Media Credit;Tags;Place;Location;Source;Source URL</xsl:text>
	</xsl:param>
	<xsl:include href="example-p5-xslt/start-edition.xsl"/>
	<!--  -->
	<xsl:template match="/">
		<xsl:message>Writing <xsl:value-of select="$dest"/></xsl:message>
		<xsl:result-document href="{$dest}" encoding="UTF-8" method="text">
			<xsl:value-of select="$colTitles"/>
			<!-- break -->
			<xsl:text>&#xA;</xsl:text>
			<xsl:for-each select="//t:item[@ana='#triade']">
				<xsl:variable name="n">
					<xsl:number level="single"/>
				</xsl:variable>
				<!-- numCol -->
				<xsl:value-of select="$n"/>
				<xsl:value-of select="$delim"/>
				<!-- Title -->
				<xsl:comment>Title : item <xsl:value-of select="$n"/></xsl:comment>
				<xsl:apply-templates select="t:list/t:item"/>
				<xsl:value-of select="$delim"/>
				<!-- Start -->
				<xsl:comment>Start</xsl:comment>
				<xsl:variable name="start" select="$startCol + $n"/>
				<xsl:value-of select="$start"/>
				<xsl:value-of select="$delim"/>
				<!-- End -->
				<xsl:comment>End</xsl:comment>
				<xsl:value-of select="$delim"/>
				<!-- Description -->
				<xsl:comment>Description</xsl:comment>
				<xsl:text>&lt;ol class="triade" style="display:block;list-style-type:decimal;"&gt;</xsl:text>
				<xsl:for-each select="t:list/t:item">
					<xsl:text>&lt;li&gt;</xsl:text>
					<xsl:for-each select="descendant-or-self::t:persName">
						<xsl:text>&lt;dl class="personne" style="display:block;margin-bottom:1em;margin-top:0.5em;"&gt;</xsl:text>
						<xsl:variable name="ref" select="substring-after(@ref,'#')"/>
						<xsl:for-each select="key('PERSONS',$ref)">
							<xsl:variable name="birthNotAfter" select="t:birth/@notAfter"/>
							<xsl:variable name="birthNotBefore" select="t:birth/@notBefore"/>
							<xsl:variable name="birthNotAfterFrench">
								<xsl:analyze-string select="$birthNotAfter" regex="([-])([0])(\d+)">
									<xsl:matching-substring>
										<xsl:value-of select="concat(regex-group(3),' av. J.-C.')"/>
									</xsl:matching-substring>
									<xsl:non-matching-substring>
										<xsl:analyze-string select="$birthNotAfter" regex="([+])([0])(\d+)">
											<xsl:matching-substring>
												<xsl:value-of select="concat(regex-group(3),' ap. J.-C.')"/>
											</xsl:matching-substring>
										</xsl:analyze-string>
									</xsl:non-matching-substring>
								</xsl:analyze-string>
							</xsl:variable>
							<xsl:variable name="birthNotBeforeFrench">
								<xsl:analyze-string select="$birthNotBefore" regex="([-])([0])(\d+)">
									<xsl:matching-substring>
										<xsl:value-of select="concat(regex-group(3),' av. J.-C.')"/>
									</xsl:matching-substring>
									<xsl:non-matching-substring>
										<xsl:analyze-string select="$birthNotBefore" regex="([+])([0])(\d+)">
											<xsl:matching-substring>
												<xsl:value-of select="concat(regex-group(3),' ap. J.-C.')"/>
											</xsl:matching-substring>
										</xsl:analyze-string>
									</xsl:non-matching-substring>
								</xsl:analyze-string>
							</xsl:variable>
							<xsl:variable name="phiUrl">
								<xsl:text>http://epigraphy.packhum.org/inscriptions/oi?ikey=</xsl:text>
							</xsl:variable>
							
							<xsl:variable name="comparDates2">
								<xsl:text>&lt;span style="color:red;"&gt;En</xsl:text>
								<xsl:value-of select="$start"/>
								<xsl:text>, aurait entre </xsl:text>
								<xsl:value-of select="abs(($birthNotBefore - $start))"/>
								<xsl:text> et </xsl:text>
								<xsl:value-of select="abs(($birthNotAfter - $start))"/>
								<xsl:text> ans &lt;/span&gt; </xsl:text>
							</xsl:variable>
							<xsl:variable name="atts">
								<xsl:apply-templates select="t:bibl[not(@rend='equals')]"/>
							</xsl:variable>
							<xsl:variable name="attsEquals">
								<xsl:apply-templates select="t:bibl[@rend='equals']"/>
							</xsl:variable>
							<xsl:text>&lt;dt class="nom" style="display:block;"&gt;</xsl:text>
							<xsl:apply-templates select="t:persName" mode="nomAvecLien"/>
							<xsl:text>&lt;/dt&gt;&lt;dd class="infos" style="display:block;"&gt;</xsl:text>
							<xsl:value-of select="concat($birthNotBeforeFrench,' - ',$birthNotAfterFrench)"/>
							<xsl:text>&lt;br/&gt;</xsl:text>
							<xsl:value-of select="$comparDates2"/>
							<xsl:text>&lt;/dd&gt;&lt;dd class="attestation"&gt;cf. &lt;a href="</xsl:text>
							<xsl:value-of select="concat($phiUrl,t:bibl/@corresp)"/>
							<xsl:text>"&gt;</xsl:text>
							<xsl:value-of select="normalize-space($atts)"/>
							<xsl:text>&lt;/a&gt;= </xsl:text>
							<xsl:value-of select="normalize-space($attsEquals)"/>
							<xsl:text>&lt;/dd&gt;</xsl:text>
						</xsl:for-each>
						<xsl:text>&lt;/dl&gt;</xsl:text>
					</xsl:for-each>
					<xsl:text>&lt;/li&gt;</xsl:text>
				</xsl:for-each>
				<xsl:text>&lt;/ol&gt;</xsl:text>
				<xsl:value-of select="$delim"/>
				<!-- web page -->
				<xsl:comment>Web Page</xsl:comment>
				<xsl:value-of select="$delim"/>
				<!-- Media -->
				<xsl:comment>Media</xsl:comment>
				<xsl:value-of select="concat('http://data.perseus.org/collections/',@facs)"/>
				<xsl:value-of select="$delim"/>
				<!-- Media caption -->
				<xsl:comment>Media caption</xsl:comment>
				<xsl:value-of select="$delim"/>
				<!-- Media Credit -->
				<xsl:comment>Media credit</xsl:comment>
				<xsl:value-of select="$delim"/>
				<!-- Tags -->
				<xsl:comment>Tags</xsl:comment>
				<xsl:value-of select="$delim"/>
				<!-- Place -->
				<xsl:comment>Place</xsl:comment>
				<xsl:value-of select="$delim"/>
				<!-- Location -->
				<xsl:comment>Location</xsl:comment>
				<xsl:value-of select="$delim"/>
				<!-- Source -->
				<xsl:comment>Source</xsl:comment>
				<xsl:value-of select="$delim"/>
				<!-- Source Url  -->
				<xsl:comment>Source Url</xsl:comment>
				<!-- break -->
				<xsl:text>&#xA;</xsl:text>
			</xsl:for-each>
		</xsl:result-document>
	</xsl:template>
	<xsl:template match="t:item/t:lb">
		<xsl:text>&lt;br/&gt;</xsl:text>
	</xsl:template>
	<xsl:template match="t:item[not(child::t:list)]">
		<xsl:apply-templates select="t:lb"/>
		<xsl:apply-templates mode="nomAvecLien"/>
	</xsl:template>
	<xsl:template match="t:persName[parent::t:persName]" mode="nomAvecLien"/>
	<xsl:template match="t:persName" mode="nomAvecLien">
		<xsl:variable name="ref" select="./substring-after(@ref,'#')"/>
		<xsl:variable name="url" select="concat('http://www.lgpn.ox.ac.uk/id/',$ref)"/>
		<xsl:variable name="nymRef" select="substring-after(key('PERSONS',$ref)/t:persName/@nymRef,'#')"/>
		<xsl:text>&lt;a href="</xsl:text>
		<xsl:value-of select="$url"/>
		<xsl:text>" title="</xsl:text>
		<xsl:value-of select="$nymRef"/>
		<xsl:text>"&gt;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&lt;/a&gt;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
