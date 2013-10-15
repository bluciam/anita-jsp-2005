<%-- This file (anita.jsp) is part of the Anita Conti Mapping 
     Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Tue Dec  9 14:19:13 EST 2003
     This jsp page displays the interface Webpage and waits for 
     input.  Depending on the input, control is forwarded to the
     appropriate process page.

     If the query request does not include a userIdReq number,
     or CONTEXT is empty, it is redirected to startUp.jsp. 
     Any other times when it needs to?

     To get the language strings for the multilingual webpage, 
     the subtitles bean used.


     Start to work on it again: Mon Jul 12 08:44:04 EST 2004
     Getting rid of all references to session and map, since 
     we will ignore session for now.
--%>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="intense.*" %>
<%@ page import="ijsp.context.*" %>
<%@ page import="cgi.*" %>
<%@ page import="java.text.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<%
// try { // not sure i want that try...
%>

<% AEther CONTEXT = AEtherManager.aether(); 
   String userIdReq = null;
%>

<%-- Forward to startUp.jsp is there is no userIdReq value in the 
     query request; or the value of userIdReq is not a user; or
     if the CONTEXT is empty.
--%>
<%
   try {
      CGIManager manager = new CGIManager(request);
      userIdReq = manager.get("userIdReq");
   } catch (Throwable t) {
      %> <jsp:forward page="startUp.jsp" /> <%
   }
   // Verify that the nominated userIdReq is a real user
   try {
      String users = CONTEXT.value("status:users").getBase().canonical();
      LinkedList userList = id.ListBaseString.unPack(users);
      if (!userList.contains(userIdReq) || CONTEXT.value(userIdReq).vanilla()) {
         %> <jsp:forward page="startUp.jsp" /> <%
      }
   } catch (Throwable t) {
      %> <jsp:forward page="startUp.jsp" /> <%
   }
%>
<%-- End of forwarding to startUp.jsp in case of error --%>

<%-- Defining the prefixes for each of the shareable dimensions. 
     In this implementation only gmt and interface are valid sharing
     dimensions. The values of info:shareLevel:gmt and
     info:shareLevel:interface are assumed to be aetherId or empty string.

     TODO: there might be no prefixes needed.
--%>

<%--
<% String gmtPrefix   = userIdReq;
   String interPrefix = userIdReq;

   if (CONTEXT.value(userIdReq+":info:shareLevel").getBase().canonical().
               equals("on")) {
      if (!(CONTEXT.value(userIdReq+":info:shareLevel:gmt").getBase().
                    canonical().equals(""))) {
         gmtPrefix = 
           userIdReq + ":" +
           CONTEXT.value(userIdReq+":info:shareLevel:gmt").getBase().canonical()
         ;
      }
      if (!CONTEXT.value(userIdReq+":info:shareLevel:interface").getBase().
                   canonical().equals("")) {
         interPrefix = 
           userIdReq + ":" + CONTEXT.
           value(userIdReq+":info:shareLevel:interface").getBase().canonical()
         ;
      }
   }
%>
--%>

<%-- TODO get rid of the prefixes --%>
<%
   String gmtPrefix   = userIdReq;
   String interPrefix = userIdReq;

// Trying to auto map making when the context changes
%>

<%--
   if (CONTEXT.value(userIdReq + ":gmt:makeMap").equals("yes")) {
%>
      <c:redirect url="makeMap.jsp" >
         <c:param name="userIdReq" value="${userIdReq}" />
      </c:redirect>
<%
   }
%>
--%>

<%-- Updating the access datestamp of user --%>
<%
   String dim = null, dimValue = null;

   DateFormat df = DateFormat.
                   getDateTimeInstance(DateFormat.FULL, DateFormat.FULL);
   String theDate = df.format(new Date());
   CONTEXT.value(userIdReq + ":info:dateStamp:lastAccess").apply(theDate);
%>

<%-- To get the ML strings for the Web Page, a bean is used. 
     If the bean exists, the bean is associated with the scripting variable
     (subtitle), otherwise, a new instance of the class is created. 
     The langValue property of the subtitles bean is set with the value 
     of the lgIn dimension of the CONTEXT, retrieving the correct
     version of the strings. (p128 JSP)  
--%>
<jsp:useBean id="subtitles" scope="application" class="id.SubTitles" />
<jsp:setProperty name="subtitles" property="langValue" 
     value="<%= CONTEXT.value(interPrefix+":interface:lgIn").getBase().canonical() %>" />


<%-- Lay out of the webpage --%>

<HTML>
  <HEAD>
