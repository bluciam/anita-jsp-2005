// ****************************************************************************
//
// OwnerParticipant.java
//
// A Participant subclass for use with ThreadedAEther.
// A user of anita's server to collaboarate using a threaded Aether.
// Although the name implies that the user joins the AEther, what 
// really happens is that the Aether will attach to the personal
// branch of the user and get notified when changes occur, changing
// itself and in turn the ListenerParticipant gets notified.
//
// ****************************************************************************


package id;

import intense.*;
import ijsp.context.*;


public class OwnerParticipant extends Participant {

//Could i make all this static but public so they can be seen?
//it might be useful to see using... Might not be needed, since
//the key in the hash containes this info.
    private String node;   // to which it is attached in user
    private String name;   // the name of the participant
    private String user;   // the userId owning the participant
    private String using;  // aether being attached to personal
    public  String status; // just to know how you are!

    public  AEther CONTEXT = AEtherManager.aether(); // default aether


    /**
     * Initialization constructor with Join.
     *
     * @param name  String, name for this Participant.
     * @param user  String, onwer of this Participant.
     * @param using String, aether owned by this user.
     * @param node  String, node at which Participant will attach under user.
     */
    public OwnerParticipant(String name, String user,
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
     * @param user  String, onwer of this Participant.
     * @param using String, aether owned by this user.
     */
    public OwnerParticipant(String name, String user, String using)
    {
	super();
	this.name = name;
        this.user = user;
	this.using = using;
        this.status = "Created participant " + name;
    }


    /** 
     * Join to personal context of user at node
     *
     * @param node  String, node at which Participant will attach under user.
     */
    public void join(String node) 
    {
       super.join((AEther)CONTEXT.value(user + ":" + node));
       this.node = node;
       this.status = "User " + user + " joined AEther " + using+ " at " + node +
                     " as Owner.";
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
     * errr, the node problably. The same node in which the participant
     * is attached to.
     * @param op The version operation.
     * @param caller The AEther that effected the version operation.
     * The tree under dim in the node the participant is attached.
     */
    public void opNotify(String dim, ContextOp op, AEther caller)
    {
      if (dim == null) {
        CONTEXT.value(this.using + ":" + node).apply(op);
      } else {
        CONTEXT.value(this.using + ":" +  node + ":" + dim).apply(op);
      }
      this.status = "User " + user + " modified the AEther " + using + 
                    " from " + node; 
// setBase() ---> userId:info:shareLevel:applet:reload:<yes>.
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
      this.status = "User sent a vanillaNotify to AEther.";
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
      this.status = "User sent a kickNotify to AEther.";
    }

}
