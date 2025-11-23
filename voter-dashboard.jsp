<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voter Dashboard - Online Voting System</title>
    <link href="styles/dashboard.css" rel="stylesheet">
    <link href="https://resource.trickle.so/vendor_lib/unpkg/lucide-static@0.516.0/font/lucide.css" rel="stylesheet">
</head>
<body>

<%
    // ** JSP Backend Logic: Check Session and Get User Email **
    String voterEmail = (String) session.getAttribute("voterEmail");
    
    // If the session attribute is missing, redirect to login.
    if (voterEmail == null) {
        response.sendRedirect("login.html"); // Redirect to your main login page
        return; // Stop processing the rest of the page
    }
    
    // Use the email as the displayed name for now.
    String userName = voterEmail; 
%>

    <nav class="navbar">
        <div class="container">
            <div class="logo">
                <div class="logo-icon">
                    <i class="icon-vote"></i>
                </div>
                <span>VoteSecure</span>
            </div>
            <a href="index.html" class="logout">Logout</a> 
        </div>
    </nav>

    <main class="main-content">
        <div class="container">
            <div class="welcome-banner">
                <div class="welcome-content">
                    <h2 id="welcomeMessage">Welcome back, <%= userName %>!</h2>
                    <p>Your voice matters. Participate in active elections below.</p>
                </div>
                <div class="quick-stats">
                    <div class="quick-stat-item">
                        <i class="icon-check-circle"></i>
                        <div>
                            <strong>0</strong>
                            <span>Votes Cast</span>
                        </div>
                    </div>
                    <div class="quick-stat-item">
                        <i class="icon-clock"></i>
                        <div>
                            <strong>3</strong>
                            <span>Available</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <h1 class="page-title">Available Elections</h1>
            
            <div id="electionsGrid" class="elections-grid">
                <div class="election-card">
                    <div class="election-header">
                        <h3>Presidential Election 2025</h3>
                        <span class="badge badge-active">Active</span>
                    </div>
                    <p class="election-date">
                        <i class="icon-calendar"></i>
                        November 15, 2025
                    </p>
                    <a href="vote.html" class="btn-vote">Cast Vote</a>
                </div>

                <div class="election-card">
                    <div class="election-header">
                        <h3>City Council Election</h3>
                        <span class="badge badge-active">Active</span>
                    </div>
                    <p class="election-date">
                        <i class="icon-calendar"></i>
                        October 28, 2025
                    </p>
                    <a href="vote.html" class="btn-vote">Cast Vote</a>
                </div>

                <div class="election-card">
                    <div class="election-header">
                        <h3>School Board Election</h3>
                        <span class="badge badge-upcoming">Upcoming</span>
                    </div>
                    <p class="election-date">
                        <i class="icon-calendar"></i>
                        December 5, 2025
                    </p>
                    <button class="btn-vote btn-disabled" disabled>Not Started</button>
                </div>
            </div>
        </div>
    </main>
    
 
</body>
</html>