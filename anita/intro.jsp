<%@ page import="cgi.*" %>
<%
   CGIManager manager = new CGIManager(request);
   String userIdReq = null;

   try {
       userIdReq = manager.get("userIdReq");
   } catch (Throwable t) {
       %> <jsp:forward page="startUp.jsp" /> <%
   }
%>

Some intro to the Mapping Server, links back to Anita Conti...

<A HREF="anita.jsp?userIdReq=<%= userIdReq %>">Back to server</A> 

<p>
When the system detects an error, that would attempt against the
integrity of the aether, it would immediately forward to 
startUp.jsp and start on a new user. 
This could happen when a user purposely enters an errouneous
URL.

<p>
Errors entered when changing values are handled on a one-to-one
basis, telling the user of the problem.

<p>
Your cache must be set to zero, since it can play tricks to you
on loading from the cache (previously produced pages) and not 
actually running the script.
