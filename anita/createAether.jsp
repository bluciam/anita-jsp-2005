<%-- This file (createAether.jsp) is part of the Anita Conti 
     Mapping Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Sat Jul 12 22:58:18 EST 2003

     This jsp page creates a new Aether with the information sent by 
     newAether.jsp. From the implementation point of view, this means 
     a new branch with node name being the new aetherId. The global
     AEther list, the AEther user list, and the user Aether list are 
     updated here as well.

     THIS IS NOT DONE YET, CHECK THIS PARAGRAPH!
     The user creating the aether should be awarded modify access to the 
     available levels (gmt and interface). This page will ask for the 
     information not gathered in newAether like the joining conditions.
     Since user is owner, and we will be in leader-follow, no need to 
     create a personal branch (i.e. userId:aetherId:gmt) and the prefixes 
     should be blank.
--%>

<%@ page import="intense.*" %>
<%@ page import="concurrent.*" %>
<%@ page import="ijsp.context.*" %>
<%@ page import="id.*" %>
<%@ page import="java.text.*" %>

<%@ page import="cgi.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<HTML>
  <HEAD>
    <TITLE>createAether.jsp</TITLE> 
  </HEAD>
<b>This is createAether.jsp</b><br><br>

<%-- Forward to startUp.jsp if any of the parameter,value pairs
     is missing or the user is not in the list of users.
--%>
<%
   AEther CONTEXT = AEtherManager.aether();
   CGIManager manager = new CGIManager(request);
   String userIdReq = null, aetherId = null;
   try {
     //must check if the userIdList contains the userIdReq.
     //if not, redirect to startUp.jsp
     userIdReq = manager.get("userIdReq");
     aetherId = manager.get("aetherId");
   } catch (Throwable t) {
%>
     <jsp:forward page="startUp.jsp" />
<%
   }
   manager.remove("userIdReq");
   manager.remove("aetherId");

   //Getting the rest of the cgi arguments into a hash
   HashMap hashmap = manager.getArgsHashMap();
   Set keys = hashmap.keySet();
   Collection values = hashmap.values();

   //Going through the hash to update the CONTEXT
   String dim, val;
   for (Iterator i = keys.iterator(); i.hasNext(); ) {
     dim = (String)(i.next());
     val = (String)(hashmap.get(dim));
     CONTEXT.value(dim).setBase(new StringBaseValue(val));
%>

<%-- start debug
     dim <%= dim %> maps to <%= val %> <br><br>
     end debug
--%>
<%
   }
%>

<%
   pageContext.setAttribute("userIdReq",userIdReq); //must survive the page
%>                                                                                

<% 
// Updating the LISTS
   // Update the global aetherlist (in status:aethers) 
   if (CONTEXT.value("status:aethers").getBase() == null) {
     CONTEXT.value("status:aethers").apply(aetherId);
   } else {
     String aethers = CONTEXT.value("status:aethers").getBase().canonical();
     LinkedList aethersList = id.ListBaseString.unPack(aethers);
     if (!aethersList.contains(aetherId)) {
       aethersList.add(aetherId);
       CONTEXT.value("status:aethers").
               apply(id.ListBaseString.pack(aethersList));
     }
   }

   // Update the aether userlist (in aetherId:info:users) empty since new aether
   CONTEXT.value(aetherId + ":info:users").apply(userIdReq);

   // Update the user aetherlist (in userId:info:shareLevel:aetherList)
   if (CONTEXT.value(userIdReq+":info:shareLevel:aetherList").getBase() == null)
   {
     CONTEXT.value(userIdReq+":info:shareLevel:aetherList").apply(aetherId);
   } else {
     String aethers = CONTEXT.value(userIdReq + ":info:shareLevel:aetherList").
                              getBase().canonical();
     LinkedList aethersList = id.ListBaseString.unPack(aethers);
     if (!aethersList.contains(aetherId)) {
       aethersList.add(aetherId);
       CONTEXT.value(userIdReq + ":info:shareLevel:aetherList").
               apply(id.ListBaseString.pack(aethersList));
     }
   }

// The status of the user vis-a-vis this Aether at each node
   CONTEXT.value(userIdReq + ":" + aetherId + ":info:gmt").apply("owner");
   CONTEXT.value(userIdReq + ":" + aetherId + ":info:interface").apply("owner");

/* TODO: DEBUG to to deleted.
   // Prefixes: none since the owner of an aether writes into it, 
   // it does not look into it. I dont think I have to... Done in startUp.jsp
   Check if this field is needed in anita.jsp
   END: DEBUG to be deleted.
*/
   CONTEXT.value(userIdReq + ":info:shareLevel:gmt").apply("");
   CONTEXT.value(userIdReq + ":info:shareLevel:interface").apply("");


