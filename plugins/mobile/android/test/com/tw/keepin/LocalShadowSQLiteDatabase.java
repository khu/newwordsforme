package com.tw.keepin;

import android.content.ContentValues;
import android.database.sqlite.SQLiteDatabase;
import com.xtremelabs.robolectric.internal.Implementation;
import com.xtremelabs.robolectric.internal.Implements;
import com.xtremelabs.robolectric.shadows.ShadowSQLiteDatabase;
import com.xtremelabs.robolectric.util.SQLite;

import java.lang.reflect.Field;
import java.sql.*;
import java.util.Iterator;

import static com.xtremelabs.robolectric.Robolectric.newInstanceOf;
import static com.xtremelabs.robolectric.util.SQLite.buildInsertString;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 8/2/11
 * Time: 9:28 AM
 * To change this template use File | Settings | File Templates.
 */
@Implements(SQLiteDatabase.class)
public class LocalShadowSQLiteDatabase extends ShadowSQLiteDatabase{
    protected static Connection connection;
    
    // Specify the SQLite JDBC driver
    @Implementation
    public static SQLiteDatabase openDatabase(String path, SQLiteDatabase.CursorFactory factory, int flags) {
        try {

        Class.forName("org.sqlite.JDBC");
            final Field f = ShadowSQLiteDatabase.class.getDeclaredField("connection");
            f.setAccessible(true);
            connection = DriverManager.getConnection("jdbc:sqlite:test.db");
            f.set(null, connection);
            System.out.println("DB opened");
        } catch (Exception e) {
            throw new RuntimeException("SQL exception in openDatabase", e);
        }
        return newInstanceOf(SQLiteDatabase.class);
    }


    @Implementation
    public long insert(String table, String nullColumnHack, ContentValues values) {
        SQLite.SQLStringAndBindings sqlInsertString = buildInsertString(table, values);
        try {
            PreparedStatement statement = connection.prepareStatement(sqlInsertString.sql, Statement.RETURN_GENERATED_KEYS);
            Iterator<Object> columns = sqlInsertString.columnValues.iterator();
            int i = 1;
            while (columns.hasNext()) {
                statement.setObject(i++, columns.next());
            }

            statement.executeUpdate();

            ResultSet resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getLong(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("SQL exception in insert", e);
        }
        return -1;
    }


    // Bypass ShadowSQLiteDatabase.execSQL auto_increment hack
    @Implementation
    public void execSQL(String sql) throws android.database.SQLException {
        if (!isOpen()) {
            throw new IllegalStateException("database not open");
        }

        try {
            connection.createStatement().execute(sql);
        } catch (java.sql.SQLException e) {
            android.database.SQLException ase = new android.database.SQLException();
            ase.initCause(e);
            throw ase;
        }
    }
}