<%--
--%>
     <script language="JavaScript">
       // This will resize the window when it is opened or when
       // refresh/reload is clicked to the width and height given.
       window.resizeTo(
              <%= CONTEXT.value(interPrefix+":window:width").
                          getBase().canonical() %>,
              <%= CONTEXT.value(interPrefix+":window:height").
                          getBase().canonical() %>
       )
       window.screenX=<%= CONTEXT.value(interPrefix+":window:ULx").
                          getBase().canonical() %>
       window.screenY=<%= CONTEXT.value(interPrefix+":window:ULy").
                          getBase().canonical() %>
     </script>

    <TITLE><%= userIdReq %> This is anita.jsp</TITLE> 
  </HEAD>

<%
  String bg = CONTEXT.value(interPrefix+":interface:color:backg").
                      getBase().canonical();
  String tx = CONTEXT.value(interPrefix+":interface:color:text").
                      getBase().canonical();
%>
  <BODY bgcolor="<%= bg %>" text="<%= tx %>">

<%-- General info about user (wherever available) 
     TODO ML strings need updating here... --%>
    <TABLE ALIGN="right">
      <TR><TD>
      <FONT SIZE="2"><%=subtitles.getUserId()%> <%=userIdReq%></FONT>
<%
   if (CONTEXT.value(userIdReq + ":info:name").getBase() != null) {
%>
      <FONT SIZE="2"><br><%=subtitles.getYouAre()%>
      <%= CONTEXT.value(userIdReq + ":info:name").getBase().canonical() %>.
      </FONT></TD>
      <TD>&nbsp;&nbsp;</TD>
<% 
   }
   if (CONTEXT.value(userIdReq+":info:shareLevel").getBase().canonical().
               equals("on")) {
%>
      <TD>
      <FONT SIZE="-1"><%=subtitles.getConnected()%> <br>
<%
      String eteres = CONTEXT.value(userIdReq+":info:shareLevel:aetherList").
                              getBase().canonical();
      LinkedList eterList = id.ListBaseString.unPack(eteres);
      Iterator itr = eterList.iterator();
      while (itr.hasNext()) { 
         String type = null;
         String thisEter = (String)itr.next();
         // Updating the access dateStamp for the aether
         theDate = df.format(new Date());

//         theDate = new java.util.Date().toString();
         CONTEXT.value(thisEter + ":info:dateStamp:lastAccess").apply(theDate);
         // Printing users connections to the Aether
         dim = userIdReq + ":" + thisEter;
         try { 
            type = CONTEXT.value(dim + ":info:gmt").getBase().canonical();
            %> <%= thisEter %> <i>gmt</i>:  <%= type %><br>  <%
         } catch (Exception e) {
         }
         try { 
            type = CONTEXT.value(dim + ":info:interface").getBase().canonical();
            %> <%= thisEter %> <i>interface</i>:  <%= type %><br>  <%
         } catch (Exception e) {
         }
      }
%>
      </FONT> 
      </TD></TR>
<%
   } // endif shareLevel == on
%>
    </TABLE>
    <H1><%=subtitles.getTitle()%></H1>
<%-- TODO: next title needs to be included in subtitles bean 
    <h2>A collaborative system</h2>
--%>

   <FORM action=processAnita.jsp method="GET">

   <A HREF="intro.jsp?userIdReq=<%=userIdReq%>"><%= subtitles.getIntro() %></A>

   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

   <%= subtitles.getShare() %> : 
   <% dim = userIdReq + ":info:shareLevel"; 
   if (CONTEXT.value(dim).getBase().canonical().equals("on")) { 
%>
     <%= subtitles.getYes() %>
<% 
   } else {
%>
      <%= subtitles.getNo()  %>
<%
   }
%>
   <SELECT NAME=<%= dim %>>


<%
//   if (CONTEXT.value(userIdReq+":info:shareLevel").getBase().canonical().
   if (CONTEXT.value(dim).getBase().canonical().equals("on")) {//shareLevel=on
%>
<%--
     <%= optionSelectShare(dim , "change", subtitles.getChange() ) %>
--%>
     <%= optionSelectShare(dim , "off", subtitles.getNo() ) %>
<%
   } else { // shareLevel = off
%>
     <%= optionSelectShare(dim , "on", subtitles.getYes() ) %>
<%--
     <%= optionSelectShare(dim , "change", subtitles.getChange() ) %>
--%>
<%
   }

   String mapNumber = CONTEXT.value(userIdReq + ":info:currentMap").
                              getBase().canonical();
   String currentMap = "users/user" + userIdReq +"/map" + mapNumber + ".png";
