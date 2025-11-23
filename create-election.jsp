<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    // Ensure request encoding for form data
    request.setCharacterEncoding("UTF-8");

    String title = request.getParameter("title");
    String description = request.getParameter("description");
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");

    // Simple server-side validation
    if (title == null || title.trim().isEmpty() ||
        description == null || description.trim().isEmpty() ||
        startDate == null || startDate.trim().isEmpty() ||
        endDate == null || endDate.trim().isEmpty()) {

        out.println("<script>alert('All fields are required.'); window.location='create-election.html';</script>");
        return;
    }

    // DB connection info — change user/password if you use one
    String jdbcUrl = "jdbc:mysql://localhost:3306/admin_portal?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC";
    String dbUser = "root";
    String dbPass = ""; // change if you set a password

    // Use com.mysql.cj.jdbc.Driver for Connector/J 8+
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
    } catch (ClassNotFoundException cnfe) {
        out.println("<h3>JDBC Driver not found: " + cnfe.getMessage() + "</h3>");
        out.println("<p>Make sure mysql-connector-java-*.jar is in WEB-INF/lib or Tomcat's lib folder.</p>");
        return;
    }

    String insertSQL = "INSERT INTO elections (title, description, start_date, end_date) VALUES (?, ?, ?, ?)";

    try (
        Connection con = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);
        PreparedStatement ps = con.prepareStatement(insertSQL);
    ) {
        ps.setString(1, title);
        ps.setString(2, description);
        ps.setDate(3, java.sql.Date.valueOf(startDate)); // expects 'yyyy-MM-dd'
        ps.setDate(4, java.sql.Date.valueOf(endDate));

        int affected = ps.executeUpdate();
        if (affected > 0) {
            // success: redirect to dashboard or show success message
            response.sendRedirect("admin-dashboard.jsp");
        } else {
            out.println("<script>alert('Failed to create election.'); window.location='create-election.html';</script>");
        }
    } catch (SQLException sqle) {
        // helpful debug info while developing
        out.println("<h3>Database error:</h3>");
        out.println("<pre>" + sqle.getMessage() + "</pre>");
        // Optionally show stack trace:
        sqle.printStackTrace(new java.io.PrintWriter(out));
    } catch (IllegalArgumentException iae) {
        out.println("<h3>Invalid date format. Use yyyy-MM-dd.</h3>");
    }
%>
