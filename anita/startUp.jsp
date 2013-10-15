<%-- This file (startUp.jsp) is part of the Anita Conti Mapping 
     Server, copyright and left Blanca Mancilla 2003.
     Last Updated: Fri Apr 11 13:18:05 EST 2003.
     This jsp page is the booting script of the Server. 
     Each time this page is called, a new userId and sessionId 
     numbers are created as well as a branch for CONTEXT:userId.
     It also sets the CONTEXT:status and updates the userId list. 
     It automatically redirects to anita.jsp.

     Last-last updated :Mon Jul 12 11:46:15 EST 2004
     Getting rid of the session business. Right now it does not
     mean anything, Map info will go the disk in a directory under 
     $anita, perhaps created here?

     Sun May  1 14:01:23 EST 2005
     Including a CRON to delete user branches and directories 
     older than a week using the lastAccessed node.
--%>

<%@ page import="intense.*" %>
<%@ page import="concurrent.*" %>
<%@ page import="ijsp.context.*" %>
<%@ page import="id.ListBaseString" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.channels.*" %>
<%@ page import="java.nio.*" %>
<%@ page import="java.text.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<HTML>
  <HEAD>
    <TITLE> This is startUp.jsp </TITLE> 
  </HEAD>

<% 
   // Getting the current userId counter value from the container.
   String userIdString;
   Sequence tempUser = (Sequence)application.getAttribute("userId"); 
   if (tempUser == null) { //need new user sequesce
      Sequence userId    = new Sequence();
      application.setAttribute("userId", userId);
      userIdString = Long.toString(userId.next());
   } else { //tempUser holds last assigned user id
      userIdString = Long.toString(tempUser.next());
   }
   pageContext.setAttribute("userIdReq",userIdString); //must survive the page

   AEther CONTEXT = AEtherManager.aether();

   // Update last date server was accessed. P.154 Java in a Nutshell
//   String theDate = new java.util.Date().toString();
//   DateFormat df = DateFormat.getDateInstance(DateFormat.FULL);

   DateFormat df = DateFormat.
                   getDateTimeInstance(DateFormat.FULL, DateFormat.FULL);
   String theDate = df.format(new Date());
   if (CONTEXT.vanilla()) {
      CONTEXT.value("status:dateStamp:created").apply(theDate);
      CONTEXT.value("status:dateStamp:lastAccess").apply(theDate);
   } else {
      CONTEXT.value("status:dateStamp:lastAccess").apply(theDate);
   }

   // Updating the status branch with current user information
   if (CONTEXT.value("status:users").getBase() == null) {
     CONTEXT.value("status:users").apply(userIdString);
   } else {
     String users = CONTEXT.value("status:users").getBase().canonical();
     LinkedList usersList = id.ListBaseString.unPack(users);
     usersList.add(userIdString);
     CONTEXT.value("status:users").apply(id.ListBaseString.pack(usersList));
   }
   // If the program throws an intensional exemption following, the list of 
   // users will not be correct. But, I am assuming that running will be smooth.
   // End of updating status branch


   // Creating the userId branch
   //
   String opUserId = 
   "[" + userIdString + ":" +
     "[gmt:[color:[land:[grey+blue:[128]+green:[128]+grey:[200]+red:[240]]+" +
                 "water:[off+blue:[250]+green:[125]+grey:[255]+red:[131]]]+" +
           "contents:[borders:[none]+coastLines:[off]+resolution:[l]+rivers:[none]]+" +
           "frame:[on+plottitle:[off+title:[\"A map\"]]+" +
                     "side:[W:[Y]+E:[Y]+S:[Y]+N:[Y]]+" +
                     "x:[annot:[0]+frame:[0]+grid:[0]]+" +
                     "y:[annot:[0]+frame:[0]+grid:[0]]]+" +
           "lgMap:[none]+" +
           "makeMap:[no]+" +
           "proj:[M+range:[dlat:[140]+dlon:[360]]+" +
                 "region:[east:[\"330\"]+north:[\"70\"]+" +
                         "south:[\"-70\"]+west:[\"-30\"]]+" +
                   "zoom:<4>+" +
                   "height:[3]+" +
                   "SorW:[wd+scale:units:[unitDegree]+" +
                            "width:[7+units:[i]]]]]+" +
      "interface:[gmtLevel:[none]+" +
                "omegaLevel:[none]+" +
                "lgIn:[en]+" +
                "color:[text:[black]+backg:[white]]" +
                "]+" +
      "window:[ULx:[10]+ULy:[10]+width:[1000]+height:[910]" +
             "]+" +
      "info:[shareLevel:[off]+currentMap:[0]]" +
     "]]";

   ContextOp op = new ContextOp();
   op.parse(opUserId);
   CONTEXT.apply(op);

   CONTEXT.value(userIdString + ":info:dateStamp:created").apply(theDate);
   CONTEXT.value(userIdString + ":info:dateStamp:lastAccess").apply(theDate);
   CONTEXT.value(userIdString + ":gmt:proj").apply("1:M");
     
   // End of userId branch

   // Creating this users directory to store maps and context ops 
    String userDir ="/usr/local/tomcat/webapps/anita/users/user" + userIdString;
    File usrDir = new File(userDir);
    usrDir.mkdir();
  
    String mapContextTxt = CONTEXT.value(userIdString + ":gmt").canonical();
    // Creating the file mapContext0.context with the context of map 0
    FileOutputStream mapContext =
       new FileOutputStream(userDir + "/mapContext0.context");
    PrintWriter pw = new PrintWriter(mapContext);
    pw.println(mapContextTxt);
    pw.flush();
    mapContext.close();

