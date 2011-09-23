package com.tw.keepin;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.sql.*;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 8/2/11
 * Time: 9:02 AM
 * To change this template use File | Settings | File Templates.
 */
public class JDBCLibraryTest {
    private Connection conn;
    private Statement stat;

    @Before
    public void setUp() throws Exception {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:test.db");
        stat = conn.createStatement();
    }

    @Test
    public void testInsert() throws Exception {
        stat.executeUpdate("drop table if exists people;");
        stat.executeUpdate("create table people (name, occupation);");
        PreparedStatement prep = conn.prepareStatement(
                "insert into people values (?, ?);");

        prep.setString(1, "Gandhi");
        prep.setString(2, "politics");
        prep.addBatch();
        prep.setString(1, "Turing");
        prep.setString(2, "computers");
        prep.addBatch();
        prep.setString(1, "Wittgenstein");
        prep.setString(2, "smartypants");
        prep.addBatch();

        conn.setAutoCommit(false);
        prep.executeBatch();
        conn.setAutoCommit(true);
    }

    @Test
    public void testQuery() throws Exception {

        ResultSet rs = stat.executeQuery("select * from people;");

        System.out.println("Query");
        while (rs.next())

        {
            System.out.println("name = " + rs.getString("name"));
            System.out.println("job = " + rs.getString("occupation"));
        }
        rs.close();

    }

    @After
    public void tearDown() throws Exception {
        conn.close();
    }

}
