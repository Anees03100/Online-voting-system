package com.voting;

import java.time.LocalDate;
import java.util.List;

public class VotingLogic {

    // 1. Name Validation
    public boolean isValidName(String name) {
        return name != null && name.matches("^[A-Za-z\\s]{2,50}$");
    }

    // 2. Email Validation
    public boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    // 3. Password Strength
    public boolean isStrongPassword(String pass) {
        return pass != null && pass.length() >= 8 && pass.matches(".*\\d.*");
    }

    // 4. Age Check
    public boolean isOldEnough(int age) {
        return age >= 18 && age <= 120;
    }

    // 5. Admin Authorization
    public boolean isAdmin(String role) {
        return "ADMIN".equalsIgnoreCase(role);
    }

    // 6. Date Range Check
    public boolean isDateRangeValid(String start, String end) {
        try {
            return LocalDate.parse(end).isAfter(LocalDate.parse(start));
        } catch (Exception e) { return false; }
    }

    // 7. Election Status
    public String getStatus(String start, String end) {
        try {
            LocalDate s = LocalDate.parse(start), e = LocalDate.parse(end), t = LocalDate.now();
            if (t.isBefore(s)) return "UPCOMING";
            if (t.isAfter(e)) return "COMPLETED";
            return "ONGOING";
        } catch (Exception ex) { return "ERROR"; }
    }

    // 8. Candidate Limit
    public boolean isLimitReached(int count) {
        return count >= 10;
    }

    // 9. Duplicate Candidate Check
    public boolean isDuplicate(List<String> list, String name) {
        return list.stream().anyMatch(c -> c.equalsIgnoreCase(name));
    }

    // 10. Voting Eligibility (Double voting check)
    public boolean canVote(boolean hasVoted, String status) {
        return "ACTIVE".equalsIgnoreCase(status) && !hasVoted;
    }
}