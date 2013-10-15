<%--
     Created in Fri Jul 16 22:48:24 EST 2004
     This page prunes the tree under dimension.
--%>
                                                                                     
<%@ page import="java.io.*" %>
<%@ page import="intense.*" %>
<%@ page import="ijsp.context.*" %>
                                                                                     
<%
   String dim = "2";
   AEther CONTEXT = AEtherManager.aether();
   CONTEXT.value(dim).clear();

%>
                                                                                     

