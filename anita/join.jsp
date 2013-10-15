<%-- This file (join.jsp) is part of the Anita Conti 
     Mapping Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Sat Jul 12 22:55:38 EST 2003

     This jsp page process a request from processShare.jsp for a 
     user to join an existing aether as a listerner. It updates 
     the AEther userlist and the user Aetherlist and set the 
     prefixes of user:info:shareLevel:... and then directs to anita.jsp

     Last-last update: Sun Jul 18 14:06:33 EST 2004
     Changing the prefixes bit and changing the node the applet is 
     listening to.

     Sun Aug  1 22:49:32 CDT 2004: checking the applet which is not
     listening; it is not receiving any signals.
--%>

<%@ page import="intense.*" %>
<%@ page import="concurrent.*" %>
<%@ page import="ijsp.context.*" %>
<%@ page import="id.*" %>

<%@ page import="cgi.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<%-- Forward to startUp.jsp if any of the parameter,value pairs
     is missing (aetherId and comming from processShare.jsp)
     or the user is not in the list of users.
--%>
<%
   AEther CONTEXT = AEtherManager.aether();
   CGIManager manager = new CGIManager(request);
   String userIdReq = null, aetherId = null, from = null, userName = null;
   String node = null;
   try {
     userIdReq = manager.get("userIdReq");
     aetherId = manager.get("aetherId");
     from = manager.get("from");
     node = manager.get("node");
   } catch (Throwable t) {
     %> <jsp:forward page="startUp.jsp" /> <%
   }
   if (!(from.equals("processShare"))) {
     %> <jsp:forward page="startUp.jsp" /> <%
   }

// TODO: DELETE for testing only print the cgi arguments //

   String dim = null, value = null;
   HashMap hashmap = manager.getArgsHashMap();
   Set keys = hashmap.keySet();
   Collection values = hashmap.values();
   for (Iterator i = keys.iterator(); i.hasNext(); ) {
      dim = (String)(i.next());
      value = (String)(hashmap.get(dim));
%>
      <%= dim %> maps to <%=value %><br>
<%
   }
// TODO: DELETE end of testing for printing //
%>



<%

// Updating the LISTS
// Update the user aetherList (in userIdReq:info:shareLevel:aetherList)
   try { //if this fails, eteres is empty, just assign the id the dim
     String eteres = CONTEXT.value(userIdReq + ":info:shareLevel:aetherList").
                             getBase().canonical();
     LinkedList lista = id.ListBaseString.unPack(eteres);
     //must ask if it exists
     if (!lista.contains(aetherId)) {
       lista.add(aetherId);
       CONTEXT.value(userIdReq + ":info:shareLevel:aetherList").
               apply(id.ListBaseString.pack(lista));
     }
   } catch (Throwable t) {
     CONTEXT.value(userIdReq + ":info:shareLevel:aetherList").apply(aetherId);
   }


// Update the aether userList (in aetherId:info:users)
   try { //if this fails, users is empty, just assign the id the dim
     String users = CONTEXT.value(aetherId + ":info:users").
                            getBase().canonical();
     LinkedList lista = id.ListBaseString.unPack(users);
     if (!lista.contains(userIdReq)) {
       lista.add(userIdReq);
       CONTEXT.value(aetherId+":info:users").
               apply(id.ListBaseString.pack(lista));
     }
   } catch (Throwable t) {
     CONTEXT.value(aetherId + ":info:users").apply(userIdReq);
   }


/*
   Participants will be stored in a Hash, which is stored in the
   application container. The key will be the participant name which
   is encoded as following: aetherId-userId-{node}-[OL]
   and node = [gmt|interface] and O=owner and L=listener. 
   To implement: When a partipant wants to leave, we need to
   delete it from the hash and call the leave() method.
*/
   HashMap participants = (HashMap)application.getAttribute("participants");


// Processing the node(s) in the aether for collaboration as listener
// backing up personal branch, copying the branch from the aether, and
// setting up mode for each node.

