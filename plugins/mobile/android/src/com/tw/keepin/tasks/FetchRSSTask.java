package com.tw.keepin.tasks;

import android.app.ProgressDialog;
import android.content.*;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import com.tw.keepin.BrowsingWordsActivity;
import com.tw.keepin.KeepinContentProvider;
import com.tw.keepin.Tag;
import com.tw.keepin.Word;
import com.tw.keepin.tasks.util.ConfigurationParamters;
import com.tw.keepin.tasks.util.KeepInHttpServer;
import com.tw.keepin.tasks.util.RSSUtilsParser;
import com.tw.keepin.vocabulary.WordItem;
import com.tw.keepin.vocabulary.WordTagRelationship;

import java.io.InputStream;
import java.util.Date;
import java.util.List;


public class FetchRSSTask extends AsyncTask<Void, Void, Void> {
    private KeepInHttpServer keepInHttpServer;
    private Context context;
    private String userId;
    private static final String KEEPIN = ConfigurationParamters.KEEPIN_PERF_NAME;
    private long tag_all_id = -1;
    private ProgressDialog progressDialog;
    private boolean needProgressDialog;
    private String dateStr;

    public FetchRSSTask(Context context, boolean needProgressDialog) {
        keepInHttpServer = KeepInHttpServer.getInstance();
        this.context = context;
        this.userId = context.getSharedPreferences(KEEPIN, Context.MODE_PRIVATE).getString(ConfigurationParamters.USER_ID_ATTR,
                ConfigurationParamters.DEFAULT_USER_ID);
        this.dateStr = context.getSharedPreferences(KEEPIN, Context.MODE_PRIVATE).getString(ConfigurationParamters.LAST_REQUEST_DATE_ATTR,
                ConfigurationParamters.DEFAULT_LAST_REQUEST_DATE);
        this.needProgressDialog = needProgressDialog;
        if (needProgressDialog) {
            progressDialog = new ProgressDialog(this.context);
            progressDialog.setMessage("Fetching words...");
        }
    }

    private List<WordItem> fetchWordsOfUser(String userId) {

        List<WordItem> result = null;
        try {
            InputStream stream = keepInHttpServer.getRSSStream(userId, dateStr);

            RSSUtilsParser parser = new RSSUtilsParser();
            result = parser.parseRSS(stream);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private void pushWordsToContent(List<WordItem> words) {
        if (words == null || words.size() == 0) {
            return;
        }

        tag_all_id = Tag.getTagId(context, "all");

        for (WordItem word : words) {
            saveWordAndTags(word);
        }

        SharedPreferences.Editor editor = context.getSharedPreferences(
                ConfigurationParamters.KEEPIN_PERF_NAME,
                Context.MODE_PRIVATE).edit();
        editor.putString(ConfigurationParamters.LAST_REQUEST_DATE_ATTR,
                new Date().toGMTString());
        editor.commit();
    }

    private void saveWordAndTags(WordItem wordItem) {
        long word_id = saveWord(wordItem);
        saveWordTag(word_id, tag_all_id);

        for (String tag : wordItem.getTags()) {
            long tag_id = Tag.getTagId(context, tag);
            if (tag_id == Tag.NOT_EXIST_TAG_ID) {
                tag_id = saveTag(tag);
            }
            saveWordTag(word_id, tag_id);
        }
    }

    private long saveTag(String tagName) {
        ContentValues values = new ContentValues();
        values.put(Tag.NAME, tagName);

        Uri uri = context.getContentResolver().insert(KeepinContentProvider.TAG_URI, values);
        return ContentUris.parseId(uri);
    }

    private long saveWord(WordItem word) {
        ContentValues contentValues = new ContentValues();
        if (hasWordInDb(word)) {
            contentValues.put(Word.MODIFIED_DATE, word.getUpdate_date().toGMTString());
            context.getContentResolver().update(KeepinContentProvider.WORD_URI, contentValues,
                    Word._ID + "=?", new String[]{"" + word.getId()});
            context.getContentResolver().delete(KeepinContentProvider.WORD_TAG_RELATION_URI,
                    WordTagRelationship.WORD_ID + "=?", new String[]{"" + word.getId()});
            return word.getId();
        } else {
            contentValues.put(Word._ID, word.getId());
            contentValues.put(Word.ENGLISH, word.getEng());
            contentValues.put(Word.CHINESE, word.getTranslation());
            contentValues.put(Word.MODIFIED_DATE, word.getUpdate_date().toGMTString());
            Uri wordUri = context.getContentResolver().insert(KeepinContentProvider.WORD_URI, contentValues);
            return ContentUris.parseId(wordUri);
        }
    }

    private boolean hasWordInDb(WordItem wordItem) {
        Cursor cursor = context.getContentResolver().query(KeepinContentProvider.WORD_URI, new String[]{Word._ID},
                Word._ID + "=?", new String[]{"" + wordItem.getId()}, null);

        boolean hasRecord = cursor.moveToFirst();
        cursor.close();
        return hasRecord;
    }

    private boolean hasWordTagRelation(long wordId, long tagId) {
        Cursor cursor = context.getContentResolver().query(KeepinContentProvider.WORD_TAG_RELATION_URI, new String[]{WordTagRelationship._ID},
                WordTagRelationship.TAG_ID + "=? and " + WordTagRelationship.WORD_ID + "=?", new String[]{"" + tagId, "" + wordId}, null);
        boolean hasRecord = cursor.moveToFirst();
        cursor.close();
        return hasRecord;
    }

    private void saveWordTag(long word_id, long tag_id) {
        if (hasWordTagRelation(word_id, tag_id)) {
            return;
        }
        ContentValues contentValues = new ContentValues();
        contentValues.put(WordTagRelationship.TAG_ID, tag_id);
        contentValues.put(WordTagRelationship.WORD_ID, word_id);
        context.getContentResolver().insert(KeepinContentProvider.WORD_TAG_RELATION_URI, contentValues);

    }

    @Override
    protected Void doInBackground(Void... voids) {
        pushWordsToContent(fetchWordsOfUser(this.userId));
        return null;
    }

    @Override
    protected void onPreExecute() {
        if (needProgressDialog) {
            progressDialog.show();
        }
    }

    @Override
    protected void onPostExecute(Void aVoid) {
        if (needProgressDialog) {
            progressDialog.dismiss();

            BrowsingWordsActivity browsingWordsActivity = (BrowsingWordsActivity) this.context;
            browsingWordsActivity.updateWordsView("All");

        }
    }
}



