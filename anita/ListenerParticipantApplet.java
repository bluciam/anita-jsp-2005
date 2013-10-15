//**********************************************************************
//
// ListenerParticipantApplet.java
//
// Sun Jul 13 20:55:27 EST 2003
// This applet is run by listerner.jsp and it becomes a participant
// in the specified node to reload anita.jsp when there is a change
// in the branch of that node.
// This code is massively based on DefaultParticipantApplet.java by
// Paul Swoboda applet participant and server manager.
//
//**********************************************************************

import cgi.*;
import intense.*;
import ijsp.context.*;
import java.io.*;
import java.applet.*;
import java.net.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class ListenerParticipantApplet extends JApplet {

    private JButton disconnectButton;      // from javax.swing
    private Container content;             // extends java.awt.Component 
    private TextAreaFrame commandLogFrame; // from ijsp.context

    private   Ear ear;                // Listener thread.
    protected String host;            // The host to connect to.
    protected int port;               // The port to connect to.

    protected long participantId;     // for the applet participant manager
    protected String dimension;       // The node this participant listens to.
    protected String targetWindow;    // Target browser window.
    protected String target;    // Ultimate target
    protected String baseUrl;         // Target initial URL.
    protected String userId;
    protected String aetherId;

    protected AEther aether;

  /** Constructor */
    public ListenerParticipantApplet() {
        aether = new AEther();
        commandLogFrame = new TextAreaFrame("Listener command log:\n\n");
    }

    public void init() {
        // applet visual part
        try {
            UIManager. // still don't where does this come from ...
                setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch(Exception e) {
            System.out.println("Error setting native LAF: " + e);
        }
        content = getContentPane();
        content.setBackground(Color.white);
        content.setLayout(new FlowLayout());
        // Add a button that closes the connection and kills the applet:
        JButton disconnectButton = new JButton("Stop Auto Reload");
        disconnectButton.addActionListener(
            new ActionListener() {
                public void actionPerformed(ActionEvent event) {
                    disconnect();
                    setVisible(false);
                }
            }
        );
        content.add(disconnectButton);

        JButton commandLogWindowButton = new JButton("Show Command Log");
        commandLogWindowButton.addActionListener(
            new ActionListener() {
                public void actionPerformed(ActionEvent event) {
                   commandLogFrame.setVisible(!commandLogFrame.isVisible());
                }
            }
        );
        content.add(commandLogWindowButton);


        // processing input parameters
        String participantIdString = null;
        if ((participantIdString = getParameter("PARTICIPANTID")) == null) {
           // We need a participantId.  The server should close the socket 
           participantId = -1;
        } else {
           try {
               participantId = Long.parseLong(participantIdString);
           } catch (NumberFormatException e) {
               participantId = -2;
           }
        }
        aether.value("participantId").
               setBase(new StringBaseValue(participantIdString));

        String statusString = getParameter("STATUS");
        if (statusString == null) {
           // Default to "listener"
           aether.value("status").setBase(new StringBaseValue("listener"));
        } else {
           aether.value("status").setBase(new StringBaseValue(statusString));
        }

        if ((dimension = getParameter("DIMENSION")) != null) {
           aether.value("dimension").setBase(new StringBaseValue(dimension));
        } else { // Error: need a dimension (node to listen to)
           participantId = -3;
        }

        if ((targetWindow = getParameter("TARGETWINDOW")) == null) {
           targetWindow = "ListenerParticipantApplet";
        }

        if ((baseUrl = getParameter("TARGETURL")) == null) {
           // This definitely shouldn't happen.  Send an error
           participantId = -4;
        }

        if ((userId = getParameter("USERID")) == null) {
           // This definitely shouldn't happen.  Send an error:
           participantId = -5;
        }
        if ((aetherId = getParameter("AETHERID")) == null) {
           // This definitely shouldn't happen.  Send an error:
           participantId = -6;
        }
        if ((target = getParameter("TARGET")) == null) {
           // This definitely shouldn't happen.  Send an error:
           participantId = -7;
        }
        // Add the message to the user
        JLabel label1 = new JLabel("You are listening to " + dimension,
                                   SwingConstants.LEFT
        );
        JLabel label2 = new JLabel(" and you are user " + userId + ".",
                                   SwingConstants.LEFT
        );
        content.add(label1);
        content.add(label2);

        String portString = getParameter("PORT");
        if (portString != null) {
           try {
               port = Integer.parseInt(portString);
           } catch (NumberFormatException e) {
               port = 4949; // Use the default port
           }
        } else {
           port = 4949; // Use the default port
        }
        host = getCodeBase().getHost();
        try {
            ear = new Ear();
            ear.start();
        } catch (Exception e) {
        }

    }


    public void start() {
        updateTargetWindow();
    }

    protected void updateTargetWindow() {
        // no point in the following block
//        BaseValue urlBase = aether.value("browser:url").getBase();
//        if (urlBase != null) {
//           String baseUrl = aether.value("browser:url").getBase().canonical();


           String targetUrl;
           try {
              // I'm assuming that there are no cgi arguments in the targetUrl
              targetUrl = baseUrl + "?userIdReq=" + userId +
                                    "&aetherId="  + aetherId +
                                    "&dimension="  + dimension +
                                    "&target="  + target +
                                    "&participantId=" + participantId;
              getAppletContext().showDocument(getDocumentRootUrl(targetUrl), 
                                              targetWindow);
           } catch (MalformedURLException e1) {
              // Log it to the browser's java console:
              System.err.println(e1.getMessage());
           }
//        }
    }

    protected String getDocumentRootUrlString() {
        URL baseUrl = getDocumentBase();
        return baseUrl.getProtocol() + "://" + baseUrl.getHost() + ":" +
            baseUrl.getPort() + "/anita/";
    }

    protected URL getDocumentRootUrl(String pathFromDocumentRoot)
        throws MalformedURLException {
        return new URL(getDocumentRootUrlString() + pathFromDocumentRoot);
    }





    public static final int DISCONNECT = 0;
    public static final int HANDLER_UPDATE = 1;
    public static final int CONTEXT_OPERATION = 2;
    public static final int CONTEXT_SET = 3;
    public static final int VANILLA_NOTIFY = 4;

    private class Ear extends Thread {

        private Socket socket; // Socket to remote host.

        private ObjectInputStream incoming;

        private ObjectOutputStream outgoing;

        /**
         * Constructor for basic AEP Ear threads.
         */
        public Ear() throws IOException {
            super();
        }

        /**
         * Thread.run() override.
         */
        public void run() {
            try {
                socket = new Socket(host, port);
                OutputStream outputStream = socket.getOutputStream();
                outgoing = new ObjectOutputStream(outputStream);
                outgoing.flush();
                outputStream.flush();
                InputStream inputStream = socket.getInputStream();
                incoming = new ObjectInputStream(inputStream);

                // First we tell the applet who we are
                outgoing.writeLong(participantId);
                outgoing.flush();
                outputStream.flush();
                //Next, tell them if we have a dimension, and if so, what it is
                outgoing.writeBoolean(dimension != null);
                if (dimension != null) {
                    outgoing.writeObject(dimension);
                }
                // The main ParticipantApplet response loop
                while (true) {
		    commandLogFrame.append("Waiting to read a command int...\n");
                    int command = incoming.readInt();
		    commandLogFrame.append("Read a command int: " + command + "\n");
                    switch (command) {
                    case DISCONNECT:
		        commandLogFrame.append("Got a disconnect...\n");
                        socket.close();
                        socket = null;
//                        disconnectNotify();
                        return;
                    case CONTEXT_OPERATION:
		        commandLogFrame.append("Got a context op...\n");
                        String dimension = null;
                        boolean dimNotNull = incoming.readBoolean();
                        if (dimNotNull) {
                            dimension = (String)incoming.readObject();
                        }
                        ContextOp operation = new ContextOp();
                        operation.deserialize(incoming);
                        commandLogFrame.append(
                              "applet.run():\nIncoming contextOp : " + 
                              operation.canonical() + 
                              "\nfor participant id " + participantId + "\n"
                        );
                        updateTargetWindow();
                        break;
                    case CONTEXT_SET:
		    commandLogFrame.append("Got a context set...\n");
                        dimension = null;
                        dimNotNull = incoming.readBoolean();
                        if (dimNotNull) {
                            dimension = (String)incoming.readObject();
                        }
                        Context context = new Context();
                        context.deserialize(incoming);
                        break;
                    case VANILLA_NOTIFY:
		    commandLogFrame.append("Got a vanilla notify...\n");
                        dimension = null;
                        dimNotNull = incoming.readBoolean();
                        if (dimNotNull) {
                            dimension = (String)incoming.readObject();
                        }
                        break;
                    }
                }
            } catch (Exception e) {
		commandLogFrame.append("Caught an exception...Here\n");
                // asumming that if there is a problem, the applet it not a 
                // participant anymore.
                disconnect();
                setVisible(false);
		System.out.println("Caught an exception...Disconnecting applet\n"); 
            }
        }
  }

    protected void disconnect() {
        try {
            ear.socket.close();
        } catch (IOException e) {
            System.err.println("ParticipantApplet.disconnect():\n" +
                               "Exception while closing ear socket:\n" +
                               e.getMessage());
        }
    }


}
