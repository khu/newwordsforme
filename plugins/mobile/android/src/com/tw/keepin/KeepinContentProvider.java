package com.tw.keepin;

import android.content.ContentProvider;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.UriMatcher;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteQueryBuilder;
import android.net.Uri;
import com.tw.keepin.vocabulary.WordTagRelationship;

import java.util.HashMap;

public class KeepinContentProvider extends ContentProvider {
    public static final String AUTHORITY = "com.tw.provider.Keepin";
    public static final Uri TAG_URI = Uri.parse("content://" + AUTHORITY + "/tags");
    public static final Uri TAG_WORD_URI = Uri.parse("content://" + AUTHORITY + "/words/tag");
    public static final Uri WORD_URI = Uri.parse("content://" + AUTHORITY + "/words");
    public static final Uri WORD_TAG_RELATION_URI = Uri.parse("content://" + AUTHORITY + "/word_tag_relationship");

    private static final int TAGS = 1;
    private static final int WORDS = 2;
    private static final int TAG_WORD = 3;
    private static final int WORD_TAG_RELATIONSHIP = 4;
    private static final int TAG_ITEM = 5;

    private DatabaseHelper dbHelper = null;
    private static final UriMatcher sUriMatcher;
    private static HashMap<Integer, String> sUriTypeMap;
    private static HashMap<Integer, String> sUriTableNameMap;

    static {
        sUriMatcher = new UriMatcher(UriMatcher.NO_MATCH);
        sUriMatcher.addURI(AUTHORITY, "tags", TAGS);
        sUriMatcher.addURI(AUTHORITY, "tags/#", TAG_ITEM);
        sUriMatcher.addURI(AUTHORITY, "words/tag/#", TAG_WORD);
        sUriMatcher.addURI(AUTHORITY, "words", WORDS);
        sUriMatcher.addURI(AUTHORITY, "word_tag_relationship", WORD_TAG_RELATIONSHIP);

        sUriTypeMap = new HashMap<Integer, String>();
        sUriTypeMap.put(TAGS, Tag.All_TAG_CONTENT_URI);
        sUriTypeMap.put(TAG_WORD, Tag.ALL_WORD_BY_TAG_CONTENT_URI);
        sUriTypeMap.put(WORDS, Word.CONTENT_URI);
        sUriTypeMap.put(WORD_TAG_RELATIONSHIP, WordTagRelationship.CONTENT_URI);
        sUriTypeMap.put(TAG_ITEM, WordTagRelationship.CONTENT_URI);

        sUriTableNameMap = new HashMap<Integer, String>();
        sUriTableNameMap.put(TAGS, Tag.TABLE_NAME);
        sUriTableNameMap.put(TAG_WORD, Word.TABLE_NAME + " w, " + WordTagRelationship.TABLE_NAME + " r ");
        sUriTableNameMap.put(WORDS, Word.TABLE_NAME);
        sUriTableNameMap.put(WORD_TAG_RELATIONSHIP, WordTagRelationship.TABLE_NAME);
        sUriTableNameMap.put(TAG_ITEM, WordTagRelationship.TABLE_NAME);
    }

    @Override
    public boolean onCreate() {
        dbHelper = new DatabaseHelper(getContext());
        return true;
    }

    @Override
    public Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder) {
        SQLiteQueryBuilder sqb = new SQLiteQueryBuilder();
        sqb.setTables(getTableNameByUri(uri));
        SQLiteDatabase db = dbHelper.getReadableDatabase();
        Cursor c = sqb.query(db, projection, selection, selectionArgs, null, null, sortOrder);
        c.setNotificationUri(getContext().getContentResolver(), uri);
        return c;
    }

    private String getTableNameByUri(Uri uri) {
        if (sUriMatcher.match(uri) < 0) {
            throw new IllegalArgumentException("Unknown URI " + uri);
        }

        return sUriTableNameMap.get(sUriMatcher.match(uri));
    }

    @Override
    public String getType(Uri uri) {
        if (sUriMatcher.match(uri) < 0) {
            throw new IllegalArgumentException("Unknown URI " + uri);
        }

        return sUriTypeMap.get(sUriMatcher.match(uri));
    }

    @Override
    public Uri insert(Uri uri, ContentValues initialValues) {
        if (sUriMatcher.match(uri) < 0) {
            throw new IllegalArgumentException("unknown uri " + uri);
        }

        ContentValues values;
        if (initialValues != null) {
            values = new ContentValues(initialValues);
        } else {
            values = new ContentValues();
        }

        SQLiteDatabase db = dbHelper.getWritableDatabase();

        // TODO : need to refactor
        long rowId = db.insertWithOnConflict(getTableNameByUri(uri), null, values, SQLiteDatabase.CONFLICT_IGNORE);

        Uri tagUri = null;
        if (rowId >= 0) {
            tagUri = ContentUris.withAppendedId(uri, rowId);
            getContext().getContentResolver().notifyChange(tagUri, null);
        }
        return tagUri;
    }

    @Override
    public int delete(Uri uri, String whereClause, String[] whereArgs) {
        if (sUriMatcher.match(uri) < 0) {
            throw new IllegalArgumentException("unknown uri " + uri);
        }

        SQLiteDatabase db = dbHelper.getWritableDatabase();
        return db.delete(getTableNameByUri(uri), whereClause, whereArgs);
    }

    @Override
    public int update(Uri uri, ContentValues contentValues, String s, String[] strings) {
        if (sUriMatcher.match(uri) < 0) {
            throw new IllegalArgumentException("unknown uri " + uri);
        }

        SQLiteDatabase db = dbHelper.getWritableDatabase();
        return db.update(getTableNameByUri(uri), contentValues, s, strings);
    }
}