%>

   </SELECT>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

   <%= subtitles.getLangInterface() %> 
   <% dim = interPrefix + ":interface:lgIn"; %>
   <SELECT NAME=<%= dim %>>
     <%= optionSelect(dim, "en", "English") %>
     <%= optionSelect(dim, "fr", "Fran&ccedil;ais") %>
     <%= optionSelect(dim, "es", "Espa&ntilde;ol") %>
   </SELECT>

   </FORM>

   <TABLE>
     <TR><TD>
     <FORM ACTION="makeMapFromXY.jsp" METHOD="GET">
       <INPUT type=hidden type=text name=from value="anita"> 
       <INPUT TYPE=image VALUE=map SRC="<%= currentMap %>" BORDER=0>
       <INPUT type=hidden type=text name=userIdReq value=<%= userIdReq %>>
     </FORM>

     </TD><TD>&nbsp;&nbsp;</TD> <TD>

     <FORM>
       <%= subtitles.getLangMap() %> 
       <% dim = gmtPrefix + ":gmt:lgMap"; %>
       <SELECT NAME=<%= dim %>>
         <%= optionSelect(dim, "none", subtitles.getNone() ) %>
         <%= optionSelect(dim, "english", subtitles.getLanguageEn() ) %>
         <%= optionSelect(dim, "francais", subtitles.getLanguageFr() ) %>
         <%= optionSelect(dim, "espanol", subtitles.getLanguageEs() ) %>
         <%= optionSelect(dim, "farsi", subtitles.getLanguageFa() ) %>
         <%= optionSelect(dim, "hindi", subtitles.getLanguageHi() ) %>
         <%= optionSelect(dim, "malayalaman", subtitles.getLanguageMl() ) %>
         <%= optionSelect(dim, "tamil", subtitles.getLanguageTa() ) %>
       </SELECT>

       <br><br>Zooming
<%--       <br><br><%= subtitles.getZoom() %>      --%>
       <% dim = gmtPrefix + ":gmt:proj:zoom"; %>
       <SELECT NAME=<%= dim %>>
       <%= optionSelect(dim, "4", subtitles.getZoomIn() ) %>
       <%= optionSelect(dim, "1", subtitles.getZoomOut() ) %>
       <%= optionSelect(dim, "2", subtitles.getNoZoom() ) %>
       </SELECT>
     </FORM>
     <FORM ACTION="makeMap.jsp" METHOD="GET">
       <input type=hidden type=text name=userIdReq value=<%= userIdReq %>>
       <INPUT NAME=makeMap TYPE=submit 
              VALUE="<%= subtitles.getUpdateMapValue() %>" >
     </FORM>
<%-- 
     <%= subtitles.getPsView() %>
     <A HREF=users/user+Id/currentMap.ps><IMG SRC=here.png></A>
     <br><br>
     TODO: Perhaps here we call makeMap.jsp again and link the postscript.
     the context is in users/user+Id/mapContext+currentMap.context
     Need to find out how to read the file, load it up as contextOp
     to update some context and then run pscoast and psomega.
     A lot of programming work, I'll leave out for now...
     Unless, I save the previous postscript and delete it when a new
     map is created and just link to that. Wait then until going 
     through creating a map ...
--%>

     <FORM>
<%--   TODO: get ML for projection ...     --%>
<%--   Showing the current projection and choosing one  --%>
       <%= subtitles.getProjection() %>   
       <% dim = gmtPrefix + ":gmt:proj"; %>
       <SELECT NAME=<%= dim %>>
       <%= optionSelectProj(dim, "1:M", "Mercator with defaults" ) %>
       <%= optionSelectProj(dim, "2:J", "Miller" ) %>
       <%= optionSelectProj(dim, "2:Q", "Equidistant" ) %>
       <%= optionSelectProj(dim, "2:H", "Hammer" ) %>
       <%= optionSelectProj(dim, "2:I", "Sinusoidal" ) %>
       <%= optionSelectProj(dim, "2:Kf", "Eckert IV" ) %>
       <%= optionSelectProj(dim, "2:Ks", "Eckert VI" ) %>
       <%= optionSelectProj(dim, "2:N", "Robinson" ) %>
       <%= optionSelectProj(dim, "2:R", "Winkel Tripel" ) %>
       <%= optionSelectProj(dim, "2:V", "Van der Grinten" ) %>
       <%= optionSelectProj(dim, "2:W", "Mollweide" ) %>
       <%= optionSelectProj(dim, "3:A", "Lambert azimuthal" ) %>
       <%= optionSelectProj(dim, "3:E", "Azimuthal equidistant" ) %>
       <%= optionSelectProj(dim, "3:G", "Azimuthal ortographic" ) %>
       <%= optionSelectProj(dim, "3:S", "General stereographic" ) %>
       <%= optionSelectProj(dim, "3:C", "Cassini" ) %>
       <%= optionSelectProj(dim, "4:M", "Mercator" ) %>
       <%= optionSelectProj(dim, "4:T", "Transverse Mercator" ) %>
       <%= optionSelectProj(dim, "4:Y", "General Cylindrical" ) %>
