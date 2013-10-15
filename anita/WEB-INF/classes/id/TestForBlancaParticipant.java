// ****************************************************************************
//
// AnitaParticipant.java
//
// A Participant subclass for use with ThreadedAEther.
// A user of anita's server to collaboarate using an Aether.
//
// This is an attempt to rewrite TestForBlancaParticipant
//
// ****************************************************************************


package id;


import intense.*;
import ijsp.context.*;
import java.util.*;
import java.io.*;
import javax.servlet.jsp.*;


public class TestForBlancaParticipant extends Participant {

    private JspWriter out;
    private String name;

    /**
     * Initialization constructor.
     *
     * @param out A JspWriter output stream to write to.
     * @param name A String name for this Participant.
     */
    public TestForBlancaParticipant(javax.servlet.jsp.JspWriter out,
				    String name)
    {
	super();
	this.out = out;
	this.name = name;
    }

    /**
     * Initialization constructor with a join.
     *
     * @param aether An AEther to join.
     * @param out A JspWriter output stream to write to.
     * @param name A String name for this Participant.
     */
    public TestForBlancaParticipant(AEther aether,
				    javax.servlet.jsp.JspWriter out,
				    String name)
    {
        super(aether);
	this.out = out;
	this.name = name;
    }

    /**
     * Notify this Participant of a version operation, which just prints
     * the canonical form to the output stream.
     *
     * @param dim The dimension under which the operation occurred (null if the
     * AEther is the same as the Participant's current AEther).
     * @param op The version operation.
     * @param caller The AEther that effected the version operation.
     */
    public void opNotify(String dim, ContextOp op, AEther caller)
    {
	String outputString =
	    "Received an operation in a participant \"" + name + "\":<br>\n" +
	    "dimension: \"" + dim + "\"<br>\n" +
	    "op: " + AEtherManager.htmlCanonical(op.canonical()) + "<br>\n";
	try {
	    out.print(outputString);
	} catch (IOException e) {
	}
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
	String outputString =
	    "Received a vanilla notification in participant \"" +
	    name + "\":<br>\n";
	try {
	    out.print(AEtherManager.htmlCanonical(outputString));
	} catch (IOException e) {
	}
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
	String outputString =
	    "Received a kick notification in participant \"" +
	    name + "\":<br>\n";
	try {
	    out.print(AEtherManager.htmlCanonical(outputString));
	} catch (IOException e) {
	}
    }

}
