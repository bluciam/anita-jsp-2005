<%-- This file (makeMap.jsp) is part of the Anita Conti Mapping 
     Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Fri Dec 12 11:46:47 EST 2003

     This jsp page makes a map using the values in the CONTEXT 
     and of the CGI request. Control is forwarded to anita.jsp
     which displays the new map.

     Start to work on it again: Tue Jul 13 23:06:48 EST 2004
     to sort out map making and storage.
     NEEDED: some twicking of the vspace to get the map number in
     perhaps in the session branch...

     Last-last update Mon Aug  2 21:14:27 CDT 2004
     Trying to get the labels on...
--%>

<%@ page import="intense.*" %>
<%@ page import="concurrent.*" %>
<%@ page import="ijsp.context.*" %>
<%@ page import="id.ListBaseString" %>

<%@ page import="cgi.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="java.io.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<%
   AEther CONTEXT = AEtherManager.aether();
   String userIdReq = null;
%>

<%-- Forward to startUp.jsp if there is no query request of the 
     form from=anita or there is no query at all. That will
     cover all the problems I could think of now.
--%>

<%
//Getting the cgi arguments into a hash and checking certain values
   try {
      CGIManager manager = new CGIManager(request);
      HashMap hashmap = manager.getArgsHashMap();
      Set keys = hashmap.keySet();
      Collection values = hashmap.values();
      userIdReq = (String)(hashmap.get("userIdReq"));
   } catch (Exception e) { // if any CGI is wrong, just redirect
      %> <jsp:forward page="startUp.jsp" /> <%
   }
   pageContext.setAttribute("userIdReq",userIdReq); //must survive the page


/* Checking if this user is an owner of any aether. If so, need to
   update dimension aetherId:makeMap so the listeners get a signal
   to make a map.
*/
   if (CONTEXT.value(userIdReq + ":info:shareLevel").getBase().canonical().
               equals("on")) { 
      String eteres = CONTEXT.value(userIdReq + ":info:shareLevel:aetherList").
                              getBase().canonical();
      LinkedList eterList = id.ListBaseString.unPack(eteres);
      for (int i = 0; i < eterList.size(); i++) {
         try {
            String mode = null;
            mode = CONTEXT.value(userIdReq + ":" + eterList.get(i) +
                          ":info:gmt").getBase().canonical(); 
            if (mode.equals("owner")) {
               CONTEXT.value(eterList.get(i) + ":makeMap").apply("yes");
            }
         } catch (Exception e) {
         }
      }
   }


// Getting a new map number.
   String mapNumber;
   Sequence tempMap = (Sequence)application.getAttribute("mapId");
   if (tempMap == null) { //need new map sequence
      Sequence mapId = new Sequence();
      application.setAttribute("mapId", mapId);
      mapNumber = Long.toString(mapId.next());
   } else { //tempMap holds last assigned session id
      mapNumber = Long.toString(tempMap.next());
   }

// Updating the current (mapNumber) and previous map numbers (with current). 
   CONTEXT.value(userIdReq + ":info:prevMap").
           apply(CONTEXT.value(userIdReq + ":info:currentMap").getBase());
   CONTEXT.value(userIdReq + ":info:currentMap").apply(mapNumber);

// Saving this map context in file users/user+Id/mapContext+mapNumber.context
   String mapContextTxt = CONTEXT.value(userIdReq + ":gmt").canonical();
   String userDirS = "/usr/local/tomcat/webapps/anita/users/user" + userIdReq;
   String contextFileName = userDirS + "/mapContext" + mapNumber + ".context";
   FileOutputStream mapContext = new FileOutputStream(contextFileName);
   PrintWriter pw = new PrintWriter(mapContext);
   pw.println(mapContextTxt);
   pw.close();
   mapContext.close();

// TODO: decide whether we need a list of previous maps. Here is the place.


