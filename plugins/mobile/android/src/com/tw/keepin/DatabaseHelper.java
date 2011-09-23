package com.tw.keepin;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;
import com.tw.keepin.vocabulary.WordTagRelationship;

public class DatabaseHelper extends SQLiteOpenHelper {
    private static final String DATABASE_NAME = "keepin.db";
    private static final int DATABASE_VERSION = 2;
    private static final String TAG = "DatabaseHelper";

    protected DatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    public DatabaseHelper(Context context, String name, SQLiteDatabase.CursorFactory factory, int version) {
        super(context, name, factory, version);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE " + Word.TABLE_NAME + " ("
                + Word._ID + " INTEGER PRIMARY KEY,"
                + Word.ENGLISH + " TEXT,"
                + Word.CHINESE + " TEXT,"
                + Word.CREATED_DATE + " INTEGER,"
                + Word.MODIFIED_DATE + " INTEGER"
                + ");");

        db.execSQL("CREATE TABLE " + Tag.TABLE_NAME + " (" +
                Tag._ID + " INTEGER PRIMARY KEY," +
                Tag.NAME + " TEXT unique)" +
                ";");

        db.execSQL("CREATE TABLE " + WordTagRelationship.TABLE_NAME +
                " (" + WordTagRelationship._ID + " INTEGER PRIMARY KEY, " +
                WordTagRelationship.WORD_ID + " INTEGER, " +
                WordTagRelationship.TAG_ID + " INTEGER);");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        Log.w(TAG, "Upgrading database from version " + oldVersion + " to "
                + newVersion + ", which will destroy all old data");
        db.execSQL("DROP TABLE IF EXISTS " + Tag.TABLE_NAME);
        db.execSQL("DROP TABLE IF EXISTS " + Word.TABLE_NAME);
        db.execSQL("DROP TABLE IF EXISTS " + WordTagRelationship.TABLE_NAME);
        onCreate(db);
    }
}

