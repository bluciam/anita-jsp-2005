<%-- This file (getNewAetherId.jsp) is part of the Anita Conti 
     Mapping Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Sat Apr 19 20:24:05 EST 2003.

     This page will create a new aetherId number. This page is 
     only called from processShare when a new aether is required.
     If not it will forward to startUp.jsp.

     The new aether id number will be forwarded to newAether.jsp
--%>

<%@ page import="intense.*" %>
<%@ page import="concurrent.*" %>
<%@ page import="ijsp.context.*" %>

<%@ page import="cgi.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>


<%-- Forward to startUp.jsp if any of the parameter,value pairs
     is missing or the user is not in the list of users.
--%>

<%
   AEther CONTEXT = AEtherManager.aether();

   String dim, dimValue;
   CGIManager manager = new CGIManager(request);
   String userIdReq = null, validate = null;
   try {
     userIdReq = manager.get("userIdReq");
     validate = manager.get("validate");
   } catch (Throwable t) {
%>
     <jsp:forward page="startUp.jsp" />
<%   
   }

// Get the sequence of aether numbers and assign the next available.
   String aetherIdString;
   Sequence tempAether = (Sequence)application.getAttribute("aetherId");
   if (tempAether == null) { //need new aether sequence
      Sequence aetherId = new Sequence();
      application.setAttribute("aetherId", aetherId);
      aetherIdString = Long.toString(aetherId.next());
   } else { //tempAether holds last assigned aether id
     aetherIdString = Long.toString(tempAether.next());
   }
%>

<%-- start debug --%>
   aetherId value=<%=aetherIdString %> <br>
   userIdReq value=<%=userIdReq %>
<%-- end debug --%>

<%-- The prefix A designs an AEther and distinguishes it from users --%>
   <c:redirect url="newAether.jsp">
      <c:param name="aetherId" >
         A<%=aetherIdString %>
      </c:param>
      <c:param name="userIdReq" >
         <%=userIdReq %>
      </c:param>
   </c:redirect>


<%-- TODO: Why are there two? Is this one not working?
   <jsp:forward page="newAether.jsp">
      <jsp:param name="aetherId" value="A<%=aetherIdString %>" />
      <jsp:param name="userIdReq" value="<%=userIdReq %>" />
   </jsp:forward>
--%>


