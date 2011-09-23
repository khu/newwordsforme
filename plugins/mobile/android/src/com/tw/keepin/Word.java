package com.tw.keepin;

import android.provider.BaseColumns;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.util.Date;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 7/27/11
 * Time: 4:42 PM
 */
public final class Word implements BaseColumns {

    public static final String ENGLISH = "english";
    public static final String CHINESE = "chinese";
    public static final String CREATED_DATE = "created_date";
    public static final String MODIFIED_DATE = "modified_date";
    public static final String TABLE_NAME = "word";
    public static final String CONTENT_URI = "com.tw.keepin/words";
//@DatabaseTable(tableName = "words")
//public final class Word {
    @DatabaseField(id = true)
    public int id;
    @DatabaseField
    public String english;// = "english";
    @DatabaseField
    public  String translation;// = "chinese";
    @DatabaseField
    public Date created_date;// = "created_date";
    @DatabaseField
    public  Date update_date;// = "modified_date";
    //spublic static final String DEFAULT_SORT_ORDER = _ID + " DESC";
    public Word(){
        english = "";
        translation = "";
    };
}
