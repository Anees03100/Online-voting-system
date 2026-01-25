package votingtestlogic.test;

import org.junit.Test;
import static org.junit.Assert.*;
import com.voting.VotingLogic;
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import java.util.Arrays;

public class VotingLogicTest {
    VotingLogic logic = new VotingLogic();

    public static void main(String[] args) {
        Result r = JUnitCore.runClasses(VotingLogicTest.class);
        System.out.println("\n--- 10 POINT TEST REPORT ---");
        r.getFailures().forEach(f -> System.out.println("FAIL: " + f.toString()));
        System.out.println("SUCCESS: " + r.wasSuccessful() + " (" + r.getRunCount() + " tests)");
    }

    @Test public void test1_ValidName() { assertTrue(logic.isValidName("John Doe")); }
    
    @Test public void test2_ValidEmail() { assertTrue(logic.isValidEmail("vote@app.com")); }
    
    @Test public void test3_StrongPassword() { assertTrue(logic.isStrongPassword("Pass12345")); }
    
    @Test public void test4_AgeRequirement() { assertTrue(logic.isOldEnough(19)); }
    
    @Test public void test5_AdminRole() { assertTrue(logic.isAdmin("ADMIN")); }
    
    @Test public void test6_ElectionDates() { assertTrue(logic.isDateRangeValid("2026-01-01", "2026-01-05")); }
    
    @Test public void test7_ElectionStatus() { assertEquals("UPCOMING", logic.getStatus("2026-12-01", "2026-12-10")); }
    
    @Test public void test8_CandidateLimit() { assertTrue(logic.isLimitReached(10)); }
    
    @Test public void test9_DuplicateCandidate() { assertTrue(logic.isDuplicate(Arrays.asList("Alice", "Bob"), "alice")); }
    
    @Test public void test10_DoubleVoting() { assertFalse("Should not vote twice", logic.canVote(true, "ACTIVE")); }
}