<%--
       TODO What am I going to do with this two?
       <%= optionSelectProj(dim, "5:Ob", "Oblique Mercator" ) %>
       <%= optionSelectProj(dim, "5:Oc", "Oblique Mercator: origin/pole" ) %>
--%>
       <%= optionSelectProj(dim, "6:B", "Albers" ) %>
       <%= optionSelectProj(dim, "6:D", "Equidistant conic" ) %>
       <%= optionSelectProj(dim, "6:L", "Lambert conic" ) %>
       </SELECT>
     </FORM>
         <br>
     <DIV align=center>


<%--   Showing the projection parameters and changing them  --%>
<%
     String[] values = new String[2];
     dimValue = CONTEXT.value(dim).getBase().canonical();
     values = dimValue.split(":");
     int projType = Integer.parseInt(values[0]);
     switch(projType) {
       case 6: // lon0, lat0, lat1, lat2
         %> Parallels <br>
         <i>lat<sub>1</sub></i> <%= textProj(dim + ":" + dimValue + ":lat1") %> 
             &nbsp;&nbsp;
         <i>lat<sub>2</sub></i> <%= textProj(dim + ":" + dimValue + ":lat2") %> 
         <br>
<%
       case 4: // lon0, lats
       case 3: // lon0, lat0
         %> Point <br>
         <i>lat<sub>0</sub></i> <%= textProj(dim + ":" + dimValue + ":lat0") %> 
<%
       case 2: // lon0
%>
         &nbsp;&nbsp;
         <i>lon<sub>0</sub></i> <%= textProj(dim + ":" + dimValue + ":lon0") %> 
<%
       break;
     }
%>
     </DIV>
     </TD></TR>
   </TABLE>

   <FORM>

<%--   <TABLE BORDER=0 CELLSPACING=14 CELLPADDING=2> --%>
   <TABLE><TR VALIGN=top>
   <%-- Table with frame, color and region --%>

<%-- Map frame description --%>
<%
     dim = gmtPrefix + ":gmt:frame";
     if (CONTEXT.value(dim).getBase().canonical().equals("on")) {
%>
       <TD><TABLE>
         <tr><div align=center><b><%= subtitles.getFrame() %></b>&nbsp;&nbsp;
             <%= optionRadio(dim, "off", subtitles.getYesFrame() ) %></div>
         </tr>
         <tr><td> <%= subtitles.getSpacing() %></td>
             <td><B>&nbsp;&nbsp;&nbsp;X</B></td>
             <td><B>&nbsp;&nbsp;&nbsp;Y</B></td>
         </tr>
         <tr><td><%= subtitles.getLabel()  %></td>
             <td><%= textAnnot(dim+":x:annot") %><br></td>
             <td><%= textAnnot(dim+":y:annot") %><br></td>
         </tr>
         <tr><td><%= subtitles.getFrame()  %></td>
             <td><%= textAnnot(dim+":x:frame") %><br></td>
             <td><%= textAnnot(dim+":y:frame") %><br></td>
         </tr>
         <tr><td><%= subtitles.getGrid() %></b></td>
             <td><%= textAnnot(dim+":x:grid") %><br></td>
             <td><%= textAnnot(dim+":y:grid") %><br></td>
         </tr>
       </TABLE></TD>
<%
     } else {
%>
       <TD>
         <b><%= subtitles.getFrame() %></b><br>
         <%= optionRadio(dim, "on", subtitles.getNoFrame() ) %>
       </TD>
<%   }
%>

<%-- Map land-color description --%>
     <TD>&nbsp;&nbsp; &nbsp;&nbsp;</TD>
     <TD>
       <B> <%= subtitles.getLandColor() %><br></B>
<%     dim = gmtPrefix + ":gmt:color:land";
       dimValue = CONTEXT.value(dim).getBase().canonical();
       if (dimValue.equals("on")) { %>
          <%= textColor(dim+":red", subtitles.getRed() ) %><br>
          <%= textColor(dim+":green", subtitles.getGreen() ) %><br>
          <%= textColor(dim+":blue", subtitles.getBlue() ) %><br>
          <%= optionRadio(dim, "grey", subtitles.getSwitchGrey()) %>
          <%= optionRadio(dim, "off", subtitles.getNoColor()) %>
<%     } else if (dimValue.equals("grey")) { %>
          <%= textColor(dim+":grey", subtitles.getGrey() ) %><br>
          <%= optionRadio(dim, "on", subtitles.getSwitchColor()) %>
          <%= optionRadio(dim, "off", subtitles.getNoColor()) %>
<%     } else {  %>
          <%= optionRadio(dim, "on", subtitles.getSwitchColor()) %>
          <%= optionRadio(dim, "grey", subtitles.getSwitchGrey()) %>
<%     } %>
     </TD>

