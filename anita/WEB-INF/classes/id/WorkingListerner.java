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


public class ListenerParticipant extends Participant {

    private String node;   // to which it is attached in the Aether
    private String user;   // the userId owning the participant
    private String name;   // the name of this participants
    private String using;  // aether this participant is attaching to
    public  String status; // just to know how you are!

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
                               String using, String node)
    {
        super(); 
	this.name = name;
        this.user = user;
        this.using = using;
        join(node);
    }

    /**
     * Initialization constructor.
     *
     * @param name  String, name for this Participant.
     * @param user  String, userId which owns the Participant.
     * @param using String, the aether the participant will attach to.
     */
    public ListenerParticipant(String name, String user, String using)
    {
        super();
        this.name = name;
        this.user = user;
        this.using = using;
        this.status = "Created participant " + name;
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
        CONTEXT.value(user + ":" + using + ":" + node).apply(op);
      } else {
        CONTEXT.value(user + ":" + using + ":" + node + ":" + dim).apply(op);
      }
      this.status = "User " + user + " recieved an opNotify from AEther " + 
                    using + " at " + node;
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
