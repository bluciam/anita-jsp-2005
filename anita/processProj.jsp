<%-- This file (processProj.jsp) is part of the Anita Conti Mapping 
     Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Fri Jan  9 16:04:56 EST 2004
     This file is cc of processAnita.jsp.

     This jsp page process the requests from anita.jsp to change
     a projection. We must provide automatic guessing of parameters,
     manual change, retrieve old values.

     The dim, dimValue pair is used to update the context.
     When done, it redirect to anita.jsp.
     This page ASSUMES that only one CGI parameter is sent from anita.jsp
     and that anything else is invalid. On error, forward to startUp.jsp

     Last-last update: Sun Jul 18 20:05:31 EST 2004
     Changing all the set Base() to apply() because set Base does not notify
     participant. Sigh! might as well clean up...
--%>

<%-- TODO standard header of ACMS --%>
<%@ page import="intense.*" %>
<%@ page import="ijsp.context.*" %>

<%@ page import="cgi.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<%-- Forward to startUp.jsp if any of the parameter,value pairs
     is missing or the user is not in the list of users.
--%>

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

   // TODO: Verify if the dimension already exists, if not error  //
   // there is a but and this does not seem to do anything...
   if (CONTEXT.value(dim) == null) {
%>
     <jsp:forward page="startUp.jsp" />
<%
   }
%>

<%-- TODO: delete if not needed  --%>
   Processing a projection...
   <br> <br>
   <%= dim %> and <%= dimValue %>
   <br> <br>
<%-- TODO: end delete if not needed  --%>


<%-- Guessing and updating projection values depending on the new
     and old values of the projection
--%>
<% 
   String partDim = userIdReq + ":gmt:proj:";
   String oldDimValue = CONTEXT.value(partDim).getBase().canonical();
   // if new and old proj are the same back to anita.jsp
   if (dimValue.equals(oldDimValue)) {
%>
      <c:redirect url="anita.jsp" >
        <c:param name="userIdReq" value="${userIdReq}" />
      </c:redirect>
<%
   }

   String[] valuesNew = new String[2];
   String[] valuesOld = new String[2];
   valuesOld = oldDimValue.split(":");
   valuesNew = dimValue.split(":");

   int projTypeOld = Integer.parseInt(valuesOld[0]);
   int projTypeNew = Integer.parseInt(valuesNew[0]);

// TODO CHECK OR DELETE:if the branch does not already exist... couldnt I just
// copy the branch instead of doing all those ifsssss?
   if ((CONTEXT.value(partDim + dimValue)).vanilla()) {
      if (projTypeOld == projTypeNew) { // same type copy values
         switch(projTypeNew) {

//           case 5: // lon0, lat0, lon1, lat1 

           case 6: // lon0, lat0, lat1, lat2

           CONTEXT.value(partDim + dimValue + ":lat1").apply
           (CONTEXT.value
             (
               partDim + CONTEXT.value(partDim).getBase().canonical() + ":lat1"
             ).getBase().canonical()
           );

           CONTEXT.value(partDim + dimValue + ":lat2").apply
           (CONTEXT.value
             (
               partDim + CONTEXT.value(partDim).getBase().canonical() + ":lat2"
             ).getBase().canonical()
           );

           case 4: // lon0, lats
           case 3: // lon0, lat0
           CONTEXT.value(partDim + dimValue + ":lat0").apply
           (CONTEXT.value
             (
               partDim + CONTEXT.value(partDim).getBase().canonical() + ":lat0"
             ).getBase().canonical()
           );

           case 2: // lon0
           CONTEXT.value(partDim + dimValue + ":lon0").apply
           (CONTEXT.value
             (
               partDim + CONTEXT.value(partDim).getBase().canonical() + ":lon0"
             ).getBase().canonical()
           );
           break;
         }
      } else { // guess the values or ask for them when cant (case 5)

         float lon = (Float.parseFloat(
           CONTEXT.value(partDim + "region:east").getBase().canonical()) +
                   Float.parseFloat(
           CONTEXT.value(partDim + "region:west").getBase().canonical()) ) / 2;

         float lat = (Float.parseFloat(
           CONTEXT.value(partDim + "region:north").getBase().canonical()) +
                   Float.parseFloat(
           CONTEXT.value(partDim + "region:south").getBase().canonical()) ) / 2;

         switch(projTypeNew) {
// TODO: deal with case 5
//    case 5: // lon0, lat0, lon1, lat1 
//CONTEXT.value(partDim + dimValue + ":lat0").apply(Integer.toString(lat));
//CONTEXT.value(partDim + dimValue + ":lon0").apply(Integer.toString(lon));
//need to get second point...probably ask for it.

           case 6: // lon0, lat0, lat1, lat2
             float ddlat = Float.parseFloat(
                 CONTEXT.value(partDim + "range:dlat").getBase().canonical())/4;
             CONTEXT.value(partDim + dimValue + ":lat1").apply(Float.
                     toString(lat+ddlat));
             CONTEXT.value(partDim + dimValue + ":lat2").apply(Float.
                     toString(lat-ddlat));
           case 4: // lon0, lats
           case 3: // lon0, lat0
             CONTEXT.value(partDim + dimValue + ":lat0").
                     apply(Float.toString(lat));
           case 2: // lon0
             CONTEXT.value(partDim + dimValue + ":lon0").
                     apply(Float.toString(lon));
           break;
         }
      }
      %> <%= partDim + dimValue %> dim does not exist<br> <%
   }


   CONTEXT.value(dim).apply(dimValue);
%>

<%-- TODO: get rid of this debugging
   <br> <br>
   long and lat are
   <%= Integer.toString(lon) %> and 
   <%= lat %>
   <br> <br> <br>
   old projType<%= projTypeOld %>
   <%= valuesOld[0] %> and <%= valuesOld[1] %> 
   <br> <br>
   new projType<%= projTypeNew %>
   <%= valuesNew[0] %> and <%= valuesNew[1] %> 
--%>

   <br> <br>
   Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
   <br> <br> <br>

<%--
--%>
<c:redirect url="anita.jsp" >
  <c:param name="userIdReq" value="${userIdReq}" />
</c:redirect>