// INTERFACE
   if (node.equals("all") || node.equals("interface")) {
      // Storing personal branch at user:info:sharelevel:interface
      CONTEXT.value(userIdReq + ":info:shareLevel:interface"). 
              assign(CONTEXT.value(userIdReq + ":interface"));   

      // Getting the values of the aether
      CONTEXT.value(userIdReq + ":interface").
              assign(CONTEXT.value(aetherId + ":interface"));

      // Updating the mode for this node
      CONTEXT.value(userIdReq + ":" + aetherId + ":info:interface").
              apply("listener");

      String namePartInt = aetherId + "-" + userIdReq + "-interface-L";
      participants.put(namePartInt,
       new ListenerParticipant(namePartInt,userIdReq,aetherId,"interface",out));
   }

// GMT
   if (node.equals("all") || node.equals("gmt")) {
      // Storing personal branch at user:info:sharelevel:gmt
      CONTEXT.value(userIdReq + ":info:shareLevel:gmt").
              assign(CONTEXT.value(userIdReq + ":gmt"));   

      // Getting the values of the aether
      CONTEXT.value(userIdReq + ":gmt").
              assign(CONTEXT.value(aetherId + ":gmt"));

      //update the mode for this node
      CONTEXT.value(userIdReq + ":" + aetherId + ":info:gmt").
              apply("listener");

      String namePartGmt = aetherId + "-" + userIdReq + "-gmt-L";
      participants.put(namePartGmt,
       new ListenerParticipant(namePartGmt,userIdReq,aetherId,"gmt",out));
   }
%>

   <HTML>
     <HEAD>
       <TITLE>join.jsp</TITLE> 
     </HEAD>
       <b>This is join.jsp</b><br><br>

   Return to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>

<%-- 
     For the listener participant, we will have the normal ListernerParticipant 
     to update the value on the CONTEXT and, the applet server will attach 
     the applet paticipant to this node reload the window everytime there 
     is a change. This approach gives more flexibility to create extra nodes 
     of collaboration.

     The window in which join.jsp is renamed to winName = Listener + userId.
     This is the name of the targetWindow the applet will use to reload 
     anita.jsp. So if javascript is working fine, anita will reload in this
     same window. Ventana refers to the window name of the applet, and for
     that we need one for each node, therefore the prefix is the node value.
--%>

<%--
     can i do the javascript thingy in jsp?
     some jsp:forward with a new window?
--%>

<%--
TODO: what is commented out?
COMMENTED OUT TO TEST THE NODE ARGUMENT BEING PASSED FROM PROCESSSHARE
TO JOIN.
--%>

<%
   String winName = "Listener" + userIdReq;
   String urlSarta = null, ventana = null;

// INTERFACE
   if (node.equals("all") || node.equals("interface")) {
     urlSarta =
       "listener.jsp?targetUrl=listenerAnita.jsp&status=listener&dimension=" +
       aetherId + ":interface&userIdReq=" + userIdReq + "&aetherId=" + aetherId +
       "&target=anita.jsp";
     ventana = "interface" + userIdReq + aetherId;
%>
     <script language="JavaScript">
       window.name = "<%= winName %>";
       window.open("<%= urlSarta %>", "<%= ventana %>",
                   "resizeble=no,menubar=no,scrollbar=no");
     </script>
<%
   }

// GMT
   if (node.equals("all") || node.equals("gmt")) {
     urlSarta =
       "listener.jsp?targetUrl=listenerAnita.jsp&status=listener&dimension=" +
       aetherId + ":gmt&userIdReq=" + userIdReq + "&aetherId=" + aetherId +
       "&target=anita.jsp";
//       "gmt&userIdReq=" + userIdReq + "&aetherId=" + aetherId;
     ventana = "gmt" + userIdReq + aetherId;

%>
     <script language="JavaScript">
       window.name = "<%= winName %>";
       window.open("<%= urlSarta %>", "<%= ventana %>",
                   "resizeble=no,menubar=no,scrollbar=no");
     </script>
<%
     urlSarta =
       "listener.jsp?targetUrl=listenerAnita.jsp&status=listener&dimension=" +
       aetherId + ":makeMap&userIdReq=" + userIdReq + "&aetherId=" + aetherId +
       "&target=makeMap.jsp";
     ventana = "makeMap" + userIdReq + aetherId;
   }
%>

     <script language="JavaScript">
       window.name = "<%= winName %>";
       window.open("<%= urlSarta %>", "<%= ventana %>",
                   "resizeble=no,menubar=no,scrollbar=no");
     </script>