<%-- Map water-color description --%>
     <TD>&nbsp;&nbsp; &nbsp;&nbsp;</TD>
     <TD>
       <B> <%= subtitles.getWaterColor() %><br></B>
<%     dim = gmtPrefix + ":gmt:color:water";
       dimValue = CONTEXT.value(dim).getBase().canonical();
       if (dimValue.equals("on")) { %>
          <%= textColor(dim+":red", subtitles.getRed() ) %><br>
          <%= textColor(dim+":green", subtitles.getGreen() ) %><br>
          <%= textColor(dim+":blue", subtitles.getBlue() ) %><br>
          <%= optionRadio(dim, "grey", subtitles.getSwitchGrey()) %>
          <%= optionRadio(dim, "off", subtitles.getNoColor()) %>
<%     } else if (dimValue.equals("grey")) { %>
          <%= textColor(dim+":grey", subtitles.getGrey() ) %><br>
          <%= optionRadio(dim, "on", subtitles.getSwitchColor()) %>
          <%= optionRadio(dim, "off", subtitles.getNoColor()) %>
<%     } else {  %>
          <%= optionRadio(dim, "on", subtitles.getSwitchColor()) %>
          <%= optionRadio(dim, "grey", subtitles.getSwitchGrey()) %>
<%     } %>
     </TD>

<%-- Map region description --%>
     <TD>&nbsp;&nbsp; &nbsp;&nbsp;</TD>
     <TD><B><%= subtitles.getRegion()  %></B>
       <% dim = gmtPrefix + ":gmt:proj:region"; %>
       <table>
          <tr align=center>
             <td></td>
             <td><%= subtitles.getNorth()  %> <br>
                 <%= textReg(dim+":north") %> </td>
             <td></td>
          </tr>
          <tr align=center>
             <td><%= subtitles.getWest()  %> 
                 <%= textReg(dim+":west") %> </td>
             <td></td>
             <td> <%= textReg(dim+":east") %> 
                  <%= subtitles.getEast()  %> </td>
          </tr>
          <tr align=center>
             <td></td>
             <td><%= subtitles.getSouth()  %> <br>
                 <%= textReg(dim+":south") %> </td>
             <td></td>
          </tr>
       </table>

     </TD></TR>
   </TABLE>
   <%-- End of Table with frame, color and region --%>

   <%-- Table with map sides, boundaries, detail, coastlines, rivers --%>
   <%-- Table also include Web page size and colour  --%>
   <TABLE><TR align="left">

<%-- Map region description --%>
     <TD><br><b><%= subtitles.getSwitchSideS()%>:</b><br>
       <table align=center>
        <% String yes  = subtitles.getYes();
           String no   = subtitles.getNo();
           String only = subtitles.getFrameOnly(); %>
        <%=threeChoices(gmtPrefix + ":gmt:frame:side:W",subtitles.getWest(),
                        yes, no, only)%>
        <%=threeChoices(gmtPrefix + ":gmt:frame:side:E",subtitles.getEast(),
                        yes, no, only)%>
        <%=threeChoices(gmtPrefix + ":gmt:frame:side:S",subtitles.getSouth(),
                        yes, no, only)%>
        <%=threeChoices(gmtPrefix + ":gmt:frame:side:N",subtitles.getNorth(),
                        yes, no, only)%>
       </table>
     </TD>

<%-- Map political boundary description --%>
     <% dim = gmtPrefix + ":gmt:contents:borders"; %>
     <TD>&nbsp;&nbsp; &nbsp;&nbsp; </TD>
     <TD align="left">
       <%= subtitles.getBoundary() %> 
       <SELECT NAME=<%= dim %> > 
         <%= optionSelect(dim, "none", subtitles.getNo() ) %>
         <%= optionSelect(dim, "1", subtitles.getNational() ) %>
         <%= optionSelect(dim, "2", subtitles.getState() ) %>
         <%= optionSelect(dim, "3", subtitles.getMarine() ) %>
<%--     <%= optionSelect(dim, "a", "All" ) %>  --%>
       </SELECT>

