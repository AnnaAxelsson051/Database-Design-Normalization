package se.iths;

//testing database queries
import org.junit.jupiter.api.*;

import java.sql.*;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class AppTest {
    private static final String JDBC_CONNECTION = "jdbc:mysql://localhost:3306/iths";
    private static final String JDBC_USER = "iths";
    private static final String JDBC_PASSWORD = "iths";
    private static final String TEST_USER ="Kalle Anka";
    private static final String TEST_ROLE ="Admin";
    private static final String TEST_NEWROLE ="User";
    private static long actualIdAfterInsert;

    public static Connection con = null;
    @BeforeAll
    //To be executed first, sets up database
    public static void setUp() throws Exception {
        con = DriverManager.getConnection(JDBC_CONNECTION,JDBC_USER,JDBC_PASSWORD);
        con.createStatement().execute("DROP TABLE IF EXISTS User ");    //create table user
        con.createStatement().execute("CREATE TABLE User (ID INT NOT NULL AUTO_INCREMENT, NAME VARCHAR(255), ROLE VARCHAR(255), PRIMARY KEY (ID))");
    }

    @AfterAll
    public static void tearDown() throws Exception{   //To be executed last, closes connection
        con.close();
    }

    @Order(1)
    //executes first after first method
    @Test
    void shouldCreateRowInDatabase() throws Exception{
        PreparedStatement stmt = con.prepareStatement("INSERT INTO User (NAME, ROLE) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
        stmt.setString(1, TEST_USER);    //inserts kalle anka
        stmt.setString(2, TEST_ROLE);    //inserts admin
        stmt.execute();
        ResultSet rs = stmt.getGeneratedKeys();
        assertTrue(rs.next(), "Should have a row with generated id!");  //check if the user now exists in database
        final long expectedIdAfterInsert = 1L;               //actual id user should have
        actualIdAfterInsert = rs.getLong(1);     //read id from database
        //compare so user has correct id:
        assertEquals(expectedIdAfterInsert, actualIdAfterInsert, "Should have correct id after insert!");

    }

    @Order(3)      //executes third after first method, ska den va 2?
    @Test
    void shouldFindRowInDatabase() throws Exception {
        PreparedStatement stmt = con.prepareStatement("SELECT Id, Name, Role FROM User WHERE Id = ?");
        stmt.setLong(1, actualIdAfterInsert);   //find the row we created
        ResultSet rs = stmt.executeQuery();
        assertTrue(rs.next(), "Should find one row!");  //get row
        //check så that id, name and role in database matches what we sent in:
        assertEquals(actualIdAfterInsert, rs.getLong("Id"), "Selected Id should match");
        assertTrue(TEST_USER.equalsIgnoreCase(rs.getString("Name")), "Selected user should match");
        assertTrue(TEST_ROLE.equalsIgnoreCase(rs.getString("Role")), "Selected role should match");
        rs.close();
        stmt.close();   //varför stänga här men inta på andra ställen?
    }

    @Order(4)
    @Test
    void shouldUpdateRowInDatabase() throws Exception {
        PreparedStatement stmt = con.prepareStatement("UPDATE User Set ROLE = ? WHERE ID = ?");
        stmt.setString(1, TEST_NEWROLE);         //updates role on id 1 to "User"
        stmt.setLong(2, actualIdAfterInsert);    //updates id to ?
        stmt.execute();

        stmt = con.prepareStatement("SELECT Role FROM User WHERE Id = ?");
        stmt.setLong(1, actualIdAfterInsert);   //select role where Id = 1
        ResultSet rs = stmt.executeQuery();
        assertTrue(rs.next(), "Should find one row!");
        //test so that role is "User":
        assertTrue(TEST_NEWROLE.equalsIgnoreCase(rs.getString("Role")), "Updated role should match");
    }

    @Order(5)
    @Test
    void shouldDeleteRowInDatabase() throws Exception {
        PreparedStatement pstmt = con.prepareStatement("DELETE FROM User WHERE Id = ?");  //removes user
        pstmt.setLong(1, actualIdAfterInsert); //removes user with that id
        pstmt.execute();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT count(*) FROM User");
        assertTrue(rs.next(), "Should find one row with count!"); //i felloggen vid misslyckande
        assertEquals(0, rs.getInt(1), "Table should be emtpty");
    }
}
