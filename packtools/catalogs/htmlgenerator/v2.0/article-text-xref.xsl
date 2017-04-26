<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    
    <xsl:variable name="ref" select="//ref"></xsl:variable>
    
    <xsl:template match="xref">
        <a href="#{@rid}" class="goto"><xsl:apply-templates></xsl:apply-templates></a>
    </xsl:template>
    <xsl:template match="xref[@ref-type='equation' or @ref-type='disp-formula']">
        <a href="#{@rid}" class="goto"><span class="sci-ico-fileFormula"></span> <xsl:apply-templates select="*|text()"></xsl:apply-templates></a>
    </xsl:template>
    
    <xsl:template match="xref[@ref-type='fig']">
        <a href="" class="open-asset-modal" data-toggle="modal" data-target="#ModalFig{@rid}">
            <span class="sci-ico-fileFigure"></span> 
            <xsl:apply-templates select="*|text()"></xsl:apply-templates>
        </a>        
    </xsl:template>
    
    <xsl:template match="xref[@ref-type='table']">
        <a href="" class="open-asset-modal" data-toggle="modal" data-target="#ModalTable{@rid}">
            <span class="sci-ico-fileTable"></span> 
            <xsl:apply-templates select="*|text()"></xsl:apply-templates>
        </a>        
    </xsl:template>
    
    <xsl:template match="xref[@ref-type='fn']/sup | sup[xref[@ref-type='fn']]">
        <xsl:apply-templates select="*|text()"></xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="xref[@ref-type='fn']">
        <xsl:variable name="id"><xsl:value-of select="@rid"/></xsl:variable>
        <span class="ref footnote">
            <sup class="xref"><xsl:apply-templates select="sup|text()"></xsl:apply-templates></sup>
            <span class="refCtt closed">
                <xsl:apply-templates select="$article//fn[@id=$id]" mode="xref"></xsl:apply-templates>
            </span>
        </span>
    </xsl:template>
    
    <xsl:template match="xref[@ref-type='bibr']">
        <xsl:variable name="id"><xsl:value-of select="@rid"/></xsl:variable>
        <xsl:variable name="text"><xsl:value-of select="text()"/></xsl:variable>
        <xsl:variable name="elem"><xsl:choose>
            <xsl:when test="contains('1234567890',substring($text,1,1))">sup</xsl:when>
            <xsl:otherwise>strong</xsl:otherwise>
        </xsl:choose></xsl:variable>
        <span class="ref">
            <xsl:element name="{$elem}">
                <xsl:attribute name="class">xref</xsl:attribute>
                <xsl:apply-templates select="sup|text()"></xsl:apply-templates>
            </xsl:element>
            <span class="refCtt closed">
                <xsl:apply-templates select="$article//ref[@id=$id]" mode="xref"></xsl:apply-templates>
            </span>
        </span>
    </xsl:template>
    
    <xsl:template match="contrib/xref">
        <xsl:variable name="rid" select="@rid"/>
        <xsl:apply-templates select="$article//aff[@id=$rid]" mode="xref"/>
        <xsl:apply-templates select="$article//fn[@id=$rid]" mode="xref"/>)
    </xsl:template>
    
    <xsl:template match="text()" mode="xref">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="*" mode="xref">
        <xsl:apply-templates select="*|text()" mode="xref"/>
    </xsl:template>
    
    <xsl:template match="aff" mode="xref">
        <strong>
            <xsl:apply-templates select="." mode="text-labels">
                <xsl:with-param name="text">Affiliation</xsl:with-param>
            </xsl:apply-templates>
        </strong>
        <xsl:text>
            
        </xsl:text>
        <xsl:apply-templates select="."/>
    </xsl:template>
    
    <xsl:template match="fn" mode="xref">
        <xsl:apply-templates select="*|text()" mode="xref"></xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="fn/label" mode="xref">
        <strong class="fn-title"><xsl:apply-templates select="*|text()" mode="xref"/></strong>
    </xsl:template>
    
    <xsl:template match="fn/p" mode="xref">
        <xsl:apply-templates select="*|text()" mode="xref"/>
    </xsl:template>
    
    <xsl:template match="ref" mode="xref">
        <xsl:variable name="url"><xsl:apply-templates select="." mode="url"></xsl:apply-templates></xsl:variable>
        <xsl:if test="label">
            <xsl:if test="substring(mixed-citation,1,string-length(label))!=label"><xsl:value-of select="label"/></xsl:if>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$url!=''">
                <a href="{normalize-space($url)}" target="_blank">
                    <xsl:apply-templates select="mixed-citation" mode="xref"></xsl:apply-templates>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="mixed-citation" mode="xref"></xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="mixed-citation" mode="xref">
        
        <xsl:apply-templates select="*|text()" mode="xref"/>
    </xsl:template>
    
    <xsl:template match="mixed-citation//*" mode="xref">
        <xsl:apply-templates select="*|text()" mode="xref"/>
    </xsl:template>
    
    <xsl:template match="ext-link | pub-id | comment" mode="xref">
        <xsl:value-of select="."/>
    </xsl:template>
</xsl:stylesheet>