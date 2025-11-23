<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%
    // Get form parameters
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // Basic validation
    if (username == null || username.trim().isEmpty() ||
        password == null || password.trim().isEmpty()) {
        out.println("<script>alert('Please enter both username and password!'); window.location='login-admin.html';</script>");
        return;
    }

    // JDBC setup
    String jdbcUrl = "jdbc:mysql://localhost:3306/admin_portal?useSSL=false&serverTimezone=UTC";
    String dbUser = "root";
    String dbPass = "";

    try {
        // Use correct MySQL driver for Connector/J 8+
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);

        // Check username and password in database
        String sql = "SELECT * FROM admin WHERE username = ? AND password = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, password);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            // ? Valid admin login
            session.setAttribute("adminUser", username);
            response.sendRedirect("admin-dashboard.jsp");
        } else {
            // ? Invalid login
            out.println("<script>alert('Invalid Username or Password!'); window.location='login-admin.html';</script>");
        }

        con.close();

    } catch (ClassNotFoundException e) {
        out.println("<h3>Error: MySQL JDBC Driver not found. Make sure `mysql-connector-java.jar` is in your Tomcat lib folder.</h3>");
    } catch (SQLException e) {
        out.println("<h3>Database Error: " + e.getMessage() + "</h3>");
    } catch (Exception e) {
        out.println("<h3>Unexpected Error: " + e.getMessage() + "</h3>");
    }
%>
