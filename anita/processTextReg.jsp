<%-- This file (processTextReg.jsp) is part of the Anita Conti Mapping 
     Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Wed Dec 10 14:10:59 EST 2003

     This page processes changes in Region values.  Values are 
     assumed to be between -360 and 360 for east and west and 
     between -90 and 90 for north and south.
     Pending is checking values depending on projection (mercator cannot plot
     the poles, for example).

     This page ASSUMES that only one CGI parameter is sent from anita.jsp
     and that anything else is invalid. On any error, forward to startUp.jsp
--%>

<%-- TODO standard header of ACMS --%>
This is processTextReg.jsp (Must replace for standard header of ACMS)
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

//Trying to get a log window to keep track of errors and users activities,
//but it is crashing when being initialized. 
//The error: Cant connect to X11 window server using ':0.0' as the value
//  of the DISPLAY variable.
//TextAreaFrame commandLogFrame;
//commandLogFrame = new TextAreaFrame("User" + userIdReq + " command log:\n\n");


   //Getting previous values of REGION to check value consistency
   String partDim = userIdReq + ":gmt:proj:region:";
   String Onorte = CONTEXT.value(partDim + "north").getBase().canonical();
   String Osur   = CONTEXT.value(partDim + "south").getBase().canonical();
   String Ooeste = CONTEXT.value(partDim + "west").getBase().canonical();
   String Oeste  = CONTEXT.value(partDim + "east").getBase().canonical();
   boolean problem = false; 

   try { // if value is a valid number
      float number = Float.parseFloat(dimValue);
      if (dim.matches(".*north.*|.*south.*")) { // entre -90 y 90
         if (number >= -90.0 && number <= 90.0) {
             CONTEXT.value(dim).apply(dimValue);
         } else {
            problem = true;
         %> <br>
            <%= dimValue %> is not a valid value for North or South of a map.
            <br> The value must be between 90 and -90. <br>
            Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
         <%
         }
      } else if (dim.matches(".*east.*|.*west.*")) { // entre -360 y 360
         if (number >= -360.0 && number <= 360.0) {
             CONTEXT.value(dim).apply(dimValue);
         } else {
            problem = true;
         %> <br>
            <%= dimValue %> is not a valid value for East or West of a map.
            <br> The value must be between -360 and 360. <br>
            Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
         <% 
         }
      }
   } catch (Exception e) {
     problem = true;
   %>
      <%= dimValue %> is not a valid number  for the region of a map.
      <br> <br>
      Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
   <%
   }


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

<%--
Having the redirection at the end, means that all the error meesage
are NOT seen, and the user is directed to the main page. The alternatives
are creating a log window and/or inserting the lot in the intro.jsp
or help page.

<c:redirect url="anita.jsp" >
  <c:param name="userIdReq" value="${userIdReq}" />
</c:redirect>
--%>
