<?xml version="1.0" encoding="utf-8"?>
<!-- Name: Lixia Zhao -->
<!-- Course: Web Tech CSC626-->
<!-- homework 3 -->
<!-- due: 3/23/2015-->
<xsl:stylesheet version="1.1" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:str="http://exslt.org/strings" >
    <xsl:output method="html"/>
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html PUBLIC "XSLT-compat" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"&gt;</xsl:text>
        <html>
            <title>Google Charts</title>
            <head>
                <style>
                body {
                resize: both;
                overflow: auto;
                }</style>
                <!--Load the AJAX API-->
                <script type="text/javascript" src="https://www.google.com/jsapi"></script>
                <!--Load jQuery (to make a responsive webpage)-->
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script> 
            </head>     
            <body>
                
                <h1 style ="color:blue" align="center" > Google Charts</h1>
                <!--Load the Visualization API and the various google chart packages.-->
                <script type="text/javascript"> 
                google.load("visualization", "1.0", {'packages':['corechart','gauge','geochart','annotationchart']});  
                 <!-- draw 5 charts-->
                // instantiates the charts, passes in the data and draw it.
                 function pieChart(data, options, id){
                 var chart = new google.visualization.PieChart(document.getElementById(id));
                chart.draw(data, options);
                }
       
                function gaugeChart(data, options, id){
                var chart = new google.visualization.Gauge(document.getElementById(id));
                chart.draw(data, options);
                setInterval(function() {
                data.setValue(0, 1, 40 + Math.round(60 * Math.random()));
                chart.draw(data, options);
                 }, 13000);
                setInterval(function() {
                data.setValue(1, 1, 40 + Math.round(60 * Math.random()));
                chart.draw(data, options);
                }, 5000);
               setInterval(function() {
               data.setValue(2, 1, 60 + Math.round(20 * Math.random()));
             chart.draw(data, options);
              }, 26000);
             }
                    
               function geoChart(data, options, id){
               var chart = new google.visualization.GeoChart(document.getElementById(id));
               chart.draw(data, options);
               }
               
               function bubbleChart(data, options, id){
               var chart = new google.visualization.BubbleChart(document.getElementById(id));
               chart.draw(data, options);
               }

               function annotationChart(data, options, id){
               var chart = new google.visualization.AnnotationChart(document.getElementById(id));
               chart.draw(data, options);
               }
             
   
              </script>
        <!--==============================================================-->
                <!-- new line-->
                <xsl:text>&#xa;</xsl:text>
                <xsl:for-each select="/charts/chart">
                    <xsl:choose>
                        <xsl:when test="@type = 'pie'">
                            <xsl:call-template name="pieChart" />
                        </xsl:when>
                        <xsl:when test="@type = 'gauge'">
                            <xsl:call-template name="gaugeChart" />       
                        </xsl:when>
                        <xsl:when test="@type = 'geo'">
                            <xsl:call-template name="geoChart" />
                        </xsl:when>
                        <xsl:when test="@type = 'bubble'">
                            <xsl:call-template name="bubbleChart" />
                        </xsl:when>
                        <xsl:when test="@type = 'annotation'">
                            <xsl:call-template name="annotationChart" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
    <!--==============================================================-->
    <xsl:template name="axis">
        '<xsl:choose>
            <xsl:when test="@type = 'h'">hAxis</xsl:when>
            <xsl:when test="@type = 'v'">vAxis</xsl:when>
        </xsl:choose>': {
        title : '<xsl:value-of select="@title" />',
        <xsl:if test="@titleTextStyle != ''">
            titleTextStyle : {
            <xsl:for-each select="str:tokenize(@titleTextStyle, ';')">
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="position() != last()">,</xsl:if>
            </xsl:for-each>
         }</xsl:if>
       },
    </xsl:template>
    <!--==============================================================-->
    <xsl:template name="row">
        [<xsl:choose>
            <xsl:when test="../../columns/column[1][@type = 'string']">'<xsl:value-of select="@name"/>'</xsl:when>
            <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
        </xsl:choose>,<xsl:value-of select="@value"/>]<xsl:if test="position() != last()">,</xsl:if>
    </xsl:template>
    <xsl:template name="Options">
        <xsl:if test="./title">
            'title' : '<xsl:value-of select="./title"/>',
        </xsl:if>
        <xsl:if test="@width">
            'width': <xsl:value-of select="@width"/>,
        </xsl:if>
        <xsl:if test="@height">
            'height': <xsl:value-of select="@height"/>,
        </xsl:if>
        <xsl:if test="./colors/red">
            redFrom:<xsl:value-of select="./colors/red/@from"/>, redTo:<xsl:value-of select="./colors/red/@to"/>,
        </xsl:if>   
        <xsl:if test="./colors/yellow">
            yellowFrom:<xsl:value-of select="./colors/yellow/@from"/>, yellowTo:<xsl:value-of select="./colors/yellow/@to"/>,
        </xsl:if>
        <xsl:if test="./minorTick">
            minorTick:<xsl:value-of select="./minorTick"/>
        </xsl:if>
    </xsl:template>
    <!--==============================================================-->
    <xsl:template name="div">
        <div>
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:attribute name="align">
                <xsl:value-of select="@align"/>
            </xsl:attribute>
        </div>
    </xsl:template>
    
    <!--==============================================================-->
    <!-- pieChart template-->
    <xsl:template name="pieChart">
        <script type="text/javascript">
          // Set a callback to run when the Google Visualization API is loaded.
          google.setOnLoadCallback(function(){
            var data = new google.visualization.DataTable();
            <xsl:for-each select="./columns/column">
               data.addColumn('<xsl:value-of select="@type"/>','<xsl:value-of select="@name"/>');
            </xsl:for-each>
            data.addRows([
               <xsl:for-each select="./rows/row">
                  <xsl:call-template name="row" />
               </xsl:for-each>
            ]);
            
            var options = {
               <xsl:call-template name="Options" />
               is3D: true,
           };

           pieChart(data, options, '<xsl:value-of select="@id"/>');
      });
    </script>
        <xsl:call-template name="div" />
    </xsl:template>
    <!--==============================================================-->
    <!-- gaugeChart template-->
    <xsl:template name="gaugeChart">
        <script type="text/javascript">
      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(function(){
      var data = new google.visualization.DataTable();
      <xsl:for-each select="./columns/column">
        data.addColumn({
          type: '<xsl:value-of select="@type"/>',
          label: '<xsl:value-of select="@name"/>'
        });
      </xsl:for-each>
      data.addRows([
      <xsl:for-each select="./rows/row">
        <xsl:call-template name="row" />
      </xsl:for-each>
      ]);

      var options = {
        <xsl:call-template name="Options" /> 
      };
      gaugeChart(data, options, '<xsl:value-of select="@id"/>');
      });
    </script>
        <h4 align="center">  Computational Resources </h4>
        <xsl:call-template name="div" />
        <div align = "center">
        <input  type="button" value="Go Faster" onclick="setInterva(1)" />
        <input  type="button" value="Slow down" onclick="setInterval(-1)" />
        </div><br/>   
    </xsl:template>
    <!--==============================================================-->
   
    <!--geoChart template-->
    <xsl:template name="geoChart">
        <script type="text/javascript">
      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(function(){
      var data = new google.visualization.DataTable();
      <xsl:for-each select="./columns/column">
        data.addColumn({
        type: '<xsl:value-of select="@type"/>',
        label: '<xsl:value-of select="@name"/>',
        });
      </xsl:for-each>
      data.addRows([
      <xsl:for-each select="./rows/row">
        <xsl:call-template name="row" />
      </xsl:for-each>
      ]);

      var options = {
      <xsl:call-template name="Options" />
      <xsl:if test="./colorAxis">
        'colorAxis' : {
            <xsl:if test="./colorAxis/colors">
              colors: [
                <xsl:for-each select="./colorAxis/colors/color">
                  '<xsl:value-of select="."/>'
                  <xsl:if test="position() != last()">,</xsl:if>
                </xsl:for-each>
              ]
            </xsl:if>
        },
      </xsl:if>
             backgroundColor: '#E0F2F7'
      };
      geoChart(data, options, '<xsl:value-of select="@id"/>');
      });
    </script>
        <h4 align="center">Region GeoChart </h4>
        <xsl:call-template name="div" />
    </xsl:template>
    <!--==============================================================-->
    <!-- bubbleChart template-->
    <xsl:template name="bubbleChart">
        <script type="text/javascript">
      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(function(){
      var data = new google.visualization.DataTable();
      <xsl:for-each select="./columns/column">
        data.addColumn({
          type: '<xsl:value-of select="@type"/>',
          label: '<xsl:value-of select="@name"/>'
        });
      </xsl:for-each>
      data.addRows([
      <xsl:for-each select="./rows/row">
        <xsl:call-template name="row" />
      </xsl:for-each>
      ]);

      var options = {
        <xsl:call-template name="Options" />
        <xsl:for-each select="./axis">
          <xsl:call-template name="axis" />
        </xsl:for-each>
             <xsl:if test="./bubble">
        bubble: {
           <xsl:if test="./bubble/@textStyle != ''" >
             textStyle: {
             <xsl:for-each select="str:tokenize(./bubble/@textStyle, ';')">
               <xsl:value-of select="normalize-space(.)"/>
               <xsl:if test="position() != last()">,</xsl:if>
             </xsl:for-each>
             }
           </xsl:if>
        }
      </xsl:if>
      };
      bubbleChart(data, options, '<xsl:value-of select="@id"/>');
      });
    </script>
        <xsl:call-template name="div" /><br/>
    </xsl:template>
    <!--==============================================================-->
    <!-- annotationChart template-->
    <xsl:template name="annotationChart">
        <script type="text/javascript">
      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(function(){
      var data = new google.visualization.DataTable();
      <xsl:for-each select="./columns/column">
        data.addColumn({
          type: '<xsl:value-of select="@type"/>',
          label: '<xsl:value-of select="@name"/>'
        });
      </xsl:for-each>
      data.addRows([
      <xsl:for-each select="./rows/row">
        <xsl:call-template name="row" />
      </xsl:for-each>
      ]);

      var options = {
        <xsl:call-template name="Options" />
        displayAnnotations: true
      };
      annotationChart(data, options, '<xsl:value-of select="@id"/>');
      });
    </script>
        <h4 align="center">Annotation Chart </h4>
        <xsl:call-template name="div" />
    </xsl:template>
    
 </xsl:stylesheet>