<%-- Map resolution  --%>
       <% dim = gmtPrefix + ":gmt:contents:resolution"; %>
       <br><br><%= subtitles.getDetail() %> 
       <SELECT NAME=<%= dim %> > 
         <%= optionSelect(dim, "c", subtitles.getCrude() ) %>
         <%= optionSelect(dim, "l", subtitles.getLow() ) %>
         <%= optionSelect(dim, "i", subtitles.getMedium() ) %>
         <%= optionSelect(dim, "h", subtitles.getHigh() ) %>
         <%= optionSelect(dim, "f", subtitles.getFull() ) %>
       </SELECT>

<%-- Map coastlines  --%>
       <% dim = gmtPrefix + ":gmt:contents:coastLines"; %>
       <br><br>
       <SELECT NAME=<%= dim %> > 
         <%= optionSelect(dim, "on", subtitles.getCoastlines() ) %>
         <%= optionSelect(dim, "off", subtitles.getNCoastlines() ) %>
       </SELECT>


<%-- Map description of plotted rivers  --%>
       <% dim = gmtPrefix + ":gmt:contents:rivers"; %>
       <%-- TODO: ML for rivers titles --%>
       <br><br><%= subtitles.getRivers()%>
       <SELECT NAME=<%= dim %> > 
         <%= optionSelect(dim, "none", subtitles.getNo() ) %>
         <%= optionSelect(dim, "a", subtitles.getRivAndCanals() ) %>
         <%= optionSelect(dim, "r", subtitles.getPermRivers() ) %>
         <%= optionSelect(dim, "i", subtitles.getInterRivers() ) %>
         <%= optionSelect(dim, "c", subtitles.getCanals() ) %>
       </SELECT>
     </TD>

     <TD>&nbsp;&nbsp; &nbsp;&nbsp; </TD>

<%-- Background and text color of Web page --%>
     <TD align=center>
       <%-- TODO: ML for page color --%>
       <b> <%= subtitles.getPageColor()%></b><br>
       <% dim = interPrefix + ":interface:color:text"; %>
       <table><tr><td>
       <%= subtitles.getText()%> &nbsp;&nbsp;
       </td><td>
       <SELECT NAME=<%= dim %> >
         <%= optionSelect(dim, "black", subtitles.getBlack() ) %>
         <%= optionSelect(dim, "blue", subtitles.getBlue() ) %>
         <%= optionSelect(dim, "red", subtitles.getRed() ) %>
       </SELECT>
       </td></tr><tr><td>

       <% dim = interPrefix + ":interface:color:backg"; %>
       <%= subtitles.getBackground()%> &nbsp;&nbsp;
       </td><td>
       <SELECT NAME=<%= dim %> >
         <%= optionSelect(dim, "white", subtitles.getWhite() ) %>
         <%= optionSelect(dim, "pink", subtitles.getPink() ) %>
         <%= optionSelect(dim, "lightgreen", subtitles.getLtGreen() ) %>
       </SELECT>
       </td></tr>
       </table>

 <%-- TOCHECK: WHY IS THERE DOUBLE COLON :: FOLOWING ???  
