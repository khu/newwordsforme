package com.tw.keepin.vocabulary;

import android.provider.BaseColumns;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 8/2/11
 * Time: 11:09 AM
 */
public class WordTagRelationship implements BaseColumns {

    public static final String TABLE_NAME = "WORD_TAG_RELATIONSHIP";
    public static final String WORD_ID = "WORD_ID";
    public static final String TAG_ID = "TAG_ID";
    public static final String CONTENT_URI = "com.tw.keepin/relationship";
}
