package com.tw.keepin;

import android.content.Context;
import android.database.Cursor;
import android.provider.BaseColumns;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 7/28/11
 * Time: 12:11 AM
 */
public final class Tag implements BaseColumns {
    public static final String TABLE_NAME = "Tag";
    public static final String NAME = "NAME";
    public static final String DEFAULT_SORT_ORDER = _ID + " DESC";

    public static final String All_TAG_CONTENT_URI = "com.tw.keepin/tags";
    public static final String ALL_WORD_BY_TAG_CONTENT_URI = "com.tw.keepin.tag/words";
    public static final int NOT_EXIST_TAG_ID = -1;

    public static int getTagId(Context context, String tagName)
    {
        Cursor cursor = context.getContentResolver().query(KeepinContentProvider.TAG_URI,
                new String[]{Tag._ID}, Tag.NAME + "=?",
                new String[]{tagName}, null);
        if (!cursor.moveToFirst())
        {
             return NOT_EXIST_TAG_ID;
        }

        int id = cursor.getInt(cursor.getColumnIndex(Tag._ID));
        cursor.close();
        return id;
    }
}
