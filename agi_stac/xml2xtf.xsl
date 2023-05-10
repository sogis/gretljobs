<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:myns="ch.so.agi" exclude-result-prefixes="myns" version="3.0"> 
    <xsl:output method="xml" indent="yes"/>
    

    <xsl:template match="/themePublications">
        <TRANSFER xmlns="http://www.interlis.ch/INTERLIS2.3">
        <HEADERSECTION SENDER="sodata" VERSION="2.3">
            <MODELS>
            <MODEL NAME="SO_AGI_STAC_20230426" VERSION="2023-04-26" URI="https://agi.so.ch"/>
            </MODELS>
        </HEADERSECTION>

        <DATASECTION>
            <SO_AGI_STAC_20230426.Collections BID="SO_AGI_STAC_20230426.Collections">

                <xsl:apply-templates select="themePublication" /> 

            </SO_AGI_STAC_20230426.Collections>

        </DATASECTION>
        </TRANSFER>
    </xsl:template>

    <xsl:template match="themePublication">     
        <xsl:message><xsl:value-of select="identifier"/></xsl:message>
        <SO_AGI_STAC_20230426.Collections.Collection xmlns="http://www.interlis.ch/INTERLIS2.3" TID="{identifier}">
            <Identifier xmlns="http://www.interlis.ch/INTERLIS2.3">
                <xsl:value-of select="identifier"/>
            </Identifier>
            <Title xmlns="http://www.interlis.ch/INTERLIS2.3">
                <xsl:value-of select="title"/>
            </Title>
            <ShortDescription xmlns="http://www.interlis.ch/INTERLIS2.3">
                <xsl:value-of select="shortDescription"/>
            </ShortDescription>
            <SpatialExtent xmlns="http://www.interlis.ch/INTERLIS2.3">
                <SO_AGI_STAC_20230426.Collections.BoundingBox xmlns="http://www.interlis.ch/INTERLIS2.3">
                    <westlimit xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="bbox/left"/></westlimit>
                    <southlimit xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="bbox/bottom"/></southlimit>
                    <eastlimit xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="bbox/right"/></eastlimit>
                    <northlimit xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="bbox/top"/></northlimit>
                </SO_AGI_STAC_20230426.Collections.BoundingBox>
            </SpatialExtent>
            <TemporalExtent xmlns="http://www.interlis.ch/INTERLIS2.3">
                <SO_AGI_STAC_20230426.Collections.Interval xmlns="http://www.interlis.ch/INTERLIS2.3">
                    <xsl:if test="secondToLastPublishingDate" >
                        <StartDate xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="secondToLastPublishingDate"/></StartDate>
                    </xsl:if>
                    <EndDate xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="lastPublishingDate"/></EndDate>
                </SO_AGI_STAC_20230426.Collections.Interval>
            </TemporalExtent>
            <Licence xmlns="http://www.interlis.ch/INTERLIS2.3">https://files.geo.so.ch/nutzungsbedingungen.html</Licence>

            <!-- Ignoriert Tags, falls das erste Element vorhanden ist aber leer ist. Nicht super robust. -->    
            <xsl:if test="string-length(keywords/keyword[1]) > 1">
                <Keywords xmlns="http://www.interlis.ch/INTERLIS2.3">
                    <xsl:for-each select="keywords/keyword">
                        <SO_AGI_STAC_20230426.Collections.Keyword_ xmlns="http://www.interlis.ch/INTERLIS2.3">
                            <Keyword xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="."/></Keyword>
                        </SO_AGI_STAC_20230426.Collections.Keyword_>
                    </xsl:for-each>
                </Keywords>
            </xsl:if>

            <Owner xmlns="http://www.interlis.ch/INTERLIS2.3">
                <SO_AGI_STAC_20230426.Collections.Office xmlns="http://www.interlis.ch/INTERLIS2.3">
                    <AgencyName xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="owner/agencyName"/></AgencyName>
                    <Abbreviation xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="owner/abbreviation"/></Abbreviation>
                    <xsl:if test="owner/division">
                        <Division xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="owner/division"/></Division>
                    </xsl:if>
                    <OfficeAtWeb xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="owner/officeAtWeb"/></OfficeAtWeb>
                    <Email xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="owner/email"/></Email>
                    <Phone xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="owner/phone"/></Phone>
                </SO_AGI_STAC_20230426.Collections.Office>
            </Owner>

            <Servicer xmlns="http://www.interlis.ch/INTERLIS2.3">
                <SO_AGI_STAC_20230426.Collections.Office xmlns="http://www.interlis.ch/INTERLIS2.3">
                    <AgencyName xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="servicer/agencyName"/></AgencyName>
                   <Abbreviation xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="servicer/abbreviation"/></Abbreviation>
                    <xsl:if test="servicer/division">
                        <Division xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="servicer/division"/></Division>
                    </xsl:if>
                    <OfficeAtWeb xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="servicer/officeAtWeb"/></OfficeAtWeb>
                    <Email xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="servicer/email"/></Email>
                    <Phone xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="servicer/phone"/></Phone>
                </SO_AGI_STAC_20230426.Collections.Office>
            </Servicer>

            <Items xmlns="http://www.interlis.ch/INTERLIS2.3">
                <xsl:variable name="itemsNo" select="count(items/item)"/>
                
                <xsl:for-each select="items/item">
                    <xsl:variable name="itemIdentifier" select="identifier"/>
                    
                    <SO_AGI_STAC_20230426.Collections.Item xmlns="http://www.interlis.ch/INTERLIS2.3">
                        <Identifier xmlns="http://www.interlis.ch/INTERLIS2.3">
                            <xsl:choose>
                                <xsl:when test="$itemsNo > 1">
                                    <xsl:value-of select="concat(identifier,'.',../../identifier)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:value-of select="../../identifier"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </Identifier>
                        <Title xmlns="http://www.interlis.ch/INTERLIS2.3">
                            <xsl:choose>
                                <xsl:when test="$itemIdentifier = 'so'"> <!--Kosmetik-->
                                    <xsl:value-of select="concat(../../title, ' (Kanton Solothurn)')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="title"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </Title>
                        <Date xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="lastPublishingDate"/></Date>
                        <Boundary xmlns="http://www.interlis.ch/INTERLIS2.3">
                            <SO_AGI_STAC_20230426.Collections.BoundingBox xmlns="http://www.interlis.ch/INTERLIS2.3">
                                <westlimit xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="bbox/left"/></westlimit>
                                <southlimit xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="bbox/bottom"/></southlimit>
                                <eastlimit xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="bbox/right"/></eastlimit>
                                <northlimit xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="bbox/top"/></northlimit>
                            </SO_AGI_STAC_20230426.Collections.BoundingBox>
                        </Boundary>
                        <Geometry xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="geometry"/></Geometry>
                        <Assets xmlns="http://www.interlis.ch/INTERLIS2.3">
                            <xsl:for-each select="../../fileFormats/fileFormat">
                                <xsl:variable name="assetIdentifierTmp" select="concat(../../identifier, '.', abbreviation)"/>
                                <xsl:variable name="assetIdentifier">
                                    <xsl:choose>
                                        <xsl:when test="$itemsNo > 1">
                                            <xsl:value-of select="concat($itemIdentifier, '.', ../../identifier, '.', abbreviation)"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$assetIdentifierTmp" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                    <SO_AGI_STAC_20230426.Collections.Asset xmlns="http://www.interlis.ch/INTERLIS2.3">
                                        <Identifier xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="$assetIdentifier"/></Identifier>
                                        <Title xmlns="http://www.interlis.ch/INTERLIS2.3">
                                            <xsl:choose>
                                                <xsl:when test="$itemIdentifier = 'so'"> <!--Kosmetik-->
                                                    <xsl:value-of select="concat(../../title, ' (Kanton Solothurn / ', abbreviation, ')')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="concat($itemIdentifier, ' (', abbreviation, ')')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </Title>
                                        <MediaType xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="mimetype"/></MediaType>
                                        <Href xmlns="http://www.interlis.ch/INTERLIS2.3"><xsl:value-of select="concat(../../downloadHostUrl, '/', ../../identifier, '/aktuell/', $assetIdentifier)"/></Href>
                                    </SO_AGI_STAC_20230426.Collections.Asset>
                            </xsl:for-each>
                        </Assets>
                    </SO_AGI_STAC_20230426.Collections.Item>
                </xsl:for-each>
            </Items>

        </SO_AGI_STAC_20230426.Collections.Collection>

    </xsl:template>

</xsl:stylesheet>