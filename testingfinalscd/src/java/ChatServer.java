import java.io.*;
import java.net.*;
import java.util.concurrent.*;

public class ChatServer {
    // Thread pool to handle 10 concurrent users at once
    private static ExecutorService threadPool = Executors.newFixedThreadPool(10);

    public static void main(String[] args) {
        try (ServerSocket serverSocket = new ServerSocket(5005)) {
            System.out.println("VoteSecure Chatbot Server started on port 5005...");

            while (true) {
                // Wait for a connection from chatbot.jsp
                Socket clientSocket = serverSocket.accept();
                
                // Multitasking: Handle each request in a separate thread
                threadPool.execute(new ClientHandler(clientSocket));
            }
        } catch (IOException e) {
            System.err.println("Server Error: " + e.getMessage());
        }
    }
}

class ClientHandler implements Runnable {
    private Socket socket;

    public ClientHandler(Socket socket) {
        this.socket = socket;
    }

    @Override
    public void run() {
        try (BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
             PrintWriter out = new PrintWriter(socket.getOutputStream(), true)) {
            
            String userMessage = in.readLine();
            // Simple logic to process messages asynchronously
            String response = processMessage(userMessage);
            out.println(response);
            
        } catch (IOException e) {
            System.err.println("Handler Error: " + e.getMessage());
        }
    }

    private String processMessage(String msg) {
        if (msg == null) return "Hello! How can I help?";
        msg = msg.toLowerCase();
        if (msg.contains("register")) return "Click 'Register as Voter' on the home page[cite: 132].";
        if (msg.contains("secure")) return "Yes, we use advanced encryption and SQL security[cite: 6, 135].";
        return "I'm not sure about that. Try contacting support@votesecure.com[cite: 140].";
    }
}