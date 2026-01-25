<%@ page import="java.io.*, java.net.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userMessage = request.getParameter("message");
    String botResponse = "";

    // Process if message is sent via text box OR button click
    if (userMessage != null && !userMessage.trim().isEmpty()) {
        try (Socket socket = new Socket("localhost", 5005);
             PrintWriter outSocket = new PrintWriter(socket.getOutputStream(), true);
             BufferedReader inSocket = new BufferedReader(new InputStreamReader(socket.getInputStream()))) {

            outSocket.println(userMessage);
            botResponse = inSocket.readLine();
            
        } catch (Exception e) {
            botResponse = "Error: Bot server is offline. Please start ChatServer.java.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>VoteBot</title>
    <style>
        /* Embed your chatbot.css content here */
        <%= new String(java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(getServletContext().getRealPath("/styles/chatbot.css")))) %>
    </style>
</head>
<body>
     <nav class="navbar">
        <div class="container">
            <a href="index.jsp" class="logo">
                <div class="logo-icon"><i class="icon-vote"></i></div>
                <span>VoteSecure</span>
            </a>
            <div class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="about.jsp">About</a>
                <a href="faq.jsp">FAQ</a>
                <a href="chatbot.jsp">Chatbot</a>
                <a href="contact.jsp">Contact</a>
            </div>
        </div>
    </nav>
    <div class="chat-main">
        <div class="chat-messages" id="chatMessages">
            <% if (userMessage == null) { %>
                <div class="welcome-message">
                    <h2>How can I help you today?</h2>
                    <form action="chatbot.jsp" method="POST" class="suggestion-cards">
                        <button type="submit" name="message" value="How do I register?" class="suggestion-card">
                            <span>How do I register?</span>
                        </button>
                        <button type="submit" name="message" value="How do I vote?" class="suggestion-card">
                            <span>How do I vote?</span>
                        </button>
                        <button type="submit" name="message" value="Is it secure?" class="suggestion-card">
                            <span>Is it secure?</span>
                        </button>
                        <button type="submit" name="message" value="Active elections" class="suggestion-card">
                            <span>Active elections</span>
                        </button>
                    </form>
                </div>
            <% } else { %>
                <div class="message user"><div class="message-content"><%= userMessage %></div></div>
                <div class="message bot"><div class="message-content"><%= botResponse %></div></div>
                <div style="text-align:center; margin-top:20px;">
                    <a href="chatbot.jsp" style="color:var(--primary);">Ask another question</a>
                </div>
            <% } %>
        </div>

        <div class="chat-input-container">
            <form class="chat-input-form" method="POST" action="chatbot.jsp">
                <input type="text" name="message" placeholder="Type your question..." required>
                <button type="submit" class="btn-send">Send</button>
            </form>
        </div>
    </div>
</body>
</html>