<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:transform
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    
    <xsl:output method="html"  indent="no"/>
    
    <xsl:template match="*[@target='EmbeddedReports']"/>
    
    <xsl:template match="Title"/>
    
    <xsl:template match="Type">
        <xsl:element name="html">
            
            <xsl:element name="body">
                <xsl:apply-templates/>
                <!--
                <xsl:choose>
                    <xsl:when test="./@type='exporter' or ./@type='shared' or ./@type='table_data' or ./@type='tables'">
                        
                        <xsl:element name="h1">
                            <xsl:value-of select="./Title"/>
                        </xsl:element>
                        
                        <xsl:apply-templates/>
                        
                    </xsl:when>
                    <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
                </xsl:choose>
                -->
            </xsl:element>
            
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="body">
        <xsl:choose>
            <xsl:when test="../@type='enums'">
                <xsl:element name="ul">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="../@type='exporter' or ../@type='table_data' ">
                <xsl:element name="table"><xsl:element name="tbody">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:text>JSON Object</xsl:text>
                        </xsl:element>
                        <xsl:for-each select="Item[1]/Field/@name">
                            <xsl:element name="th">
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                    <xsl:apply-templates/>
                    
                </xsl:element></xsl:element>
                
            </xsl:when>
            
            <xsl:when test="../@type='shared' or ../@type='tables' ">
                <xsl:element name="table"><xsl:element name="tbody">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:text>Data Object</xsl:text>
                        </xsl:element>
                        <xsl:for-each select="Item[1]/Field/@name">
                            <xsl:element name="th">
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                    <xsl:apply-templates/>
                    
                </xsl:element></xsl:element>
                
            </xsl:when>
            
            
            
            <xsl:when test="../@type='table'">
                <xsl:element name="ul">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            
            
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="Item">
        <xsl:choose>
            <xsl:when test="../../@type='enums'">
                <xsl:element name="li"><xsl:element name="p">
                    <xsl:element name="code">
                        <xsl:value-of select="@name" />
                    </xsl:element>
                    <xsl:text>:</xsl:text>
                </xsl:element>
                    <xsl:apply-templates/><!--</xsl:element>-->
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="../../@type='exporter' or ../../@type='shared' or ../../@type='table_data' or ../../@type='tables'">
                <xsl:element name="tr">
                    <xsl:element name="td">
                        <xsl:value-of select="@name" />
                    </xsl:element>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <!--
            <xsl:when test="../../@type='table'">
                <xsl:element name="tr">
                    <xsl:element name="td">
                        <xsl:element name="p">
                            <xsl:value-of select="@name" />
                        </xsl:element>
                    </xsl:element>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            -->
            
            
            <xsl:when test="../../@type='table'">
                <xsl:element name="li"><xsl:element name="p">
                    <xsl:element name="code">
                    <xsl:value-of select="@name" />
                    </xsl:element>
                    <xsl:text>: </xsl:text>
                    <xsl:apply-templates/>
                </xsl:element></xsl:element>
            </xsl:when>
            
            
            
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="Field">
        <xsl:choose>
            <xsl:when test="../../../@type='enums'">
                <xsl:if test=". != ''">
                    <xsl:apply-templates/>
                </xsl:if>
            </xsl:when>
            
            <xsl:when test="../../../@type='exporter' or ../../../@type='shared' or ../../../@type='table_data' or ../../../@type='tables'">
                <xsl:element name="td">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="../../../@type='table'">
                <xsl:if test="@name='Description'">
                    <xsl:apply-templates/>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:element name="p">
        <xsl:choose>
            <xsl:when test="../@name='Unit'">
                <xsl:text>Units: </xsl:text><xsl:value-of select="."/>
            </xsl:when>
            
            <xsl:when test="starts-with(., '/')">
                <xsl:element name="a">
                    <xsl:variable name="ref" select="substring-after(., '/')"/>
                    <xsl:variable name="name" select="substring-after($ref, '/')"/>
                    <xsl:attribute name="href"><xsl:text>../</xsl:text><xsl:value-of select="replace($ref, '.xml', '.html')"/></xsl:attribute>
                    <!--<xsl:attribute name="href"><xsl:value-of select="replace($ref, '.xml', '.html')"/></xsl:attribute>-->
                    <xsl:value-of select="$name"/>
                </xsl:element>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xref">
        <xsl:element name="a">
            <xsl:variable name="ref" select="@href"/>
            <xsl:attribute name="href"><xsl:text>..</xsl:text><xsl:value-of select="replace($ref, '.xml', '.html')"/></xsl:attribute>
            <!--
            <xsl:choose>
                <xsl:when test="starts-with(@href, '/')">
                    <xsl:variable name="ref" select="substring-after(@href, '/')"/>
                    <xsl:attribute name="href"><xsl:value-of select="replace($ref, '.xml', '.html')"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="ref" select="@href"/>
                    <xsl:attribute name="href"><xsl:value-of select="replace($ref, '.xml', '.html')"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            -->
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="a">
        <xsl:element name="a">
            <xsl:attribute name="href"><xsl:value-of select="@href" /></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ul">
        <xsl:element name="ul">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="li">
        <xsl:element name="li">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
</xsl:transform>

<!--
    <xsl:template match="Item">
        <xsl:element name="li">
            <xsl:element name="p">
                <xsl:value-of select="@name" />
            </xsl:element>
            <xsl:element name="ul">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="Field">
        <xsl:element name="li">
            <xsl:element name="p">
                <xsl:value-of select="@name" />
            </xsl:element>
            <xsl:element name="p">
                <xsl:apply-templates/>
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    -->
