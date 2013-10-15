<%-- This file (listenerAnita.jsp) is part of the Anita Conti Mapping 
     Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Sun Jul 13 16:41:50 EST 2003

     This page is loaded by the applet (ListenerParticipantApplet.class)
     and is used simply to link the window to the applet (so it knows
     who to refresh) and redirect to anita.jsp
--%>


<%@ page import="intense.*" %>
<%@ page import="cgi.*" %>
<%@ page import="ijsp.context.*" %>
<%@ page import="java.io.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<%
   try {
      String userIdReq = request.getParameter("userIdReq");
      String aetherId = request.getParameter("aetherId");
      String dimension = request.getParameter("dimension");
      String target = request.getParameter("target");

//      String target = "anita.jsp";

      pageContext.setAttribute("userIdReq",userIdReq);
      pageContext.setAttribute("target",target);

      String pId = request.getParameter("participantId");
      long participantId = Long.parseLong(pId);
%>

<%-- Get the (singletons) participant server and wait for the participant
     applet connection (which should have already happened by the time this
     page loads; i.e., the semaphore for the given participantId should have
     been incremented, so the waitForConnection() call should return
     immediately: So why do i need to poke the ParticipantServer 
--%>

<%
   ParticipantServer server =
        ParticipantServerManager.instance(getServletContext()).server();

// Getting this participant
   Participant participant = server.getParticipant(participantId);

// Storing in the CONTEXT the participantId of the applet, see if we 
// can leave in processShare with this...
// TODO: understand this comment!

/* need to get the node for dimension A1:node. If adding nodes at different
   level, might think this through. How is it begin stored here and 
   at applet participant level?
   If put in this page, this following will be done everytime the signal
   to reload comes through. But if I put in listener.jsp and if the applet
   does not start, we have false information... because we assume that as
   soon as is stored in the CONTEXT, the participant exists.
*/

   AEther CONTEXT = AEtherManager.aether();
   String[] dims = dimension.split(":");
   CONTEXT.value(userIdReq + ":" + aetherId + ":info:" + dims[1] + ":pId").
//   CONTEXT.value(userIdReq + ":" + aetherId + ":info:" + dimension + ":pId").
           apply(pId);
%>

   <HTML>
   <HEAD>
      <TITLE>listenerAnita</TITLE>
   </HEAD>
   <BODY>
<%--
     <br>node is <%= dims[1] %> and value 
     <%= userIdReq + ":" + aetherId + ":info:" + dims[1] + ":pId" %>.
--%>
     <br>node is <%= dimension %> and value 
     <%= userIdReq + ":" + aetherId + ":info:" + dimension + ":pId" %>.
     <br><br>
     You are a listener, with participantId <%= participantId %><br>
     at dimension <%= dimension %> in aether <%= aetherId %>. <p>

     Return to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a><hr>

<%--
--%>
     <c:redirect url="${target}" >
       <c:param name="userIdReq" value="${userIdReq}" />
     </c:redirect>

<%

   } catch (Throwable t) {
      ByteArrayOutputStream exceptionOutput = new ByteArrayOutputStream();
      PrintStream exceptionPrintStream = new PrintStream(exceptionOutput);
      t.printStackTrace(exceptionPrintStream);
      exceptionPrintStream.flush();
%>
      Caught exception:<br>
      <pre> <%= exceptionOutput.toString() %> </pre>
<%
   }
%>

   </BODY>
   </HTML>

