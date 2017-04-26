<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:template match="article" mode="text-fn">  
        <xsl:choose>
            <xsl:when test=".//sub-article[@xml:lang=$TEXT_LANG]//body//p/fn">
                <xsl:apply-templates select=".//sub-article[@xml:lang=$TEXT_LANG]//body" mode="text-fn"/>
            </xsl:when>
            <xsl:when test="./body//p/fn">
                <xsl:apply-templates select="./body" mode="text-fn"/>
            </xsl:when>
        </xsl:choose>            
    </xsl:template>
    <xsl:template match="body" mode="text-fn">
        <div class="articleSection">
            <xsl:attribute name="data-anchor"><xsl:apply-templates select="." mode="text-labels">
                <xsl:with-param name="text">Notes</xsl:with-param>
            </xsl:apply-templates></xsl:attribute>
            <a name="articleSection{$body_index + $q_back + 1}"></a>
            <div class="row">
                <div class="col-md-12 col-sm-12">
                    <h1><xsl:apply-templates select="." mode="text-labels">
                        <xsl:with-param name="text">Notes</xsl:with-param>
                    </xsl:apply-templates></h1>
                </div>
            </div>
            <ul class="refList footnote"> 
                <xsl:apply-templates select=".//p/fn" mode="list-item"></xsl:apply-templates>
            </ul>
        </div>        
    </xsl:template>
    
    <xsl:template match="fn/label">
        <span class="xref big"><xsl:apply-templates select="*|text()"></xsl:apply-templates></span>
    </xsl:template>
    
    <xsl:template match="fn/p">
        <div>
            <xsl:apply-templates select="*|text()"></xsl:apply-templates>
        </div>
    </xsl:template>
    
    <xsl:template match="p//fn">
        
    </xsl:template>
    
    <xsl:template match="back/fn" mode="back-section-content">
        <ul class="refList footnote">
            <xsl:apply-templates select="." mode="list-item"></xsl:apply-templates>
        </ul>
    </xsl:template>
    
    <xsl:template match="back/fn-group" mode="back-section-content">
        <ul class="refList footnote">
            <xsl:apply-templates select="*|text()"></xsl:apply-templates>
        </ul>
    </xsl:template>
</xsl:stylesheet>