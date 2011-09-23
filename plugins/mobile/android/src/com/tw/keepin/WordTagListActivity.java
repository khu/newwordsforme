package com.tw.keepin;

import android.app.ListActivity;
import android.app.Service;
import android.content.*;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.IBinder;
import android.view.View;
import android.widget.ListView;
import android.widget.SimpleCursorAdapter;
import android.widget.Toast;

public class WordTagListActivity extends ListActivity {

    private final static int REQUEST_FOR_WORDS = 1;
    public static final int WORDS_RESPONSE_CODE = 2;
    public static final String DEFAULT_VALUE = "-1";
    public static final String PROMPT_MESSAGE = "fetching words...";

    private SubscribeWordsFromKeepinService subscribeWordsFromKeepinService;
    private boolean subscribeServiceBound = false;
    private Cursor cursor;

    /**
     * Called when the activity is firstToShow created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        initialize();

        setDefaultKeyMode(DEFAULT_KEYS_SHORTCUT);
        Intent intent = getIntent();
        if (intent.getData() == null) {
            intent.setData(KeepinContentProvider.TAG_URI);
        }

        cursor = managedQuery(getIntent().getData(), new String[]{Tag._ID, Tag.NAME},
                null, null, Tag.DEFAULT_SORT_ORDER);
        SimpleCursorAdapter adapter = new SimpleCursorAdapter(this,
                R.layout.word_tag_list, cursor, new String[]{Tag.NAME}, new int[]{R.id.word_tag_list_id});
        setListAdapter(adapter);
        initTags();
    }

    private void initialize() {
        SharedPreferences settings = this.getSharedPreferences("KeepIn", Context.MODE_PRIVATE);
        final String userId = settings.getString("userid", DEFAULT_VALUE);

        if (isUserInitialized(userId)) {
            Toast.makeText(this.getApplicationContext(), PROMPT_MESSAGE, Toast.LENGTH_SHORT).show();
            doBindSubscribeService();
        } else {
            login();
        }
    }

    private boolean isUserInitialized(String userId) {
        return !userId.equals(DEFAULT_VALUE);
    }

    @Override
    protected void onListItemClick(ListView l, View v, int position, long id) {
        Uri uri = ContentUris.withAppendedId(KeepinContentProvider.TAG_WORD_URI, id);

        Intent intent = new Intent(this, BrowsingWordsActivity.class);
        intent.setAction(Intent.ACTION_VIEW);
        intent.setData(uri);
        startActivityForResult(intent, REQUEST_FOR_WORDS);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_FOR_WORDS) {
            if (resultCode == WORDS_RESPONSE_CODE) {
                Toast.makeText(getApplicationContext(), "Sorry, No words!", Toast.LENGTH_SHORT).show();
            }

        }
    }

    void doBindSubscribeService() {
        if(!subscribeServiceBound)
            bindService(new Intent(this, SubscribeWordsFromKeepinService.class), subscribeServiceConnection, Service.BIND_AUTO_CREATE);
        subscribeServiceBound = true;
    }

    private ServiceConnection subscribeServiceConnection = new ServiceConnection() {

        public void onServiceConnected(ComponentName className, IBinder service) {
            subscribeWordsFromKeepinService = ((SubscribeWordsFromKeepinService.LocalSubscribeWordsServiceBinder) service).getService();
        }

        public void onServiceDisconnected(ComponentName componentName) {
            subscribeWordsFromKeepinService = null;
        }
    };

    private void login() {
        Intent intent = new Intent(this, ConfigureCredentialActivity.class);
        intent.setAction(Intent.ACTION_VIEW);
        startActivity(intent);
        finish();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        cursor.close();
        if (subscribeServiceBound) {
            unbindService(subscribeServiceConnection);
        }
    }

    private void initTags() {
        ContentValues values = new ContentValues();
        values.put(Tag.NAME, "familiar");

        Uri familiarUri = getContentResolver().insert(getIntent().getData(), values);

        values.put(Tag.NAME, "unfamiliar");
        Uri unfamiliarUri = getContentResolver().insert(getIntent().getData(), values);

        values.put(Tag.NAME, "all");
        Uri allUri = getContentResolver().insert(getIntent().getData(), values);

//        values = new ContentValues();
//        values.put(Word.ENGLISH, "test");
//        values.put(Word.CHINESE, "测试");
//        Uri testUri = getContentResolver().insert(KeepinContentProvider.WORD_URI, values);
//
//        values = new ContentValues();
//        values.put(Word.ENGLISH, "hello");
//        values.put(Word.CHINESE, "你好");
//        Uri helloUri = getContentResolver().insert(KeepinContentProvider.WORD_URI, values);
//
//        values = new ContentValues();
//        values.put(Word.ENGLISH, "haha");
//        values.put(Word.CHINESE, "哈哈");
//        Uri hahaUri = getContentResolver().insert(KeepinContentProvider.WORD_URI, values);
//
//        values = new ContentValues();
//        values.put(WordTagRelationship.TAG_ID, ContentUris.parseId(unfamiliarUri));
//        values.put(WordTagRelationship.WORD_ID, ContentUris.parseId(testUri));
//        getContentResolver().insert(KeepinContentProvider.WORD_TAG_RELATION_URI, values);
//
//        values = new ContentValues();
//        values.put(WordTagRelationship.TAG_ID, ContentUris.parseId(unfamiliarUri));
//        values.put(WordTagRelationship.WORD_ID, ContentUris.parseId(helloUri));
//        getContentResolver().insert(KeepinContentProvider.WORD_TAG_RELATION_URI, values);
//
//        values = new ContentValues();
//        values.put(WordTagRelationship.TAG_ID, ContentUris.parseId(unfamiliarUri));
//        values.put(WordTagRelationship.WORD_ID, ContentUris.parseId(hahaUri));
//        getContentResolver().insert(KeepinContentProvider.WORD_TAG_RELATION_URI, values);
    }
}