// BUILDING PSCOAST command

   Runtime thisSystem = Runtime.getRuntime();
   String map = "map" + mapNumber;
   File userDir = new File(userDirS);

   // Defining an array for the region because its accessed several times
   String[] wesn = new String[4]; 
   String dim = userIdReq + ":gmt:proj:region:";
   wesn[0] = CONTEXT.value(dim + "west").getBase().canonical();
   wesn[1] = CONTEXT.value(dim + "east").getBase().canonical();
   wesn[2] = CONTEXT.value(dim + "south").getBase().canonical();
   wesn[3] = CONTEXT.value(dim + "north").getBase().canonical();
   String pscoast = makepscoast(userIdReq, wesn);

   // Running pscoast command
   Process procPscoast = thisSystem.exec(pscoast, null, userDir);
   InputStream outPscoast = procPscoast.getInputStream(); // del proceso

   // Creating the file map.ps from InputStream outPscoast
   FileOutputStream mapPs = new FileOutputStream(userDirS + "/" + map + ".ps"); 
   int theByte = 0;
   while((theByte = outPscoast.read()) != -1) {
      mapPs.write(theByte);
   }

   // Creating the file .pscoastERR from InputStream errPscoast
   InputStream errPscoast = procPscoast.getErrorStream();
   FileOutputStream errors = new FileOutputStream(userDirS + "/.pscoastERR");
   while((theByte = errPscoast.read()) != -1) {
      errors.write(theByte);
   }

   // Writing out the command line into file .gmtCmd
   FileOutputStream gmtCmd = new FileOutputStream(userDirS + "/.gmtCmd");
   PrintWriter pwCmd = new PrintWriter(gmtCmd);
   pwCmd.println(pscoast);
   pwCmd.flush();

// END OF BUILDING PSCOAST command


// IF asking for labels need an extra layer created by psomega
   if (!CONTEXT.value(userIdReq + ":gmt:lgMap").getBase().canonical().
               equals("none")) {
      // The makeQuery function builds the query to request information
      // from namesWorld and the string is return in "result".
      // Here, I create a file named .theQuery containing 'result'. 
      // TODO: skip the file .theQuery and do it through a pipe.

// BEGIN OF BUILDING POSTGRESQL command
      String result = makeQuery(userIdReq, wesn);
      FileOutputStream query = new FileOutputStream(userDirS + "/.theQuery");
      PrintWriter pwQuery = new PrintWriter(query);
      pwQuery.println(result);
      pwQuery.flush();

      String psqlCmd = "/usr/local/packages/postgresql-8.0.0/bin/psql " +
           "--dbname namesWorld  --tuples-only " +
           "--no-align --file .theQuery --username postgres" ;

//           "--dbname worldnames  --tuples-only --field-separator ' ' " +
//           "--no-align --file .query --output .Namestxt --username postgres" ;
//can't get the -fieldseparator ' ' to be blank. Must be the java parser...
//we will make the query come from a file cuz I can't get --command to work

      Process procPsql = thisSystem.exec(psqlCmd, null, userDir);
      InputStream outPsql = procPsql.getInputStream();
      BufferedReader inn = new BufferedReader(new InputStreamReader(outPsql));

      // Processing the database query output and converting into 
      // the GMT textfile, input to psomega (and pstext)
      FileOutputStream textfile = new FileOutputStream(userDirS + "/.textfile");
      pw = new PrintWriter(textfile);
      String lineOut = null;
      String line = null;

      Pattern p = Pattern.compile("(.*)\\|\\((.*),(.*)\\)");
      Matcher m;

      String name = null, x = null, y = null;
      while((line = inn.readLine()) != null) {
         m = p.matcher(line);
         if (m.matches()) {
            name = m.group(1);
            x = m.group(2);
            y = m.group(3);
            lineOut = x + " " + y + " 10 0 4 CT " + name;
            pw.println(lineOut);
     
// DEBUGGING
%> <%= lineOut %>  <br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; and name = <%= name %>
and <%= x %> and <%= y %> <br>   <%
// END DEBUGGING
         }
      }
      pw.close(); // Closing the .textfile

      // Creating file .psqlERR from InputStream errPsql of process procPsql
      InputStream errPsql = procPsql.getErrorStream();
      errors = new FileOutputStream(userDirS + "/.psqlERR");
      while((theByte = errPsql.read()) != -1) {
         errors.write(theByte);
      }


// BEGIN PSOMEGA command
      String partDim = userIdReq + ":gmt:proj:";

      String[] values = new String[2];
      values = CONTEXT.value(partDim).getBase().canonical().split(":");

 //      String psomega = "/usr/local/packages/GMT4.0/bin/psomega -J" +
      String psomega = "/usr/local/packages/GMT4.0/bin/pstext -J" +
         values[1] +
         CONTEXT.value(partDim + "SorW:width").getBase().canonical() +
         CONTEXT.value(partDim + "SorW:width:units").getBase().canonical() +
         " -R" +  wesn[0] + "/" + wesn[1] + "/" + wesn[2] + "/" + wesn[3] +
         " .textfile -O";

      // Writing the command line into gmtCmd file
      pwCmd.println(psomega);
      pwCmd.flush();

      // Adding postscript contents of pscoast output to file map.ps
      Process procPsomega = thisSystem.exec(psomega, null, userDir);
      InputStream outPsomega = procPsomega.getInputStream(); // del proceso
      theByte = 0;
      while((theByte = outPsomega.read()) != -1) {
         mapPs.write(theByte);
      }

      // Creating the file .psomegaERR from InputStream errPsomega
      InputStream errPsomega = procPsomega.getErrorStream();
      errors = new FileOutputStream(userDirS + "/.psomegaERR");
      while((theByte = errPsomega.read()) != -1) {
         errors.write(theByte);
      }

// END PSOMEGA command
    } // end if labels


    // converting the ps into png 
    String[] env = new String[1];
    env[0] = "PAPERSIZE=a2";
    String ps2img = "/usr/bin/pstoimg -quiet -crop a -aaliastext -white " +
