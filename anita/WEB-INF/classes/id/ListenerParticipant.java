// ****************************************************************************
//
// ListenerParticipant.java
//
// A Participant subclass for use with ThreadedAEther.
// A user of anita's server to collaboarate using a threaded Aether.
// This participant gets nodtified of changes in the AEther it
// is connected to. This participant can't modify the Aether.
//
// ****************************************************************************


package id;

import intense.*;
import ijsp.context.*;
import java.util.*;
import java.io.*;
import javax.servlet.jsp.*;



public class ListenerParticipant extends Participant {

    private String node;   // to which it is attached in the Aether
    private String user;   // the userId owning the participant
    private String name;   // the name of this participants
    private String using;  // aether this participant is attaching to
    public  String status; // just to know how you are!

    private JspWriter out;
    public AEther CONTEXT = AEtherManager.aether(); // default aether


    /**
     * Initialization constructor with a join.
     *
     * @param name   String, name for this Participant.
     * @param user   String, userId which owns the Participant.
     * @param using  String, the aether the participant will attach to.
     * @param node   String, node at which Participant will attach under using.
     *
     * should probably change this constructor since now it is using 
     * the join of Participant and we can't initialize node...
     */
    public ListenerParticipant(String name,  String user, 
                               String using, String node,
                               javax.servlet.jsp.JspWriter out)
    {
        super(); 
	this.name = name;
        this.user = user;
        this.using = using;
        this.out = out;
        join(node);
    }

    /**
     * Initialization constructor.
     *
     * @param name  String, name for this Participant.
     * @param user  String, userId which owns the Participant.
     * @param using String, the aether the participant will attach to.
     */
    public ListenerParticipant(String name, String user, String using,
                               javax.servlet.jsp.JspWriter out)
    {
        super();
        this.name = name;
        this.user = user;
        this.using = using;
        this.status = "Created participant " + name;
        this.out = out;
    }


    /** 
     * Join to aether CONTEXT at node node.
     *
     * @param node   String, node at which Participant will attach under using.
     */
    public void join(String node) 
    {
       super.join((AEther)CONTEXT.value(using + ":" + node));
       this.node = node;
       this.status = "User " + user + " joined AEther " + using+ " at " + node;

    }


    public void leave()
    {
       super.leave();
       this.status = "User " + user + " left AEther " + using + " from " + node;
    }



    /**
     * Notify this Participant of a version operation, which changes
     * the branch of the aether part of the personal context.
     *
     * @param dim The dimension under which the operation occurred (null if 
     * the AEther is the same as the Participant's current AEther).
     * Errr, the node problably. The same node in which the participant
     * is attached to.
     * @param op The version operation.
     * @param caller The AEther that effected the version operation.
     * The tree under dim in the node the participant is attached.
     */
    public void opNotify(String dim, ContextOp op, AEther caller)
    {
      if (dim == null) {
        CONTEXT.value(user + ":" + node).apply(op);
      } else {
        CONTEXT.value(user + ":" + node + ":" + dim).apply(op);
      }
      this.status = "User " + user + " recieved an opNotify from AEther " + 
                    using + " at " + node;

       synchronized (this) {
           this.notify();
       }


//"  <PARAM NAME=TARGETWINDOW  VALUE=ParticipantListerner >" +

/*
CONTEXT.value(user + ":" + using + ":shareLevel:applet").apply(
"<APPLET CODE=ListenerParticipantApplet.class" + 
"        ARCHIVE=./ijsp.jar,./intense.jar" +
"        WIDTH=200 HEIGHT=75>" +
"  <PARAM NAME=TARGETURL VALUE=anita.jsp >" +
"  <PARAM NAME=USERID VALUE=" + user + " >" +
"  <PARAM NAME=AETHERID VALUE=" + using + " >" +
"</APPLET>" 
);
*/

// WILD GUESS
// So instead of trying to redirect we just rerun the applet by
// adding the code as a base value somewehre and when anita is
// reloaded if applet has a value just load put it up...
// so in the start method of run methods we updateWindow...
// not sure it this will work, but must try.

// it doesn't work unless we can tell the applet here to reload here. 
// but how...

/*
      String outputString =
"<c:redirect url=\"anita.jsp\" >" +
"  <c:param name=\"userIdReq\" value=\"${userIdReq}\" />" +
"</c:redirect>";
      try {
        out.print(outputString);
      } catch (IOException e) {
      }
*/

    }

    /**
     * Notify this Participant of a vanilla VSET operation, waking it
     * up first, if it is waiting for operations.  This is meant to be
     * called only by an AEther to which this Participant is joined.
     *
     * @param dim The dimension under which the operation occurred (null if the
     * AEther is the same as the Participant's current AEther).
     * @param caller The AEther that effected the version operation.
     */
    public void vanillaNotify(String dim, AEther caller)
    {
      this.status = "Recieved a vanillaNotify.";
    }

    /**
     * This is to notify the Participant that it has been removed from the
     * calling AEther's list of Participants.  It should be assumed that the
     * caller will delete this Participant shortly after kickNotify() returns.
     * This method is only meant to be called by the AEther to which this
     * Participant is joined.
     *
     * @param caller The AEther doing the kicking.
     */
    public void kickNotify(AEther caller)
    {
      this.status = "Recieved a kickNotify.";
    }

}
