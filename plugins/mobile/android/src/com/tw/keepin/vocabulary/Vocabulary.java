package com.tw.keepin.vocabulary;

import android.database.Cursor;
import android.util.Log;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

public class Vocabulary implements Iterable<WordItem> {
    public static HashMap<String, WordItem> CurrentWordIdCache = new HashMap<String, WordItem>();

    private ArrayList<WordItem> words = new ArrayList<WordItem>();
    private String tagName;

    public Vocabulary(Cursor cursor, String tagName) {
        this.tagName = tagName;
        if (cursor.moveToFirst()) {
            String en;
            String ch;
            int id;
            do {
                en = cursor.getString(cursor.getColumnIndex(com.tw.keepin.Word.ENGLISH));
                ch = cursor.getString(cursor.getColumnIndex(com.tw.keepin.Word.CHINESE));
                id = cursor.getInt(cursor.getColumnIndex(com.tw.keepin.Word._ID));
                words.add(new WordItem(en, ch, id));
            } while (cursor.moveToNext());
        }
        cursor.close();
    }

    public WordItem next(String english) {
        if (words.isEmpty()) {
            return WordItem.NULL;
        }
        int index = words.indexOf(new WordItem(english, ""));
        index = index == words.size() - 1 ? index : index + 1;

        WordItem wordItem = words.get(index);
        CurrentWordIdCache.put(this.tagName, wordItem);
        return wordItem;
    }

    public boolean isLast(String english) {
        if (words.isEmpty()) {
            return true;
        }
        int index = words.indexOf(new WordItem(english, ""));
        return index == (words.size() - 1);
    }

    public boolean isFirst(String english) {
        if (words.isEmpty())
            return true;
        int index = words.indexOf(new WordItem(english, ""));
        return index == 0;
    }

    public WordItem current(String english) {
        if (words.isEmpty())
            return WordItem.NULL;
        int index = words.indexOf(new WordItem(english, ""));

        return words.get(index);
    }

    public WordItem previous(String english) {
        if (words.isEmpty()) {
            return WordItem.NULL;
        }
        int index = words.indexOf(new WordItem(english, ""));
        index = index == 0 ? 0 : index - 1;

        WordItem wordItem = words.get(index);
        CurrentWordIdCache.put(this.tagName, wordItem);
        return wordItem;
    }

    public Iterator<WordItem> iterator() {
        return words.iterator();
    }

    public int size() {
        return words.size();
    }

    public static Vocabulary createInstance(Cursor cursor, String tagName) {
        return new Vocabulary(cursor, tagName);
    }

    public void add(WordItem word) {
        Log.i(">>>>", "add world (" + word.getEng() + "--" + word.getTranslation() + ")");
        word.addTo(this.words);
    }

    public WordItem firstToShow() {
        if (words.isEmpty()) {
            return WordItem.NULL;
        }

        WordItem wordItem = CurrentWordIdCache.get(this.tagName);
        if (this.tagName.equalsIgnoreCase("All") && wordItem != null) {
            return wordItem;
        }

        return words.get(0);
    }
}
