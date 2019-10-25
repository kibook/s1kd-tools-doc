<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="pm">
    <xsl:variable name="issueInfo" select="identAndStatusSection/pmAddress/pmIdent/issueInfo"/>
    <xsl:variable name="issueDate" select="identAndStatusSection/pmAddress/pmAddressItems/issueDate"/>
    <content>
      <description>
        <para>
          <xsl:text>The listed changes are introduced in issue </xsl:text>
          <xsl:apply-templates select="$issueInfo" mode="text"/>
          <xsl:text>, dated </xsl:text>
          <xsl:apply-templates select="$issueDate" mode="text"/>
          <xsl:text>, of this publication.</xsl:text>
        </para>
        <table pgwide="1">
          <tgroup cols="2">
            <colspec colname="c1"/>
            <colspec colname="c2"/>
            <thead>
              <row>
                <entry>
                  <para>Data module</para>
                </entry>
                <entry>
                  <para>Reason for update</para>
                </entry>
              </row>
            </thead>
            <tbody>
              <xsl:apply-templates select="." mode="rfus"/>
              <xsl:apply-templates select="content"/>
            </tbody>
          </tgroup>
        </table>
      </description>
    </content>
  </xsl:template>

  <xsl:template match="issueInfo" mode="text">
    <xsl:value-of select="@issueNumber"/>
    <xsl:if test="@inWork != '00'">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@inWork"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="issueDate" mode="text">
    <xsl:value-of select="@year"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@month"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@day"/>
  </xsl:template>

  <xsl:template match="content">
    <xsl:apply-templates select="//pmEntry/dmRef|//pmEntry/dmodule"/>
  </xsl:template>

  <xsl:template match="dmRef"/>

  <xsl:template match="dmodule">
    <xsl:variable name="dmodule" select="."/>
    <xsl:variable name="rfus" select="descendant::reasonForUpdate[@updateHighlight = 1]"/>
    <xsl:for-each select="$rfus">
      <row>
        <xsl:choose>
          <xsl:when test="position() = 1">
            <entry>
              <para>
                <xsl:apply-templates select="$dmodule/identAndStatusSection/dmAddress/dmAddressItems/dmTitle"/>
              </para>
            </entry>
          </xsl:when>
          <xsl:otherwise>
            <entry/>
          </xsl:otherwise>
        </xsl:choose>
        <entry>
          <xsl:for-each select="simplePara">
            <para>
              <xsl:apply-templates/>
            </para>
          </xsl:for-each>
        </entry>
      </row>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
