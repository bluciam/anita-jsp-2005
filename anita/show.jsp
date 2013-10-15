<%-- This page shows different branches of CONTEXT.
     It is not really called by anyone, it's just 
     testing.
--%>

<%@ page import="intense.*" %>
<%@ page import="ijsp.context.*" %>
<%@ page import="cgi.*" %>

<HTML>
  <HEAD>
    <TITLE>show.jsp</TITLE> 
  </HEAD>


<%
AEther CONTEXT = AEtherManager.aether();


%>
 
<form>

Enter a dimension
<input type=text name=dim><br>
</form>

<%
   CGIManager manager = new CGIManager(request);
   String dim = null;
   try {
     dim = manager.get("dim");
   } catch (Throwable t) {
%>
C'est futou!
<%
   }

if (dim != null) {
%>

<hr>
<%--
The basecount of dim <%=dim %> is <br>
<%= CONTEXT.value(dim).baseCount() %>
<hr>
--%>
The value of dim <%=dim %> is
<%--
<%= AEtherManager.htmlCanonical(CONTEXT.value(dim).canonical()) %>
<br>or
--%>
<br>
<%= AEtherManager.treeCanonical(CONTEXT.value(dim)) %>
<br>
<%
   }

%>

<hr>

<%= AEtherManager.treeCanonical(CONTEXT) %>
<%--
--%>

<%--
The current context is
<%= AEtherManager.htmlCanonical(CONTEXT.canonical()) %>.<br><br>

The current value of 1 is <br>
<%= AEtherManager.htmlCanonical(CONTEXT.value("1").canonical()) %>
<br><br>

The current value of status is <br>
<%= AEtherManager.htmlCanonical(CONTEXT.value("status").canonical()) %>
<br><br>

--%>