// Updating all other parameters in aetherId:info
   CONTEXT.value(aetherId + ":info:owner").
           setBase(CONTEXT.value(userIdReq + ":info:name").getBase());
   CONTEXT.value(aetherId + ":info:creator").
           setBase(CONTEXT.value(userIdReq + ":info:name").getBase());
%>

<%-- Creating the actual branch of the new aether, copy of the 
     personal branches of the creator. Both gmt and interface 
     get created, since for now, the creator of an aether manipulates
     both branches. He has no choice. Probably later a more 
     sophisticated interface will allow finer detail.
--%>

<%
   // Aether branches
   CONTEXT.value(aetherId + ":interface").
           assign(CONTEXT.value(userIdReq + ":interface"));
   CONTEXT.value(aetherId + ":gmt").
           assign(CONTEXT.value(userIdReq + ":gmt"));
   // Date stamp for creation
   DateFormat df = DateFormat.
                   getDateTimeInstance(DateFormat.FULL, DateFormat.FULL);
   String theDate = df.format(new Date());
   CONTEXT.value(aetherId + ":info:dateStamp:created").apply(theDate);

/*
   Once the aether is created, a participant is created to join at each
   sharingBranch. Here, the aether is "listening" to the user.
   Participants will be stored in a Hash, which is stored in the
   application container. The key to the hash is the participant name
   encoding the following information: aetherId-userId-{node}-[OL]
   and node = [gmt|interface]. When a partipant is to leave the aether,
   it is deleted it from the hash and call the leave() method.
*/

// Initializing the participants hash, by either gettting an exisiting one
// from the container, or starting a new one. 
   HashMap participants = (HashMap)application.getAttribute("participants");
   String namePartInt = aetherId + "-" + userIdReq + "-interface-O";
   String namePartGmt = aetherId + "-" + userIdReq + "-gmt-O";
   if (participants == null) { //need a new Hash in the application container
      HashMap tempPart = new HashMap();
      application.setAttribute("participants",tempPart);
      tempPart.put(namePartInt,
               new OwnerParticipant(namePartInt,userIdReq,aetherId,"interface"));
      tempPart.put(namePartGmt,
               new OwnerParticipant(namePartInt,userIdReq,aetherId,"gmt"));
   } else { // participants held the hash
      participants.put(namePartInt,
               new OwnerParticipant(namePartInt,userIdReq,aetherId,"interface"));
      participants.put(namePartGmt,
               new OwnerParticipant(namePartInt,userIdReq,aetherId,"gmt"));
   }
%>

<%-- TODO: debugging: to delete soon
   if it is the first time it will throw an exception. 
   <%= participants %><br>
   <%= ((OwnerParticipant)participants.get(namePartInt)).status %><br>
   <%= ((OwnerParticipant)participants.get(namePartGmt)).status %><br>
   <br><br>
--%>

<%-- DEBUGGING
   <br><br>
   again  <%= participants %><br>
   <% ((OwnerParticipant)participants.get(userIdReq+aetherId+"gmt")).leave(); %>
   <%= ((OwnerParticipant)participants.get(userIdReq+aetherId+"gmt")).status %>
   <br><br>
--%>

<%
   if ((CONTEXT.value(userIdReq + ":info:name").getBase().canonical().equals(""))
     || (CONTEXT.value(aetherId + ":info:name").getBase().canonical().equals(""))
     || (CONTEXT.value(aetherId + ":info:description").getBase().canonical().equals("")))
   {
%>
      <jsp:forward page="newAether.jsp" >
         <jsp:param name="aetherId" value="<%=aetherId %>" />
         <jsp:param name="userIdReq" value="<%=userIdReq %>" />
      </jsp:forward>
<%
   }
%>

   The current aether information is
   <%= AEtherManager.htmlCanonical(CONTEXT.value(aetherId).canonical()) %><br><br>

   The current user information is
   <%= AEtherManager.htmlCanonical(CONTEXT.value(userIdReq).canonical()) %><br><br>

   The status value
   <%= AEtherManager.treeCanonical(CONTEXT.value("status")) %><br><br>
   <hr>

   <br>To <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a> again.<br>
   <%-- Probably time to redirect to anita.jsp...--%>

                                                                                
<c:redirect url="anita.jsp" >
  <c:param name="userIdReq" value="${userIdReq}" />
</c:redirect>

