<%-- This file (processAnita.jsp) is part of the Anita Conti Mapping 
     Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Tue Dec  9 22:22:04 EST 2003
     This file is cc of processWindow.jsp and the old one is in
     processAnitaTEMP.jsp

     This jsp page process the requests from anita.jsp, that
     do not require data checking (i.e. SELECTs and RADIOs in html forms).
     The dim, dimValue pair is used to update the context.
     When done, it redirect to anita.jsp.

     This page ASSUMES that only one CGI parameter is sent from anita.jsp
     and that anything else is invalid. On error, forward to startUp.jsp
--%>

<%-- TODO standard header of ACMS --%>
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

   // Passed all the test; we can update the context and return to anita.jsp
   CONTEXT.value(dim).apply(dimValue);
%>

   <c:redirect url="anita.jsp" >
     <c:param name="userIdReq" value="${userIdReq}" />
   </c:redirect>

<%--
--%>
