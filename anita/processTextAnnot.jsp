<%-- This file (processWindow.jsp) is part of the Anita Conti Mapping 
     Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Thu Dec 11 11:18:44 EST 2003

     This page processes the change on any 'annotation' values.
     The formula from ise was: if wUnits = i, then (dlon / (width/2) )
     is the max number of labels. (which gives about half inch. In high
     resolution, this might not be enough, labels get too close.

     This page ASSUMES that only one CGI parameter is sent from anita.jsp
     and that anything else is invalid. On any error, forward to startUp.jsp
--%>

<%-- TODO standard header of ACMS --%>
This is processTextAnnot.jsp (Must replace for standard header of ACMS)
<br>

<%@ page import="intense.*" %>
<%@ page import="ijsp.context.*" %>

<%@ page import="cgi.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>


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

   // Verify if the dimension already exists, if not error  //
   if (CONTEXT.value(dim) == null) {
   %>
     <jsp:forward page="startUp.jsp" />
   <%
   }

   // Verify the value 
   try {
     float Ivalue = Float.parseFloat(dimValue);
     String partDim = userIdReq + ":gmt:proj:";
     // basically this calculation only work when userId:gmt:proj:SorW == wd
     // and userId:gmt:proj:SorW:width:units == in. For now, I'll assume this
     // is the case, sice I'm not giving means to change it. 
     if (dim.matches(".*:x:.*")) {
        float dlon = Float.parseFloat(CONTEXT.value(partDim + "range:dlon").
                                              getBase().canonical());
        float width = Float.parseFloat(CONTEXT.value(partDim + "SorW:width").
                                               getBase().canonical());
        int xmin = (int)(dlon / (width * 2));
        if ((Ivalue < xmin) && (Ivalue != 0.0)) {
        %>
           the enter value (<%= dimValue %>) is lower than the allowed minimum 
           (<%= xmin %>) <br><br>
           Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
           <br><br>
        <%
        } else {
           CONTEXT.value(dim).apply(dimValue);
           %>
           <c:redirect url="anita.jsp" >
             <c:param name="userIdReq" value="${userIdReq}" />
           </c:redirect>
           <%
           // forward to anita.jsp
        }
     } else if (dim.matches(".*:y:.*")) {
        float dlat = Float.parseFloat(CONTEXT.value(partDim + "range:dlat").
                                              getBase().canonical());
        float height = Float.parseFloat(CONTEXT.value(partDim + "height").
                                                getBase().canonical());
        int ymin = (int)(dlat / (height * 2));
        if ((Ivalue < ymin) && (Ivalue != 0.0)) {
        %>
           the enter value (<%= dimValue %>) is lower than the allowed minimum 
           (<%= ymin %>) <br><br>
           Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
           <br><br>
        <%
        } else {
           CONTEXT.value(dim).apply(dimValue);
           %>
           <c:redirect url="anita.jsp" >
             <c:param name="userIdReq" value="${userIdReq}" />
           </c:redirect>
           <%
           // forward to anita.jsp
        }
     } else { //the dimension name is not recognized, but it should not get here
     %>
       <jsp:forward page="startUp.jsp" />
     <%
     }
   } catch (Exception e) {
   %>
     <br>The value you entered (<%= dimValue %>) has the wrong format.
     It must be a number!<br><br>
     Please enter a your value again<br><br>
     Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
     <br><br> dim is <%= dim %>
   <%
   }
%>




<%--
%>
<c:redirect url="anita.jsp" >
  <c:param name="userIdReq" value="${userIdReq}" />
</c:redirect>
<%
--%>