//                    map + ".ps";
                    "-discard " + map + ".ps";
    Process procPs2img = thisSystem.exec(ps2img, env, userDir);
    procPs2img.waitFor();
    // end of ps to png

%>

<%-- BEGIN DEBUGGING --%>
<%= pscoast %>

<br>Map number is <%= mapNumber %> <br><br>
and the previous map is <%= CONTEXT.value(userIdReq+":info:prevMap").getBase().canonical() %> <br><br>

<br>
    Back to <a href=anita.jsp?userIdReq=<%= userIdReq %>>anita.jsp</a>
<br> <br> <br>
<%-- END DEBUGGING --%>


<c:redirect url="anita.jsp" >
  <c:param name="userIdReq" value="${userIdReq}" />
</c:redirect>
<%--
--%>

<%! //This method takes ALL the parameters from the context for pscoast
  String makepscoast(String userIdReq, String[] wesn) {
    AEther CONTEXT = AEtherManager.aether();
    StringBuffer result = new StringBuffer(
       "/usr/local/packages/GMT4.0b/bin/pscoast -J"
    );

    String partDim = userIdReq + ":gmt:proj:";
    String projString = null;

    // The basevalue of proj is of the form projType:gmtProj. GMT pscoast
    // needs gmtProj to know which projection to plot.
    String[] values = new String[2];
    String dimValue = CONTEXT.value(partDim).getBase().canonical();
    values = dimValue.split(":");
    int projType = Integer.parseInt(values[0]);

    switch(projType) {
      case 1: // Mercator defaults
        projString = values[1];
        break;

      case 2: // lon0
        projString = values[1] + 
        CONTEXT.value(partDim + dimValue + ":lon0").getBase().canonical()+ "/" ;
      break;

      case 3: // lon0, lat0
      case 4: // lon0, lats
        projString = values[1] +
        CONTEXT.value(partDim + dimValue + ":lon0").getBase().canonical()+ "/" +
        CONTEXT.value(partDim + dimValue + ":lat0").getBase().canonical()+ "/" ;
      break;

      case 5: // lon0, lat0, lon1, lat1 
        projString = values[1] +
        CONTEXT.value(partDim + dimValue + ":lon0").getBase().canonical()+ "/" +
        CONTEXT.value(partDim + dimValue + ":lat0").getBase().canonical()+ "/" +
        CONTEXT.value(partDim + dimValue + ":lon1").getBase().canonical()+ "/" +
        CONTEXT.value(partDim + dimValue + ":lat1").getBase().canonical()+ "/" ;
      break;

      case 6: // lon0, lat0, lat1, lat2
        projString = values[1] + 
        CONTEXT.value(partDim + dimValue + ":lon0").getBase().canonical()+ "/" +
        CONTEXT.value(partDim + dimValue + ":lat0").getBase().canonical()+ "/" +
        CONTEXT.value(partDim + dimValue + ":lat1").getBase().canonical()+ "/" +
        CONTEXT.value(partDim + dimValue + ":lat2").getBase().canonical()+ "/" ;
      break;
    }

    String projStringSize =
       CONTEXT.value(partDim + "SorW:width").getBase().canonical() +
       CONTEXT.value(partDim + "SorW:width:units").getBase().canonical();
    String region = " -R" +
       wesn[0] + "/" + wesn[1] + "/" + wesn[2] + "/" + wesn[3];
    result.append(projString + projStringSize + region);

    partDim = userIdReq + ":gmt:frame";
    if (CONTEXT.value(partDim).getBase().canonical().equals("on")) {
       StringBuffer Bopts = new StringBuffer(" -B" +
          "a" + CONTEXT.value(partDim + ":x:annot").getBase().canonical() +
          "f" + CONTEXT.value(partDim + ":x:frame").getBase().canonical() +
          "g" + CONTEXT.value(partDim + ":x:grid").getBase().canonical() +
         "/a" + CONTEXT.value(partDim + ":y:annot").getBase().canonical() +
          "f" + CONTEXT.value(partDim + ":y:frame").getBase().canonical() +
          "g" + CONTEXT.value(partDim + ":y:grid").getBase().canonical());
       if (CONTEXT.value(partDim + ":plottitle").getBase().canonical().
           equals("on"))
       {
          Bopts.append(":." + CONTEXT.value(partDim + ":plottitle:title").
                       getBase().canonical() + ":"
                      );
       }

       boolean sideTrue = false;
       String side[] = {"W", "E", "S", "N"};

       for (int i=0; i < 4; i++) {
          String sside = side[i];
          String sSetting = CONTEXT.value(partDim + ":side:" + sside).
                                    getBase().canonical();
          if (sSetting.equals("Y")) {
             Bopts.append(sside);
             sideTrue = true;
          } else if (sSetting.equals("y")) {
             Bopts.append(sside.toLowerCase());
             sideTrue = true;
          }
       }

       if (sideTrue) 
          result.append(Bopts.toString()); // else no add any Bopts
    } // else no frame for the map

    partDim = userIdReq + ":gmt:color:";   
    String lcolor = CONTEXT.value(partDim +"land").getBase().canonical();
    String wcolor = CONTEXT.value(partDim +"water").getBase().canonical();

    if (lcolor.equals("on")) {
        result.append(" -G" +
           CONTEXT.value(partDim + "land:red").getBase().canonical() + "/" +
           CONTEXT.value(partDim + "land:green").getBase().canonical() + "/" +
           CONTEXT.value(partDim + "land:blue").getBase().canonical());
    } else if (lcolor.equals("grey")) {
        result.append(" -G" +
           CONTEXT.value(partDim + "land:grey").getBase().canonical());
    } // no ground color

    if (wcolor.equals("on")) {
        result.append(" -S" +
           CONTEXT.value(partDim + "water:red").getBase().canonical() + "/" +
           CONTEXT.value(partDim + "water:green").getBase().canonical() + "/" +
           CONTEXT.value(partDim + "water:blue").getBase().canonical());
    } else if (wcolor.equals("grey")) {
        result.append(" -S" +
           CONTEXT.value(partDim + "water:grey").getBase().canonical());
    } // no water color

    partDim = userIdReq + ":gmt:contents:";
    if (CONTEXT.value(partDim + "coastLines").getBase().canonical().
                equals("on")) {
       result.append(" -W2");
    }

    String border = CONTEXT.value(partDim + "borders").getBase().canonical();
    if (border.equals("1")) {
       result.append(" -N1/1");
    }
    if (border.equals("2")) {
       result.append(" -N1/1 -N2/0.5");
    }
    if (border.equals("3")) {
       result.append(" -N1/1 -N2/0.5 -N3/0.25");
    }

    String rivers = CONTEXT.value(partDim + "rivers").getBase().canonical();
    if (!rivers.equals("none")) {
       result.append(" -I" + rivers);
    }

    result.append(" -P -D" + 
                  CONTEXT.value(partDim + "resolution").getBase().canonical());

    if (!CONTEXT.value(userIdReq + ":gmt:lgMap").getBase().canonical().
                 equals("none")) {
      result.append(" -K");
    }

    return result.toString();
  }
