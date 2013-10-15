<%-- This file (makeMapFromXY.jsp) is part of the Anita Conti Mapping
     Server, copyright and left Blanca Mancilla 2003.
     Fri Apr 29 00:58:52 EST 2005

     This jsp page... what does it do?

--%>

<%@ page import="intense.*" %>
<%@ page import="ijsp.context.*" %>

<%@ page import="cgi.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<%-- BEGIN input error checking
     Forward to startUp.jsp is there is any problem in the query request:
     * If there are any missing arguments
     * makeMapFromXY.jsp is not being called from the anita.jsp
     * there is no userIdReq value in the query request
     * the value of userIdReq is not a user
     * or if the CONTEXT is empty.
     * any other?
--%>

<%
   AEther CONTEXT = AEtherManager.aether();
   String userIdReq = null;
   int x = 0, y = 0;

   try {
      //Getting the cgi arguments into a hash
      CGIManager manager = new CGIManager(request);
      HashMap hashmap = manager.getArgsHashMap();
      Set keys = hashmap.keySet();
      Collection values = hashmap.values();
      userIdReq = (String)(hashmap.get("userIdReq"));
      x = Integer.parseInt((String)(hashmap.get("x")));
      y = Integer.parseInt((String)(hashmap.get("y")));
      String from = (String)(hashmap.get("from"));
      if (!from.equals("anita")) {
         %> <jsp:forward page="startUp.jsp" /> <%
     }
   } catch (Exception e) { // if any CGI is wrong, just redirect
   %>
      <jsp:forward page="startUp.jsp" />
   <%
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
<%-- END input error checking --%>




<%= userIdReq %> and <%= x %> and <%= y %> <br>
<% 



%>

<%--
TODO
Need to make sure that the range stays between -90 and 90 
and -360 and 360.
Will be tricky to adjust to back down... must look in ise.

To acually build a map, we need the context of the previous map, 
we need the region, proj, width and units and all that stuff,
to send to getGeoFromXY (there might be function already in GMT)
to get lon, lat. With that, and zoom (present) calculate new region
and bingo to pscoast...

Then call makeMap.jsp


TODO from mapServer.ise:
-get current map context and with it 
-calculate the new center of the map (lon,lat)


PROBLEM: the old version of intense do not want to parse the line
read from the file, therefore clickable maps in the current version of 
anita is abandoned.
Decision made on:  Sun May  1 14:31:59 EST 2005
--%>

<%

// Initialization ...
   String userDirS = "/usr/local/tomcat/webapps/anita/users/user" + userIdReq;
   String mapNumber = CONTEXT.value(userIdReq + ":info:currentMap").getBase().
                           canonical();
   String contextFileName = userDirS + "/mapContext" + mapNumber + ".context";

// Retrieving the context of current map
//   FileInputStream mapContext = new FileInputStream(contextFileName);
   String line = null;
   Context context = new Context();

   BufferedReader in = new BufferedReader(new FileReader(contextFileName));
   line = in.readLine();
   in.close();
//   BufferedWriter outout = new BufferedWriter(new FileWriter("prueba"));
//   outout.write(line);
//   outout.close();
   int ultimo = line.length();

   try {
      context.parse(line);
   }
   catch (Exception e)  {
%>
<br>
      parsing is not happenning
<br>
<%
   }



   try {
//      context.parse(line);
   } catch (Throwable t) {
       ByteArrayOutputStream bs = new ByteArrayOutputStream();
       PrintStream ps = new PrintStream(bs);
       t.printStackTrace(ps);
       ps.flush();
       bs.flush();
%>
       <h3>Caught Throwable:</h3><br>
       <pre> <%= bs.toString() %> </pre>
<%
   }
%>



<br>
<br>
Line is <%= line %> 
<br>
<%= line.charAt(5) %>
<%= line.charAt(6) %>
<%= line.charAt(7) %>
<%= line.charAt(8) %>
<%= line.charAt(ultimo-4) %>
<%= line.charAt(ultimo-3) %>
<%= line.charAt(ultimo-2) %>
<%= line.charAt(ultimo-1) %>
<br>
<br>




	This one will read the x and y and adjust the context
accordingly and then call makeMap.jsp. 
<br>Pretty neat...
     Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>