// TODO: i might not need file channels... But I believe they are faster
// A suggestion is to use the code in JAVA IN A NUTSHELL, page 181-2

    // Copying 0.png into users/user+Id/map0.png
    String map0 = "/usr/local/tomcat/webapps/anita/map0.png";
    FileInputStream  mapIn  = new FileInputStream(map0);
    FileOutputStream mapOut = new FileOutputStream(userDir + "/map0.png");
    FileChannel      inC    = mapIn.getChannel();
    FileChannel      outC   = mapOut.getChannel();
    ByteBuffer       buffer = ByteBuffer.allocateDirect(8192);
    while(inC.read(buffer) != -1 || buffer.position() > 0) {
       buffer.flip();
       outC.write(buffer);
       buffer.compact();
    }
    inC.close();
    outC.close();
    mapIn.close();
    mapOut.close();

%>

<% 
/* C L E A N I N G   U P   O L D   U S E R S
*/

/* Begin code for implementing a clean up operation: delete user branches
// and directoires that have not been used for a week.
/*/
   String     users     = CONTEXT.value("status:users").getBase().canonical();
   LinkedList usersList = id.ListBaseString.unPack(users);
   LinkedList toDelete  = new LinkedList();
   Iterator   itr       = usersList.iterator();

   // Setting up calendar and dates
   Calendar cal = Calendar.getInstance();
   cal.setTime(new Date());
//   cal.add(Calendar.DATE, -7);
   cal.add(Calendar.DATE, -12);
   cal.add(Calendar.HOUR, -15);
//   cal.add(Calendar.MINUTE, 5);
   Date expiration = cal.getTime();

%>

   This is the current date: <%= theDate %><br>
   The expiration date is <%= df.format(expiration)%><br>
<%

   // Going through the users list to kill old users
   while (itr.hasNext()) {
      String thisUser   = (String)itr.next();
      String dateString = CONTEXT.value(thisUser + ":info:dateStamp:lastAccess").
                                  getBase().canonical();
      // the aether (?) adds quotes to the date which we must supress...
      // Deleting quotes on userDate
      int    largo    = dateString.length();
      String newDate  = dateString.substring(1,largo-1);
      Date   userDate = df.parse(newDate);

      // Checking for outdated users, putting them in the toDelete LinkedList
      // to process later.
      if (userDate.before(expiration)) {
         toDelete.add(thisUser);
%>
         <br> User <%= thisUser %> must be deleted...<br>
<%
       } else {
%>
         <br> User <%= thisUser %> is still alive. 
         The user date is <%= df.format(userDate) %> <br>
<%
      }
   }