%>


<%! //This method creates the input text files or input stream for psomega
    //For now language will be one of 3: fr, es and en, resolvable here.
    // not at the database label. That is for future development when 
    //there are several databases supporting different languages, then 
    //the language table IS database dependent.
  String makeQuery(String userIdReq, String[] wesn) {
    AEther CONTEXT = AEtherManager.aether();
    StringBuffer result = new StringBuffer();
    int region = 0; // assume one canonical region

    float west = Float.parseFloat(wesn[0]);
    float east = Float.parseFloat(wesn[1]);
    float south = Float.parseFloat(wesn[2]);
    float north = Float.parseFloat(wesn[3]);

    if (east > 180 && west > 180) {
       west -= 360;
       east -= 360;
       region = 1;
    } else if (east < -180 && west < -180) {
       west += 360;
       east += 360;
       region = 1;
    } else if (east > 180) {
       east -= 360;
       region = 2;
//    } else if (east < -180) {
//       east += 360;
//       region = 2;
//    } else if (west > 180) {
//       west -= 360;
//       region = 2;
    } else if (west < -180) {
       west += 360;
       region = 2;
    }




    String lang = CONTEXT.value(userIdReq + ":gmt:lgMap").getBase().canonical();
    StringBuffer theQuery = new StringBuffer();
   if (region == 2) { // west -> 180 and -180 -> east 

      theQuery.append(
               "SELECT name_code, center(bounding_box) AS center " +
               "INTO TABLE locationA FROM location " +
               "WHERE bounding_box && box'((" + west + "," + south +
               "),(180," + north + "))'; \n"
      );
      theQuery.append(
               "SELECT name_code, center(bounding_box) AS center " +
               "INTO TABLE locationB FROM location " +
               "WHERE bounding_box && box'((-180," + south +
               "),(" + east + "," + north + "))'; \n"
      );

     theQuery.append(
               "SELECT l.name, t.center FROM " + lang +
               " l, locationA t WHERE l.name_code = t.name_code; \n"
     );
     theQuery.append(
               "SELECT l.name, t.center FROM " + lang +
               " l, locationB t WHERE l.name_code = t.name_code; \n"
     );
     theQuery.append("DROP TABLE locationA; \n");
     theQuery.append("DROP TABLE locationB; \n");


   } else { // west to east
      theQuery.append(
               "SELECT name_code, center(bounding_box) AS center " +
               "INTO TABLE locationA FROM location " +
               "WHERE bounding_box && box'((" + west + "," + south +
               "),(" + east + "," + north + "))'; \n"
      );
     theQuery.append(
               "SELECT l.name, t.center FROM " + lang +
               " l, locationA t WHERE l.name_code = t.name_code; \n"
     );
     theQuery.append("DROP TABLE locationA; \n");

   }

// theQuery needs to go in a file (.theQuery) because could not figure out
// how to interacively run psql using the option --command in the cmd line.

//   String userDirS = "/usr/local/tomcat/webapps/anita/users/user" + userIdReq;

// TODO: check why is this giving an error in compilation
//   PrintWriter out = new PrintWriter(new FileOutputStream(userDirS +
//                                                          "/.theQuery"));
//   out.println(theQuery.toString());
//   out.flush();

   return theQuery.toString();
  }

%>
