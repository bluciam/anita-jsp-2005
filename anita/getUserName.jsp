<%-- This file (getUserName.jsp) is part of the Anita Conti 
     Mapping Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Sun Jul  8 20:16:32 EST 2003

     This jsp page is called by anita.jsp when a sharing option is
     requested by the user: getUserName.jsp?dim=value, where 
     dim is userId:info:shareLevel. If a user name (userId:info:name) 
     exists already it forwards directly to processShare.jsp. If not, it
     ask for one and forwards to processShare.jsp along with all the
     other query request coming from anita.jsp.

     Last-last update Sat Jul 17 19:28:08 EST 2004
     Cleaning out, adapting to new design.
--%>

<%@ page import="intense.*" %>
<%@ page import="ijsp.context.*" %>
<%@ page import="cgi.*" %>
<%@ page import="java.util.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<%-- The program does not know the name of the dimension to verify, 
     (userId is not known in this page) I have to get the CGI args
     into a hash. 
--%>

<%
   String dim = null;
   String shareLevel = null;
   String userIdReq = null;
   try { 
      CGIManager manager = new CGIManager(request);
      HashMap hashmap = manager.getArgsHashMap();
      Set keys = hashmap.keySet();
      Collection values = hashmap.values();
      for (Iterator i = keys.iterator(); i.hasNext(); ) {
        dim = (String)(i.next());
        shareLevel = (String)(hashmap.get(dim));
      }
      //Extracting userIdReq from dim
      int indice = dim.indexOf(":");
      userIdReq = dim.substring(0,indice);
      } catch (Exception e) {
%>
         <jsp:forward page="startUp.jsp" />
<%
      }
%>

<%
   AEther CONTEXT = AEtherManager.aether();

//   String usrName = "";
   if (CONTEXT.value(userIdReq + ":info:name").getBase() != null) {
      //Base value not null
      if (!(CONTEXT.value(userIdReq + ":info:name").getBase().canonical().
                    equals(""))) {
//      usrName = CONTEXT.value(userIdReq + ":info:name").getBase().canonical();
//      if (!usrName.equals("")) {
         pageContext.setAttribute("userIdReq",userIdReq);
         pageContext.setAttribute("shareLevel",shareLevel);
%>

<%--
<br><br>
<c:redirect url="processShare.jsp?userIdReq=${userIdReq}&shareLevel=${shareLevel}&from=getUserName" />
--%>

<%--
again the following does not work the forward url it gets is:
http://localhost:8888/anita/getUserName.jsp?3:info:shareLevel=on
and userName is null obviously
Trying now...
Fri Jul 16 23:38:40 EST 2004
But then is left for tomorrow...
--%>
      <jsp:forward page="processShare.jsp" >
           <jsp:param name="userIdReq" value="<%= userIdReq %>" />
           <jsp:param name="shareLevel" value="<%= shareLevel %>" />
           <jsp:param name="from" value="getUserName" />
      </jsp:forward>

<%
      }
   }
%>

<html>
<head>
<title>getUserName.jsp</title>
</head>
<body>
<h1>
You are user <%= userIdReq %> <br>
</h1>
  <form action=processShare.jsp method=get>
      You are entering collaboration. Other users need to know who you are.<br>
      Please enter your user name or nickname: &nbsp;&nbsp;&nbsp;
      <input type=hidden type=text name=userIdReq value=<%= userIdReq %>>
      <input type=hidden type=text name=shareLevel value=<%= shareLevel %>>
      <input type=hidden type=text name=from value=getUserName>
      <input type=text MAXLENGTH=20 SIZE=10 NAME="userName"> 
  </form>

</body>
</html>
