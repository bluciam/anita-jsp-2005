<%-- This file (listener.jsp) is part of the Anita Conti Mapping 
     Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Sun Jul 13 14:37:39 EST 2003

     This page is called by join.jsp to start the applet which will be
     participant to the node, and when notified, it will reload the
     [anita.jsp] page based on the values on CONTEXT, previously changed
     by the ListenerParticipant (the participant in charge of updating
     the context for the user).  This page will be called once for 
     each node to attach.

     The applet will open a new window with listenerAnita.jsp, which 
     will redirect to anita.jsp and refresh when it gets the 
     signal from the applet.

     Last-last update: Sat Jul 31 16:49:23 CDT 2004
     Changing the listening node to be what used to be personal.
     The personal branch is now stored and restored after joining
     and detaching (not implemented) respectively. 
--%>

<%-- TODO: put comments in for code not recognozible  --%>

<%@ page import="cgi.*" %>
<%@ page import="ijsp.context.*" %>
<%@ page import="java.io.*" %>

<HTML>
   <HEAD>
     <script language="JavaScript">
     // This will resize the window when it is opened or
     // refresh/reload is clicked to a width and height of 500 x 100
     // with is placed first, height is placed second
     window.resizeTo(500, 100)
     </script>
   </HEAD>

<%-- Getting the parameters to form the string to call the applet --%>
<%
   try {
      CGIManager manager = new CGIManager(request);
      String targetUrl = manager.get("targetUrl");
      String target = manager.get("target");
      String dimension = manager.get("dimension");
      String aetherId = manager.get("aetherId");
      String userId = manager.get("userIdReq");
      String status = manager.get("status");

// Get the (singletons) participant server and a participant id:
      ParticipantServer server =
          ParticipantServerManager.instance(getServletContext()).server();
      long participantId = server.getNewParticipantId();

      ParticipantServer.AppletParamMap otros = new ParticipantServer.AppletParamMap();
      otros.insertParam("USERID", userId);
      otros.insertParam("AETHERID", aetherId);
      otros.insertParam("TARGET", target);

      String appletHtml = server.getAppletHtml(
          participantId, status, dimension,
          "ListenerParticipantApplet.class",
          null, null, null, otros, "Listener" + userId, targetUrl, 500, 100
      );
%>

   <%= appletHtml %>

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

</HTML>
