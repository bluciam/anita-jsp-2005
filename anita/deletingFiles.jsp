<%-- Temp file to erase directories of inactive users

     Need to catch exemptions if files
     do not exist and so on.
--%>

<%@ page import="java.io.*" %>
<%@ page import="java.nio.channels.*" %>
<%@ page import="java.nio.*" %>
<%@ page import="java.util.*" %>


<%
String userDir ="/usr/local/tomcat/webapps/anita/users/user10";

File aBorrar = new File(userDir);
List files = Arrays.asList(aBorrar.listFiles());
Iterator itrFiles = files.iterator();
while (itrFiles.hasNext()) {
   File archivo = (File)itrFiles.next();
   archivo.delete();
%>
   <br>
   <%= archivo  %>
   <br>
<%
}

boolean borrado = aBorrar.delete();
if (borrado) {
%>
   Directorio  <%= aBorrar %> borrado <br>
<%
} else {
%>
   Directorio  <%= aBorrar %> NO fue borrado <br>
   <br>
<%
}


if (aBorrar.isDirectory()) {
%>
   Directorio  <%= aBorrar %> es directorio <br>
<%
} else {
%>
   Directorio  <%= aBorrar %> NO es directorio <br>
   <br>
<%
}



%>
<br>
<%= aBorrar.list() %>
<%= aBorrar.listFiles() %>
<br>
