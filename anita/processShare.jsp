<%-- This file (processShare.jsp) is part of the Anita Conti 
     Mapping Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Sat Jul 12 22:55:17 EST 2003

     This jsp page processes the requests from anita.jsp dealing
     with collaboration. It first sets the value for shareLevel
     (dim = idUser:info:shareLevel) which can be on, off, or change,
     as requested by anita.jsp. And then process according to the new value.

     Last-last updated:Sun Jul 18 00:00:55 EST 2004
     Cleaning up code and moving to new design, need to implement loose ends.
--%>

<%@ page import="intense.*" %>
<%@ page import="ijsp.context.*" %>
<%@ page import="cgi.*" %>
<%@ page import="java.util.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<%-- Forward to startUp.jsp if any of the parameter,value pairs
     is missing or the user is not in the list of users.
--%>

<%
   String userIdReq = null;
   String newShareLevel = null;
   CGIManager manager = new CGIManager(request);
   HashMap hashmap = manager.getArgsHashMap();
   Set keys = hashmap.keySet();
   Collection values = hashmap.values();
   try {
     userIdReq = (String)(hashmap.get("userIdReq"));
     newShareLevel = (String)(hashmap.get("shareLevel"));
     String from = (String)(hashmap.get("from"));
   } catch (Exception e) {
%>
     <jsp:forward page="startUp.jsp" />
<%
   }
%>

<%
   AEther CONTEXT = AEtherManager.aether();
   String users = null;

// Verify that the nominated userIdReq is a real user and that the 
// CONTEXT has been initiated.
   try {
     users = CONTEXT.value("status:users").getBase().canonical();
     LinkedList userList = id.ListBaseString.unPack(users);
     if (!userList.contains(userIdReq)) {
%>  
        <jsp:forward page="startUp.jsp" />
<%
     } 
   } catch (Exception e) {
%>
      <jsp:forward page="startUp.jsp" />
<%
   }

// If the query request does not have a userName, get it from the CONTEXT.
// If it is still missing, redirect to getUserName.jsp to get a name. The
// redirection must include the dim and the value for shareLevel, to be a
// valid request.
   String userName = (String)(hashmap.get("userName"));
   if (userName == null) {
      try {
        userName = CONTEXT.value(userIdReq + ":info:name").getBase().canonical();
      } catch (Exception e) {
        userName =  null;
      }
    } else {
        CONTEXT.value(userIdReq + ":info:name").apply(userName);
    }

   String dim = userIdReq + ":info:shareLevel";
   String oldShareLevel = CONTEXT.value(dim).getBase().canonical();

   CONTEXT.value(dim).apply(newShareLevel);
// TODO delete following line after testing, but this setBase is irrelevant
//   CONTEXT.value(dim).setBase(new StringBaseValue(newShareLevel));

   //move this part as close to the top as possible
   if (userName == null || userName.equals("")) {
      pageContext.setAttribute("newShareLevel",newShareLevel);
      pageContext.setAttribute("dim",dim);
%>
      <c:redirect url="getUserName.jsp?${dim}=${newShareLevel}" />
<%
   }
%>
<%-- End of verifying for erroneous input   --%>

<%-- TODO: ML titles all over the place --%>
   <HTML>
   <HEAD>
   <TITLE>processShare.jsp</TITLE>
   </HEAD>
   <H1> Anita Conti Collaboration Platform </H1>
   <h4> <%= dim %> and <%= newShareLevel %> </H4>

<%--   Processing a shareLevel change  --%>
<% 
   if ((newShareLevel.equals("on")) && (oldShareLevel.equals("on"))) {
      newShareLevel = "change";
   }

