<%@ page import="java.sql.*" %>
<%@ page import="dao.DBConnection" %>

<%
    // Get form data
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    if (email != null && password != null && !email.isEmpty() && !password.isEmpty()) {
        
        // Resource variables declared outside try block for proper closing in finally block
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            // Connect to database
            conn = DBConnection.getConnection();
            
            // NOTE: Using table 'voter_login' as requested in your existing code.
            String sql = "SELECT * FROM voter_login WHERE email = ? AND password = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {
                // ? SUCCESS: User details found (Login successful)
                session.setAttribute("voterEmail", email);
                response.sendRedirect("voter-dashboard.jsp");
            } else {
                // ? FAILURE: Invalid credentials (User not registered or wrong password)
                // --- ADDED REDIRECTION TO REGISTRATION PAGE ---
                out.println("<script>" + 
                            "alert('User Not registered. Redirecting to Registration.');" + 
                            "window.location='registration.jsp';" + // <-- NEW REDIRECTION TARGET
                            "</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('?? Database error occurred! Contact administrator.'); window.location='login.html';</script>");
        } finally {
            // Ensure resources are closed, even if an exception occurred
            try { if (rs != null) rs.close(); } catch (SQLException e) { /* ignore */ }
            try { if (ps != null) ps.close(); } catch (SQLException e) { /* ignore */ }
            try { if (conn != null) conn.close(); } catch (SQLException e) { /* ignore */ }
        }
    } else {
        out.println("<script>alert('?? Please enter both email and password.'); window.location='login.html';</script>");
    }
%>
