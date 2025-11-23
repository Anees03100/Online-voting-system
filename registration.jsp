<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="dao.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voter Registration - Online Voting System</title>
    <link href="styles/auth.css" rel="stylesheet">
    <link href="https://resource.trickle.so/vendor_lib/unpkg/lucide-static@0.516.0/font/lucide.css" rel="stylesheet">
</head>
<body>

<%
    // --- JSP Submission and Database Logic ---
    String method = request.getMethod();

    if ("POST".equalsIgnoreCase(method)) {
        // Retrieve parameters sent from the HTML form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String cnic = request.getParameter("cnic");
        String ageStr = request.getParameter("age");
        String password = request.getParameter("password");

        if (fullName != null && email != null && password != null && cnic != null && ageStr != null) {
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            
            try {
                int age = Integer.parseInt(ageStr);
                
                // 1. Establish connection to WAMP MySQL
                conn = DBConnection.getConnection();
                
                // 2. Check if email already exists (Prevents duplicate entries)
                String checkSql = "SELECT email FROM voter_registrations WHERE email = ?";
                ps = conn.prepareStatement(checkSql);
                ps.setString(1, email);
                rs = ps.executeQuery();
                
                if (rs.next()) {
                    // Email already registered
                    out.println("<script>alert('❌ This email is already registered. Please login!'); window.location='login.html';</script>");
                } else {
                    // 3. INSERT data into the WAMP SQL table (voter_registrations)
                    String insertSql = "INSERT INTO voter_registrations (fullName, email, cnic, age, password) VALUES (?, ?, ?, ?, ?)";
                    
                    if (ps != null) ps.close(); 
                    ps = conn.prepareStatement(insertSql);
                    ps.setString(1, fullName);
                    ps.setString(2, email);
                    ps.setString(3, cnic);
                    ps.setInt(4, age);
                    ps.setString(5, password);

                    // Execute the statement to save data
                    int rowsAffected = ps.executeUpdate();

                    if (rowsAffected > 0) {
                        // THIS LINE HANDLES REDIRECTION TO THE LOGIN PAGE
                        out.println("<script>alert('✅ Registration successful! Please log in.'); window.location='login-voter.html';</script>");
                    } else {
                        out.println("<script>alert('⚠️ Registration failed! Please try again.');</script>");
                    }
                }
            } catch (NumberFormatException e) {
                out.println("<script>alert('⚠️ Age must be a valid number.');</script>");
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<script>alert('⚠️ A database error occurred: Duplicate entry or server issue.');</script>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<script>alert('⚠️ An unexpected error occurred!');</script>");
            } finally {
                // Ensure all database resources are properly closed
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }
    }
%>

    <div class="auth-container">
        <div class="auth-card register-card">
            <a href="index.html" class="auth-logo">
                <div class="auth-logo-icon">
                    <i class="icon-user-plus"></i>
                </div>
                <span>VoterSecure</span>
            </a>
            <h2 class="auth-title">Voter Registration</h2>
            <p class="auth-subtitle">Create your account to participate in elections</p>
            
            <form class="auth-form" method="POST" action="registration.jsp" onsubmit="return validateRegisterForm();">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" id="fullName" name="fullName" placeholder="Enter your full name" minlength="3" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" id="email" name="email" placeholder="Enter your email" required>
                    </div>
                    
                    <div class="form-group">
                        <label>CNIC Number</label>
                        <input type="text" id="cnic" name="cnic" placeholder="xxxxx-xxxxxxx-x" pattern="[0-9]{5}-[0-9]{7}-[0-9]{1}" title="Format: xxxxx-xxxxxxx-x" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Age</label>
                        <input type="number" id="age" name="age" placeholder="Enter your age" min="18" max="120" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" id="password" name="password" placeholder="Create a password" minlength="6" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" minlength="6" required>
                    </div>
                </div>
                
                <button type="submit" class="btn-submit">Register</button>
            </form>
            
            <script>
                function validateRegisterForm() {
                    var password = document.getElementById('password').value;
                    var confirmPassword = document.getElementById('confirmPassword').value;
                    var age = document.getElementById('age').value;
                    var ageNum = parseInt(age);
                    
                    if (password !== confirmPassword) {
                        alert('Passwords do not match! Please try again.');
                        return false;
                    }
                    
                    if (password.length < 6) {
                        alert('Password must be at least 6 characters long!');
                        return false;
                    }
                    
                    if (isNaN(ageNum) || ageNum < 18) {
                        alert('You must be at least 18 years old to register!');
                        return false;
                    }

                    return true;
                }
            </script>
            
            <div class="auth-footer">
                <p>Already have an account? <a href="login.html">Login here</a></p> 
            </div>
        </div>
    </div>
</body>
</html>