// New shareLevel value is off. Do not want to collaborate.
   if (newShareLevel.equals("off")) {
     if (CONTEXT.value(dim + ":aetherList").getBase() == null) {
     // changing from "off" to "off"
%>
       <br>There was NO previous sharing <br>
       Return to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
<%   
     } else { // dettaching the participant(s) 
       ParticipantServer server =
          ParticipantServerManager.instance(getServletContext()).server();
       HashMap participants = (HashMap)application.getAttribute("participants");

       String eteres = CONTEXT.value(dim + ":aetherList").getBase().canonical();
       LinkedList eterList = id.ListBaseString.unPack(eteres);
       for (int i = 0; i < eterList.size(); i++) {

// TODO: this branch thingy should become a function to have as many branches as wanted.
// GMT branch
          try { // checking gmt condition
             String gmtCond = CONTEXT.value(userIdReq + ":" + eterList.get(i) +
                              ":info:gmt").getBase().canonical();
             if (gmtCond.equals("listener")) {
                String namePart = eterList.get(i) + "-" + userIdReq + "-gmt-L";
                ((id.ListenerParticipant)(participants.get(namePart))).leave();
                participants.remove(namePart);

                try { //leaving the applet participant...But the applet window still open
                   String pId = CONTEXT.value(userIdReq + ":" + eterList.get(i)
                                + ":info:gmt:pId").getBase().canonical();
                   long participantId = Long.parseLong(pId);
                   server.disconnectParticipant(participantId);
                } catch (Exception e) {
%>
                    <br>Could not dettach the applet participant for 
                    <%=userIdReq + ":" + eterList.get(i) + ":info:gmt" %><br>
<%
                }
                CONTEXT.value(userIdReq + ":" + eterList.get(i) + ":info:gmt").
                        clearBase();
                // TODO: remove the collaborative branch and restore personal
             } else if (gmtCond.equals("owner")) {
                String namePart = eterList.get(i) + "-" + userIdReq + "-gmt-L";
                ((id.OwnerParticipant)participants.get(namePart)).leave();
                participants.remove(namePart);
                CONTEXT.value(userIdReq + ":" + eterList.get(i) + ":info:gmt").
                        clearBase();
                // TODO: what to do with the users listening to this aether?
             }
          } catch (Exception e) {
%>
             <br><br>Could not do anything with <%= eterList.get(i) %> 
             when trying to leave() the <b>GMT</b> node.<br><br>
<%
             // TODO: what happens if it fails? Where do we go?
          }

// INTERFACE branch
          try { // checking interface condition
             String interCond = CONTEXT.value(userIdReq + ":" + eterList.get(i)
                                + ":info:interface").getBase().canonical();
             if (interCond.equals("listener")) {
                String namePart = eterList.get(i) + "-" + userIdReq + 
                                  "-interface-L";
                ((id.ListenerParticipant)(participants.get(namePart))).leave();
                participants.remove(namePart);

                try { //leaving the applet participant...But the applet window still open
                   String pId = CONTEXT.value(userIdReq + ":" + eterList.get(i)
                                + ":info:interface:pId").getBase().canonical();
                   long participantId = Long.parseLong(pId);
                   server.disconnectParticipant(participantId);
                } catch (Exception e) {
%>
                  <br>Could not detach the applet participant for
                  <%= userIdReq + ":" + eterList.get(i) + ":info:interface" %><br>
<%
                }
                CONTEXT.value(userIdReq + ":" + eterList.get(i) +
                              ":info:interface").clearBase();
                // TODO: remove the collaborative branch and restore personal
             } else if (interCond.equals("owner")) {
                String namePart = eterList.get(i) + "-" + userIdReq + 
                                   "-interface-L";
                ((id.OwnerParticipant)participants.get(namePart)).leave();
                participants.remove(namePart);
                CONTEXT.value(userIdReq + ":" + eterList.get(i) +
                             ":info:interface").clearBase();
                // TODO: what to do with the users listening to this aether?
             }
          } catch (Exception e) {
%>
            <br><br>Could not do anything with <%= eterList.get(i) %> 
            when trying to leave() the <b>INTERFACE</b> node.<br><br>
<%
            // TODO: what happens if it fails? where should we go?
          }

// Deleting user from userList of this aether. Not sure if this is 
// well done there because of both participant removals fail???
          users = CONTEXT.value(eterList.get(i) + ":info:users").getBase().
                              canonical();
          LinkedList lista = id.ListBaseString.unPack(users);
          lista.remove(userIdReq);
          if (lista.size() > 0) {
             CONTEXT.value(eterList.get(i) + ":info:users").
                     apply(id.ListBaseString.pack(lista));
          } else {
             CONTEXT.value(eterList.get(i) + ":info:users").clearBase();
          }
       }
/*
The following two go together. The branch that will be pruned will be
stored in the "log" as a context op, modifiyng the aetherId, to avoid
clashes and store date, for example.
*/
       // TODO: after going through add aethers come back to prune and update
       // correctly. I'll forget about history logs, just leave a note.
       //Update history logs for userIdReq, non-existent yet
       //CONTEXT.value(userIdReq:eachAether).clear()

       //Clearing out the userIdReq:info:shareLevel details (list and prefixes).
       CONTEXT.value(dim + ":aetherList").clearBase();
       CONTEXT.value(dim + ":interface").setBase(new StringBaseValue(""));
       CONTEXT.value(dim + ":gmt").setBase(new StringBaseValue(""));

       CONTEXT.value(dim).apply("off");

%>
       <%-- I might just redirect directly... --%>
       <br>Sharing --->> not sharing (clearing out)<br>
       Return to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
<%
     } // end of else of user:info:shareLevel:aetherList not empty.  

// Changing to shareLevel equals on
   } else if (newShareLevel.equals("on")) {
%>
       <form action=getNewAetherId.jsp method="GET">
         Click to create a new aether
         <input type=hidden type=text name=userIdReq value=<%= userIdReq %>>
         <input type=hidden type=text name=validate value=yes>
         <input type=submit value="Create aether">
       </form>
<%
       if (CONTEXT.value("status:aethers").getBase() == null) {
%>
          <br>There are no aethers to share.<br>
<%
       } else { 
%>
          or join an existing one.
          <h2>Information on existing Aethers you can join</h2>
<%
         String eteres = CONTEXT.value("status:aethers").getBase().canonical();
         LinkedList eterList = id.ListBaseString.unPack(eteres);
         for (int i = 0; i < eterList.size(); i++) {
           if (CONTEXT.value(eterList.get(i)+":info:mode").getBase().
                       canonical().equals("public")) { //& userId in aetherList
//dont know what to do if user is owner of aether
%>

           <TABLE hspace=5 cellspacing=5 cellpadding=5><tr valign=top>
           <TD>
           <H2>Aether <%= eterList.get(i) %>&nbsp; </H2>

           </TD><TD>
             <form action=join.jsp method=get>
               <input type=hidden type=text name=userIdReq value=<%= userIdReq %>>
               <input type=hidden type=text name=aetherId value=<%= eterList.get(i)%>>
               <input type=hidden type=text name=from value=processShare>
               Nodes to join: <br>
               <input type="radio" name="node" value="all" checked>all<br>
               <input type="radio" name="node" value="gmt">gmt<br>
               <input type="radio" name="node" value="interface">interface<br>
               <input type=submit value="Join this aether">
             </form>

           </TD><TD>
             <b><%= eterList.get(i) %>&nbsp; General Info:</b>
             <table><tr><td>Name: </td>
                     <td><%= CONTEXT.value(eterList.get(i)+":info:name").getBase().
                                     canonical() %>
                 </td></tr>
                 <tr><td>Mode: </td>
                     <td><%= CONTEXT.value(eterList.get(i)+":info:mode").getBase().
                                     canonical() %>
                 </td></tr>
                 <tr><td>Description: </td>
                     <td><%= CONTEXT.value(eterList.get(i)+":info:description").getBase().
                                     canonical() %>
                 </td></tr>
                 <tr><td>Owner: </td>
                      <td><%= CONTEXT.value(eterList.get(i)+":info:owner").getBase().
                                      canonical() %>
                 </td></tr>

                 <tr><td>Connected Users: </td>
<%-- TODO: Should show the names not the id... for each id in 
     eterList.get(i)+":info:users", get "id:info:name"
     Might be easier when new list is implemented. Leave for now.
--%>
                 <td><%= CONTEXT.value(eterList.get(i)+":info:users").getBase().
                                 canonical() %>
<%-- this gives an unPacked list, all i have to do is to pass it through
     an iterator an show elem:info:name
--%>
                </td></tr>
                </table>

           </TD></TR></TABLE>
<%
            } // closing if (mode == public)
         } // closing for going through the eterList
       } // closing (status:aethers == null) if else

// Changing to shareLevel equals change
   } else if (newShareLevel.equals("change")) {
     if (oldShareLevel.equals("off")) {
       // TODO: debug next three lines
        CONTEXT.value(dim).apply("off");
        pageContext.setAttribute("newShareLevel",newShareLevel);
        pageContext.setAttribute("dim",dim);
%>
        <c:redirect url="getUserName.jsp?${dim}=on" />
<%
     } else {
        String eteres = CONTEXT.value(dim + ":aetherList").getBase().canonical();
        LinkedList joinedEteres = id.ListBaseString.unPack(eteres);
        eteres = CONTEXT.value("status:aethers").getBase().canonical();
        LinkedList allEteres = id.ListBaseString.unPack(eteres);
%>
        <h2>Modify joined Aethers</h2>
<%

       /* Aethers joined. dont know what to do when owner */
       for (int i = 0; i < joinedEteres.size(); i++) {
          //show the info to modify of each in joinedEteres.get(i)
%>
          <TABLE hspace=5 cellspacing=5 cellpadding=5><tr valign=top>
            <TD>
            <H2>Aether <%= joinedEteres.get(i) %>&nbsp; </H2>
            </TD><TD>
<%
              if (CONTEXT.value(userIdReq + ":info:shareLevel:gmt").getBase().
                          canonical().equals(joinedEteres.get(i))) {
%>
                 Joined at <b>gmt</b> node<br>
<%
              }
              if (CONTEXT.value(userIdReq + ":info:shareLevel:interface").getBase().
                          canonical().equals(joinedEteres.get(i))) {
%>
                  Joined at <b>interface</b> node<br>
<%
              }
              // TODO implement modifyShare.jsp
%>
              <br> Needs implementation: modifyShare.jsp<br>
              to join or leave aethers accordingly

            </TD><TD>
              <b><%= joinedEteres.get(i) %>&nbsp; General Info:</b>
              <table><tr>
                 <td>Name: </td>
                 <td><%= CONTEXT.value(joinedEteres.get(i)+":info:name").getBase().
                                 canonical() %>
                 </td></tr>
                <tr><td>Mode: </td>
                 <td><%= CONTEXT.value(joinedEteres.get(i)+":info:mode").getBase().
                                 canonical() %>
                 </td></tr>
                 <tr><td>Description: </td>
                 <td><%= CONTEXT.value(joinedEteres.get(i)+":info:description").
                                 getBase().canonical() %>
                 </td></tr>
                <tr><td>Owner: </td>
                 <td><%= CONTEXT.value(joinedEteres.get(i)+":info:owner").getBase().
                                 canonical() %>
                 </td></tr>
                <tr><td>Connected Users: </td>
                 <td><%= CONTEXT.value(joinedEteres.get(i)+":info:users").getBase().
                           canonical() %>
<%-- TODO: this gives an unPacked list, all i have to do is to pass it through
     an iterator an show elem:info:name
     Should show the names not the id... for each id in
     eterList.get(i)+":info:users", get "id:info:name"
     Might be easier when new list is implemented. Leave for now.
--%>
                </td></tr>
              </table>
            </TD></TR>
          </TABLE>

<%          
       } // END information on connected aethers

%>
       <h2>Join other existing Aethers</h2>
<%

       /* Athers not joined offer to join */
       for (int i = 0; i < allEteres.size(); i++) {
          if (!joinedEteres.contains(allEteres.get(i))) {
// TODO: get rid off this public thing, which is not being used.
//             if (CONTEXT.value(allEteres.get(i)+":info:mode").getBase().
//                         canonical().equals("public")) {
//             }
%>
             <TABLE hspace=5 cellspacing=5 cellpadding=5><tr valign=top>
               <TD>
               <H2>Aether <%= allEteres.get(i) %>&nbsp; </H2>

               </TD><TD>
               <form action=join.jsp method=get>
                 <input type=hidden type=text name=userIdReq value=<%= userIdReq %>>
                 <input type=hidden type=text name=aetherId value=<%= allEteres.get(i)%>>
                 <input type=hidden type=text name=from value=processShare>
                 Nodes to join: <br>
                 <input type="radio" name="node" value="all" checked>all<br>
                 <input type="radio" name="node" value="gmt">gmt<br>
                 <input type="radio" name="node" value="interface">interface<br>
                 <input type=submit value="Join this aether">
               </form>

               </TD><TD>
               <b><%= allEteres.get(i) %>&nbsp; General Info:</b>
               <table>
                  <tr><td>Name: </td>
                   <td><%= CONTEXT.value(allEteres.get(i)+":info:name").getBase().
                                   canonical() %>
                   </td></tr>
                  <tr><td>Mode: </td>
                   <td><%= CONTEXT.value(allEteres.get(i)+":info:mode").getBase().
                                   canonical() %>
                   </td></tr>
                  <tr><td>Description: </td>
                   <td><%= CONTEXT.value(allEteres.get(i)+":info:description").
                                   getBase().canonical() %>
                   </td></tr>
                  <tr><td>Owner: </td>
                   <td><%= CONTEXT.value(allEteres.get(i)+":info:owner").getBase().
                                   canonical() %>
                   </td></tr>
                  <tr><td>Connected Users: </td>
                   <td><%= CONTEXT.value(allEteres.get(i)+":info:users").getBase().
                                   canonical() %>

<%-- TODO: Should show the names not the id... for each id in 
     eterList.get(i)+":info:users", get "id:info:name"
     Might be easier when new list is implemented. Leave for now.
     TODO: this gives an unPacked list, all i have to do is to pass it through
     an iterator an show elem:infor:namme
--%>
                   </td></tr>
               </table>
               </TD></TR>
             </TABLE>

<%          
           } // END aether not joined by user
       } // END iteration through all aethers in user:info:shareLevel:aetherList
%>

<%-- Option to create a new aether  --%>
       <FORM action=getNewAetherId.jsp method="GET">
         <TABLE><TR><TD>
         <h2>Or create a new Aether</h2>
         </TD><TD>
         <input type=hidden type=text name=userIdReq value=<%= userIdReq %>>
         <input type=hidden type=text name=validate value=yes>
         <input type=submit value="Create aether">
         </TD></TR>
         </TABLE>
       </FORM>

<%-- Option to return to anita.jsp  --%>
       <FORM action=anita.jsp method="GET">
         <TABLE><TR><TD>
         <h2>Or go back to the main page</h2>
         </TD><TD>
         <input type=hidden type=text name=userIdReq value=<%= userIdReq %>>
         <input type=submit value="To anita">
         </TD></TR>
         </TABLE>
       </FORM>

<%
     }
      CONTEXT.value(dim).apply("on");
   }
%>

<%-- TODO: check on this...
     Probably better to have just ONE redirect, here at the end. But I do not if it works
     <c:redirect url="anita.jsp" >
       <c:param name="userIdReq" value="${userIdReq}" />
     </c:redirect>
--%>