/* Lets delete the oldies */
   Iterator itrToDel = toDelete.iterator();
   while (itrToDel.hasNext()) {
      String thisUser = (String)itrToDel.next();
      // Must delete branches and directories and update userLists
      // Deleting the user directory
      try {
         File userDirToDel = new 
                             File("/usr/local/tomcat/webapps/anita/users/user" 
                                  + thisUser);
         List files = new ArrayList(Arrays.asList(userDirToDel.listFiles()));
         Iterator itrFiles = files.iterator();
         // 1. delete files in the directory
         while (itrFiles.hasNext()) {
            ((File)(itrFiles.next())).delete();
         }
         // 2. Now delete the directory 
         if (!userDirToDel.delete()) {
%>
            <br>User directory <%= thisUser %> not deleted<br>
<%
         }

      } catch (Throwable t) {
%>
         <br>Could not or did not delete any of the user files or directoriesi
         for user <%= thisUser %>.  <br>
<%
      }

      // 3. Delete user from user List
      
//      String newList = id.ListBaseString.DeleteElem(users,thisUser);
//      String newList = DeleteElem(users,thisUser);
//      CONTEXT.value("status:users").apply(newList);
// p.157 List files = new ArrayList(Arrays.asList(userDirToDel.listFiles()));

      users = CONTEXT.value("status:users").getBase().canonical();
      usersList = id.ListBaseString.unPack(users);
      usersList.remove(thisUser);
      CONTEXT.value("status:users").apply(id.ListBaseString.pack(usersList));



      // 4. Check the aether owner or listenership of this user. Delete 
      //    from aether list and if owner delete aether and update users
      //    branches of those aether (and lists).

      // Is this user sharing ?
/* This part is not really working ...
      if (CONTEXT.value(thisUser + ":info:shareLevel").getBase().canonical().
                  equals("on"))
      {
         String eteres = CONTEXT.value(thisUser + ":info:shareLevel:aetherList").
                                 getBase().canonical();
         LinkedList eterList = id.ListBaseString.unPack(eteres);
         Iterator itrEter = eterList.iterator();
         while (itrEter.hasNext())
         {
            String thisEter = (String)itrEter.next();
            String estado = CONTEXT.value(thisUser + ":" + thisEter + ":gmt").
                                    getBase().canonical();
            if (estado.equals("listener")) {
               // remove the participant of thisEter:gmt from the content and 
               // somehow stop de applet
               // also delete from aether:info:users
               ;
            } else {
              // check in aether:info:users the users connected to this aether
              String list = CONTEXT.value(thisEter + ":info:users").getBase().
                                    canonical();
              LinkedList listlist = id.ListBaseString.unPack(list);
              Iterator itrList = listlist.iterator();
              while (itrList.hasNext()) {
                 String thisthis = (String)itrList.next();
                 // going through the list of users attached to the aether.
                 // must do the same for each as for deleting thisUser as listener.


                 String newList = DeleteElem(users,thisUser);


              }
              String list = CONTEXT.value("status:aethers").getBase().canonical();
              LinkedList listlist = id.ListBaseString.unPack(list);
              listlist.remove(thisUser);
              CONTEXT.value("status:aethers".apply(id.ListBaseString.pack(listlist));

            }
            estado = CONTEXT.value(thisUser + ":" + thisEter + ":interface").
                             getBase().canonical();

         }

      // 5. Delete the correspoding participants

      }

*/
      // 6. And lastly, deleting the user aether branch
      CONTEXT.value(thisUser).clear();
   }

%>

<br>


<%--
<br>user <%= thisUser %> has access date of <%= dateString %> and <%= newDate %>
<br>
--%>

<c:redirect url="anita.jsp" >
  <c:param name="userIdReq" value="${userIdReq}" />
</c:redirect>


<%-- FROM HERE ON, DELETE 
The current context is
<%= AEtherManager.htmlCanonical(CONTEXT.canonical()) %><br><br>
--%>

User id = <%=userIdString %> <br><br>

The current value of gmt:lgMap is
<%= AEtherManager.htmlCanonical(CONTEXT.value(
userIdString + ":gmt:lgMap").canonical()) %>
and 
value of gmt:lgMap
<% String temp = userIdString + ":gmt:lgMap"; %> is 
<%= CONTEXT.value(temp).getBase().canonical() %> 
