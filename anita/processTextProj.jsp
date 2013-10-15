<%-- This file (processTextProj.jsp) is part of the Anita Conti Mapping 
     Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Sun Jan 11 13:09:54 EST 2004

     This page processes changes in projections paramters. Longitudes are
     assumed to be between -360 and 360 and Latitudes between -90 and 90.
     Pending is checking values depending on projection which for now
     i dont really know them.

     This page ASSUMES that only one CGI parameter is sent from anita.jsp
     and that anything else is invalid. On any error, forward to startUp.jsp

     Last-last update: Sun Jul 18 21:24:46 EST 2004
     Getting rid of all the set bases because they do not notify participant. 
     TODO: clean out code and put MLs.
--%>

<%-- TODO standard header of ACMS --%>
<%-- TODO clean code, a lot of garbage --%>
This is processTextProj.jsp (Must replace for standard header of ACMS)

<br> <br>
At this point, it is the user's responsibilities to make sure
that the values make a coherent map. There is very little
error checking (voir none) and pscoast might crash.
<br>

<%@ page import="intense.*" %>
<%@ page import="ijsp.context.*" %>

<%@ page import="cgi.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>


<%
   AEther CONTEXT = AEtherManager.aether();

   String dim = null, dimValue = null;
   String userIdReq = null;
   try {
      //Getting the cgi arguments into a hash
      CGIManager manager = new CGIManager(request);
      HashMap hashmap = manager.getArgsHashMap();
      Set keys = hashmap.keySet();
      Collection values = hashmap.values();
      for (Iterator i = keys.iterator(); i.hasNext(); ) {
        dim = (String)(i.next());
        dimValue = (String)(hashmap.get(dim));
      }
      //Extracting userIdReq from dim
      int indice = dim.indexOf(":");
      userIdReq = dim.substring(0,indice);
      pageContext.setAttribute("userIdReq",userIdReq);
      //Checking that the dim has a value already
      String temp = CONTEXT.value(dim).getBase().canonical();
   } catch (Exception e) {
   %>
      <jsp:forward page="startUp.jsp" />
   <%
   }

   // Verify that the nominated userIdReq is a real user  
   String users = CONTEXT.value("status:users").getBase().canonical();
   LinkedList userList = id.ListBaseString.unPack(users);
   if (!userList.contains(userIdReq)) {
   %>
     <jsp:forward page="startUp.jsp" />
   <%
   }

   // Verify if the dimension already exists, if not error  //
   if (CONTEXT.value(dim) == null) {
   %>
     <jsp:forward page="startUp.jsp" />
   <%
   }

//TODO: Trying to get a log window to keep track of errors and users activities,
//but it is crashing when being initialized. 
//The error: Cant connect to X11 window server using ':0.0' as the value
//  of the DISPLAY variable.
//TextAreaFrame commandLogFrame;
//commandLogFrame = new TextAreaFrame("User" + userIdReq + " command log:\n\n");


   boolean problem = false; 

   try { // if value is a valid number
      float number = Float.parseFloat(dimValue);
      if (dim.matches(".*lat.*")) { // entre -90 y 90
         if (number >= -90.0 && number <= 90.0) {
             CONTEXT.value(dim).apply(dimValue);
         } else {
            problem = true;
         %> <br>
            <%= dimValue %> is not a valid value for Latitude.
            <br> The value must be between 90 and -90. <br>
            Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
         <%
         }
      } else if (dim.matches(".*lon.*")) { // entre -360 y 360
         if (number >= -360.0 && number <= 360.0) {
             CONTEXT.value(dim).apply(dimValue);
         } else {
            problem = true;
         %> <br>
            <%= dimValue %> is not a valid value for Longitude.
            <br> The value must be between -360 and 360. <br>
            Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
         <% 
         }
      }
   } catch (Exception e) {
     problem = true;
   %>
      <%= dimValue %> is not a valid number for Longitude or Latitude.
      <br> <br>
      Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
   <%
   }

      if (!problem) {
         %>
         <br> There are no problems, lets redirect to anita.jsp
         <br>Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
         <c:redirect url="anita.jsp" >
           <c:param name="userIdReq" value="${userIdReq}" />
         </c:redirect>
         <%
      }

   %>

<%-- To delete, this is region dependent...
   // Checking that the region is consistent
   String norte = CONTEXT.value(partDim + "north").getBase().canonical();
   String sur   = CONTEXT.value(partDim + "south").getBase().canonical();
   String oeste = CONTEXT.value(partDim + "west").getBase().canonical();
   String este  = CONTEXT.value(partDim + "east").getBase().canonical();
   if ((Float.parseFloat(norte) <= Float.parseFloat(sur)) ||
       (Float.parseFloat(este) <= Float.parseFloat(oeste))) {
      problem = true;
   %>
      <br><br>There is a consistency problem in the REGION values. <br>
      North must be greater than South and East must be bigger than West<br>
      Values are going to old ones and forwarding to anita.jsp<br> <br> 
      N = <%= norte %> <br>
      S = <%= sur %> <br>
      E = <%= este %> <br>
      W = <%= oeste %> <br>
      <br>Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
   <%
      // restoring old values
      CONTEXT.value(partDim + "north").apply(Onorte);
      CONTEXT.value(partDim + "south").apply(Osur);
      CONTEXT.value(partDim + "west").apply(Ooeste);
      CONTEXT.value(partDim + "east").apply(Oeste);
   } else {
      float dlat = Float.parseFloat(norte) - Float.parseFloat(sur);
      float dlon = Float.parseFloat(este) - Float.parseFloat(oeste);
      if (dlat > 180 || dlon > 360) { //out of range
         problem = true;
         %><br> The range of the longitude values must be less than 360 
         and of the latitude values less than 180.
         <br>Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
          <%
          // restoring old values
          CONTEXT.value(partDim + "north").apply(Onorte);
          CONTEXT.value(partDim + "south").apply(Osur);
          CONTEXT.value(partDim + "west").apply(Ooeste);
          CONTEXT.value(partDim + "east").apply(Oeste);
      }
      if (!problem) {
         CONTEXT.value(userIdReq + ":gmt:proj:range:dlat").
                 apply(Float.toString(dlat));
         CONTEXT.value(userIdReq + ":gmt:proj:range:dlon").
                 apply(Float.toString(dlon));
         %>
         <br> There are no problems, lets update dlon and dlat and then
              throuth to redirect to anita.jsp
         <br> <%= dlat %> and <%= dlon %>
         <br>Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
         <c:redirect url="anita.jsp" >
           <c:param name="userIdReq" value="${userIdReq}" />
         </c:redirect>
         <%
      }
   }
   %>
%-->

<%--
Having the redirection at the end, means that all the error meesage
are NOT seen, and the user is directed to the main page. The alternatives
are creating a log window and/or inserting the lot in the intro.jsp
or help page.

<c:redirect url="anita.jsp" >
  <c:param name="userIdReq" value="${userIdReq}" />
</c:redirect>
--%>
