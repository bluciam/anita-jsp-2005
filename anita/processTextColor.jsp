<%-- This file (processTextColor.jsp) is part of the Anita Conti Mapping 
     Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Wed Dec 10 13:09:55 EST 2003

     This page processes any change in color value. Any color is 
     assumed to be between 0 and 255.  

     This page ASSUMES that only one CGI parameter is sent from anita.jsp
     and that anything else is invalid. On any error, forward to startUp.jsp
--%>

<%-- TODO standard header of ACMS --%>
This is processTextColor.jsp (Must replace for standard header of ACMS)
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
%>

<%-- we will try 
  <br> <%= keys %> <br> <%= values  %> <br> <br>
  <%= dim %> maps to <%= hashmap.get(dim) %> <br>
finishing trying --%>

<%
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

   // Verify that the value is a number between 0 and 255
   // if so, update context and forward to anita.
   String number = "[0-9]+";
   if (dimValue.matches(number) && (Integer.parseInt(dimValue) >= 0)
                                && (Integer.parseInt(dimValue) <= 255)) {
      CONTEXT.value(dim).apply(dimValue);
   %>
      <c:redirect url="anita.jsp" >
        <c:param name="userIdReq" value="${userIdReq}" />
      </c:redirect>
   <%
   } else {
   %>
     <br>
     <%= dimValue %> is not a valid value for color. It must be
     a number between 0 and 255. <br>
     Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
   <%
   }

%>


<%--

<c:redirect url="anita.jsp" >
  <c:param name="userIdReq" value="${userIdReq}" />
</c:redirect>

--%>