textInput(interPrefix + "::window:ULx",
textInput(interPrefix + "::window:width",
--%>

<%-- Window size for the Web browser --%>
       <%-- TODO: ML for window size --%>
       <br><b><%= subtitles.getWSize()%></b><br> 
       <%= textInput(interPrefix + ":window:width", 
                     "processWindow.jsp", "4", "4") %>
       (<%= subtitles.getWidth()%>) <b>x</b> 
       <%= textInput(interPrefix + ":window:height", 
                     "processWindow.jsp", "4", "4") %>
       (<%= subtitles.getHeight()%>)
       <br><br><b><%= subtitles.getWLocation()%></b><br> 
       <%= textInput(interPrefix + ":window:ULx", 
                     "processWindowLoc.jsp", "4", "4") %> (X) &nbsp;&nbsp;
       <%= textInput(interPrefix + ":window:ULy", 
                     "processWindowLoc.jsp", "4", "4") %> (Y)

     </TD></TR>
   </TABLE>
   <%-- End of Table sides, boundaries, detail, coastlines, rivers
        Web page size and colors --%>

   </FORM>

<%-- <br> <b>Debugging</b> <br><br>
   interface dim =
   <%= AEtherManager.htmlCanonical(CONTEXT.value(userIdReq + ":interface").
                                           canonical()) %>
   <br>

   The current context is
   <%= AEtherManager.htmlCanonical(CONTEXT.canonical()) %>.<br><br>
--%>

  </BODY>
</HTML>




<%-- METHODS methods  m e t h o d s --%> 

<%!  // This method assumes that the first part of the select menu 
     // is already written (<SELECT NAME=...>
     // name and value are ...
     // sarta is the text to add in the language specified by the context.
  String optionSelectNoContext(String name, String value, 
                      String sarta) {
    StringBuffer result = new StringBuffer("<OPTION ");
    result.append(
       "VALUE=" + value +
       " onClick=\"window.location.replace('restart.jsp?" +
       name + "=" + value + "')\">" + sarta + "</OPTION>"
    );
    return result.toString();
  }
%>

<%!  // This method assumes that the first part of the select menu 
     // is already written (<SELECT NAME=...>
     // name and value are ...
     // sarta is the text to add in the language specified by the context.
     // dimValue is the value of the dimension (the name) in the 
     // current context.
  String optionSelectProj(String name, String value, 
                      String sarta) {
    AEther CONTEXT = AEtherManager.aether();
    StringBuffer result = new StringBuffer("<OPTION ");
    String dimValue = CONTEXT.value(name).getBase().canonical(); 
    if (dimValue.equals(value)) {
       result.append("SELECTED ");
    } 
    result.append(
       "VALUE=" + value +
       " onClick=\"window.location.replace('processProj.jsp?" +
       name + "=" + value + "')\">" + sarta + "</OPTION>"
    );
    return result.toString();
  }
%>

<%!  // This method assumes that the first part of the select menu 
     // is already written (<SELECT NAME=...>
     // name and value are ...
     // sarta is the text to add in the language specified by the context.
     // dimValue is the value of the dimension (the name) in the 
     // current context.
  String optionSelect(String name, String value, 
                      String sarta) {
    AEther CONTEXT = AEtherManager.aether();
    StringBuffer result = new StringBuffer("<OPTION ");
    String dimValue = CONTEXT.value(name).getBase().canonical(); 
    if (dimValue.equals(value)) {
       result.append("SELECTED ");
    } 
    result.append(
       "VALUE=" + value +
       " onClick=\"window.location.replace('processAnita.jsp?" +
       name + "=" + value + "')\">" + sarta + "</OPTION>"
    );
    return result.toString();
  }
%>

<%!  // NEED TO REWRITE ....
     // This method assumes that the first part of the select menu 
     // is already written (<SELECT NAME=...>
     // name and value are ...
     // sarta is the text to add in the language specified by the context.
     // dimValue is the value of the dimension (the name) in the 
     // current context.
  String optionSelectShare(String name, String value, 
                      String sarta) {
    AEther CONTEXT = AEtherManager.aether();
    StringBuffer result = new StringBuffer("<OPTION ");
    String dimValue = CONTEXT.value(name).getBase().canonical(); 
    if (dimValue.equals(value)) {
       result.append("SELECTED ");
// this is not needed I think (270104)
    } 
    result.append(
       "VALUE=" + value +
       " onClick=\"window.location.replace('getUserName.jsp?" +
       name + "=" + value + "')\">" + sarta + "</OPTION>"
    );
    return result.toString();
  }
%>

<%! //This method lays out the radio input.
  String optionRadio(String name, String value, 
                      String sarta) {
    AEther CONTEXT = AEtherManager.aether();
    StringBuffer result = new StringBuffer("<INPUT TYPE=RADIO ");
    String dimValue = CONTEXT.value(name).getBase().canonical(); 
    if (dimValue.equals(value)) {
       result.append("CHECKED ");
    } 
    result.append(
       "VALUE=" + value +
       " onClick=\"window.location.replace('processAnita.jsp?" +
       name + "=" + value + "')\">" + sarta + "<br>"
    );
    return result.toString();
  }
%>

<%! //This method lays out the radio input.
  String optionRadioNoBR(String name, String value, 
                      String sarta) {
    AEther CONTEXT = AEtherManager.aether();
    StringBuffer result = new StringBuffer("<INPUT TYPE=RADIO ");
    String dimValue = CONTEXT.value(name).getBase().canonical(); 
    if (dimValue.equals(value)) {
       result.append("CHECKED ");
    } 
    result.append(
       "VALUE=" + value +
       " onClick=\"window.location.replace('processAnita.jsp?" +
       name + "=" + value + "')\">" + sarta + "&nbsp;&nbsp;"
    );
    return result.toString();
  }
%>


<%! //This method typesets the text input field for a color ...
    //It does not use textInput because it also typesets a string (sarta).
  String textColor(String name, String sarta) {
    AEther CONTEXT = AEtherManager.aether();
    String dimValue = CONTEXT.value(name).getBase().canonical(); 
    StringBuffer result = new StringBuffer(
       "<INPUT TYPE=text MAXLENGTH=3 SIZE=3 NAME="
    );
    result.append(
       name + " VALUE=" + dimValue +
       " onChange=\"window.location.replace(\'processTextColor.jsp?" +
       name + "=\'.replace(\'=\', \'=\' + value))\" > " + sarta
    );
    return result.toString();
  }
%>

<%! //This method typesets the text input field for annotation ...
    //by calling textInput with the processing page.
  String textAnnot(String name) {
    return textInput(name, "processTextAnnot.jsp", "4", "4") ;
  }
%>

<%! //This method typesets the text input field for region ...
    //by calling textInput with the processing page.
  String textProj(String name) {
    return textInput(name, "processTextProj.jsp", "6", "6") ;
  }
%>

<%! //This method typesets the text input field for region ...
    //by calling textInput with the processing page.
  String textReg(String name) {
    return textInput(name, "processTextReg.jsp", "6", "6") ;
  }
%>

<%! // This method typesets the text input field to be proccessed
    // by a specific page WITHOUT accompaning label.
    // THIS IS using JAVASCRIPT.
  String textInput(String name, String processPage,
                   String maxlen, String size) {
    AEther CONTEXT = AEtherManager.aether();
    String dimValue = CONTEXT.value(name).getBase().canonical(); 
    StringBuffer result = new StringBuffer(
       "<INPUT TYPE=text MAXLENGTH=" + maxlen + " SIZE=" + size + " NAME="
    );
    result.append(
       name + " VALUE=" + dimValue +
       " onChange=\"window.location.replace(\'" + processPage + "?" +
       name + "=\'.replace(\'=\', \'=\' + value))\" > " 
//       name + "=value\' )\" > " 
    );
    return result.toString();
  }
%>

<%--
<%! // This method typesets the text input field to be proccessed
    // by a specific page WITHOUT accompaning label.
    // THIS IS using FORMS with single entry.
  String textInput(String name, String processPage,
                   String maxlen, String size) {
    AEther CONTEXT = AEtherManager.aether();
    String dimValue = CONTEXT.value(name).getBase().canonical(); 
    StringBuffer result = new StringBuffer(
       "<FORM action=" + processPage + " method=\"GET\">\n" + 
       "<INPUT TYPE=text MAXLENGTH=" + maxlen + " SIZE=" + size + " NAME="
    );
    result.append(
       name + " VALUE=" + dimValue + "\n</FORM>"
    );
    return result.toString();
  }
%>
--%>

<%! //This method typesets the text input field to be proccessed
    //by a specific page WITH accompaning label at left.
  String textInputLabel(String name, String processPage,
                   String maxlen, String size, String sarta) {
    AEther CONTEXT = AEtherManager.aether();
    String dimValue = CONTEXT.value(name).getBase().canonical(); 
    StringBuffer result = new StringBuffer(sarta + 
       " <INPUT TYPE=text MAXLENGTH=" + maxlen + " SIZE=" + size + " NAME="
    );
    result.append(
       name + " VALUE=" + dimValue +
       " onChange=\"window.location.replace(\'" + processPage + "?" +
       name + "=\'.replace(\'=\', \'=\' + value))\" > " 
    );
    return result.toString();
  }
%>


<%! //This method toggles the display between three choices now taylor for 
    //frame sides in a map... 
  String threeChoices(String dim, String side, String yes, String no,
                      String only) {  
    AEther CONTEXT = AEtherManager.aether();
    StringBuffer result = new StringBuffer("<TR><TD>");
    String sideSetting = CONTEXT.value(dim).getBase().canonical();
    if (sideSetting.equals("Y")) {
       result.append("<b>" + side + ":</b> " + yes + "</TD><TD>" + 
                     optionRadioNoBR(dim, "n", no) + "</TD><TD>" +
                     optionRadio(dim, "y", only));
    } else if (sideSetting.equals("y")) {
       result.append("<b>" + side + ":</b> " + only + "</TD><TD>" +
                     optionRadioNoBR(dim, "n", no) + "</TD><TD>" +
                     optionRadio(dim, "Y", yes));
    } else {
       result.append("<b>" + side + ":</b> " + no + "</TD><TD>" +
                     optionRadioNoBR(dim, "Y", yes) + "</TD><TD>" +
                     optionRadio(dim, "y", only));
    }
    result.append("</TD><TR>");
    return result.toString();
  }
%>
  

<%
// } catch (Throwable t) {

//     ByteArrayOutputStream bs = new ByteArrayOutputStream();
//     PrintStream ps = new PrintStream(bs);
//     t.printStackTrace(ps);
//     ps.flush();
//     bs.flush();
%>
<%--
<h3>Caught Throwable:</h3><br>
<pre>
<%= bs.toString() %>
</pre>
--%>
<%
// }
%>
    


