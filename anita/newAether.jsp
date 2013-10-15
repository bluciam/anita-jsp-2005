<%-- This file (newAether.jsp) is part of the Anita Conti 
     Mapping Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Fri Apr 18 12:06:28 EST 2003.

     This page will ask for all the information necessary to properly
     create the branches. 

     The filled form is sent to createAether.jsp which after the
     update (I think) redirect to anita.jsp.
--%>

<%@ page import="intense.*" %>
<%@ page import="concurrent.*" %>
<%@ page import="ijsp.context.*" %>

<%@ page import="cgi.*" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>


<%-- Forward to startUp.jsp if any of the parameter,value pairs
     is missing or the user is not in the list of users.
--%>
<%
   AEther CONTEXT = AEtherManager.aether();

   String dim, dimValue;
   CGIManager manager = new CGIManager(request);
   String userIdReq = null, aetherId = null;
   try {
     userIdReq = manager.get("userIdReq");
     aetherId = manager.get("aetherId");
   } catch (Throwable t) {
%>
     <jsp:forward page="startUp.jsp" />
<%   
   }
%>

   <HTML>
     <HEAD>
       <TITLE>newAether.jsp...</TITLE> 
     </HEAD>
     <BODY bgcolor="white">

       <h1>Anita Conti Collaboration Platform</h1>
       <FORM action=createAether.jsp method="GET">


<%-- User Id and name --%>
       You are user <%= userIdReq %>
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
       User Name:
<%
       String name = "";
       if (CONTEXT.value(userIdReq + ":info:name").getBase() != null) {
          name = CONTEXT.value(userIdReq + ":info:name").getBase().canonical();
       }
       if (name.equals("")) {
%>
          (<FONT COLOR=RED>Please enter</FONT>)
<%
       }
%>
       <INPUT TYPE=text MAXLENGTH=20 SIZE=10 NAME="<%= userIdReq %>:info:name" 
              VALUE=<%=name%>>


<%-- Aether name --%>
       <h2>Creating an aether: aetherId <%= aetherId %></h2>
       Aether Name:
<%
       name = "";
       if (CONTEXT.value(aetherId + ":info:name").getBase() != null) {
          name = CONTEXT.value(aetherId + ":info:name").getBase().canonical();
       }
       if (name.equals("")) {
%>
          (<FONT COLOR=RED>Please enter</FONT>)
<%  
       }
%>  
       <INPUT TYPE=text MAXLENGTH=20 SIZE=10 NAME="<%=aetherId%>:info:name"
              VALUE=<%=name%>>
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<%-- Aether mode : not being used at the moment. --%>
<%
       name = "";
       if (CONTEXT.value(aetherId + ":info:mode").getBase() != null) {
         name = CONTEXT.value(aetherId + ":info:mode").getBase().canonical();
       }
       String pubCheck = "", privCheck = "";
       if (name.equals("public")) {
         pubCheck = "CHECKED";
       } else if (name.equals("private")) {
         privCheck = "CHECKED";
       }
%>
       Mode: <SELECT NAME="<%=aetherId%>:info:mode">
                <OPTION <%=  pubCheck %> VALUE=public>Public</OPTION>
                <OPTION <%=  privCheck %> VALUE=private>Private</OPTION>
             </SELECT><br>

<%-- Aether description --%>
       Description:
<%
       name = "";
       if (CONTEXT.value(aetherId + ":info:description").getBase() != null) {
          name = CONTEXT.value(aetherId + ":info:description").getBase().canonical();
       }
       if (name.equals("")) {
%>
          (<FONT COLOR=RED>Enter a description of the New Aether</FONT>)
<%
       }
%>
       <BLOCKQUOTE>
       <INPUT TYPE=text MAXLENGTH=40 SIZE=30 NAME="<%=aetherId%>:info:description"
              VALUE=<%=name%>>
       </BLOCKQUOTE>

<%-- TODO: why is this one commented out ?
       <br><br>
       <BLOCKQUOTE>
       <TEXTAREA NAME="<%=aetherId%>:info:aetherDesc" COLS=50 ROWS=2>
         <%=name%>
       </TEXTAREA>
       </BLOCKQUOTE>
--%>

<%-- userId and aetherId for the query request --%>
       <input type=hidden type=text name=aetherId value=<%=aetherId %>>
       <input type=hidden type=text name=userIdReq value=<%=userIdReq %>>
       <input type=submit>
     </FORM>

     </BODY>
   </HTML>

