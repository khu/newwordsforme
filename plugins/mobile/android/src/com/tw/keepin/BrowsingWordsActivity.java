package com.tw.keepin;

import android.app.Service;
import android.app.TabActivity;
import android.content.*;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.IBinder;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.TabHost;
import android.widget.TextView;
import android.widget.Toast;
import com.tw.keepin.tasks.FetchRSSTask;
import com.tw.keepin.tasks.util.ConfigurationParamters;
import com.tw.keepin.vocabulary.Navigation3D;
import com.tw.keepin.vocabulary.NavigationByTouchListener;
import com.tw.keepin.vocabulary.Vocabulary;
import com.tw.keepin.vocabulary.WordTagRelationship;

/**
 * Browser the words by tags.
 * User: twer
 * Date: 7/26/11
 * Time: 11:25 PM
 */
public class BrowsingWordsActivity extends TabActivity implements TabHost.OnTabChangeListener {

    private SubscribeWordsFromKeepinService subscribeWordsFromKeepinService;

    private boolean subscribeServiceBound = false;
    private Navigation3D navigation;
    private FrameLayout translationContainer;
    private FrameLayout wordContainer;
    private Cursor cursor;
    private TabHost mTabHost;
    private NavigationByTouchListener navigationByTouchListener;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.words);

        setDefaultKeyMode(DEFAULT_KEYS_SHORTCUT);
        translationContainer = (FrameLayout) findViewById(R.id.translation_container);
        wordContainer = (FrameLayout) findViewById(R.id.word_container);

        initialize();
    }

    private void initialize() {
        if (isUserInitialized()) {
            initializeViewData();
            initializeAnimation();
            setupTabHost();
        } else {
            login();
        }
    }

    private void initializeViewData() {
        initTags();
        long tag_id = Tag.getTagId(this, "all");
        Uri uri = ContentUris.withAppendedId(KeepinContentProvider.TAG_WORD_URI, tag_id);
        cursor = getContentResolver().query(uri, new String[]{"w." + Word._ID, Word.ENGLISH, Word.CHINESE},
                " w." + Word._ID + " = r." + WordTagRelationship.WORD_ID + " and r." + WordTagRelationship.TAG_ID + "= ?",
                new String[]{"" + tag_id}, Word.MODIFIED_DATE + " desc");

        if (cursor.moveToFirst()) {
            doBindSubscribeService();
        } else {
            wordContainer.setVisibility(View.GONE);
            FetchRSSTask task = new FetchRSSTask(this, true);
            task.execute();
        }
    }

    private void initializeAnimation() {
        translationContainer.setVisibility(View.GONE);
        wordContainer.setVisibility(View.VISIBLE);
        FrameLayout container_layout = (FrameLayout) findViewById(R.id.container);
        navigation = new Navigation3D(container_layout, Vocabulary.createInstance(cursor, "All"));
        navigationByTouchListener = new NavigationByTouchListener(navigation);
        container_layout.setOnTouchListener(navigationByTouchListener);
        container_layout.setPersistentDrawingCache(ViewGroup.PERSISTENT_ANIMATION_CACHE);
    }

    private void setupTab(final View view, final String tag) {
        View tabView = createTabView(mTabHost.getContext(), tag);

        TabHost.TabSpec setContent = mTabHost.newTabSpec(tag).setIndicator(tabView).setContent(new TabHost.TabContentFactory() {
            public View createTabContent(String tag) {
                return view;
            }
        });

        mTabHost.addTab(setContent);
    }

    private static View createTabView(final Context context, final String text) {
        View view = LayoutInflater.from(context).inflate(R.layout.word_tabs_bg, null);
        TextView tv = (TextView) view.findViewById(R.id.tabsText);
        tv.setText(text);
        return view;
    }


    private boolean isUserInitialized() {
        SharedPreferences settings = this.getSharedPreferences(ConfigurationParamters.KEEPIN_PERF_NAME, Context.MODE_PRIVATE);
        String userId = settings.getString(ConfigurationParamters.USER_ID_ATTR, ConfigurationParamters.DEFAULT_USER_ID);

        return !userId.equals(ConfigurationParamters.DEFAULT_USER_ID);
    }

    private void setupTabHost() {
        mTabHost = (TabHost) findViewById(android.R.id.tabhost);
        mTabHost.setup();
        mTabHost.getTabWidget().setDividerDrawable(R.drawable.tab_divider);
        setupTab(new TextView(this), "All");
        setupTab(new TextView(this), "Familiar");
        setupTab(new TextView(this), "Unfamiliar");

        mTabHost.setOnTabChangedListener(this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (cursor != null && !cursor.isClosed()) {
            cursor.close();
        }
        if (subscribeServiceBound) {
            unbindService(subscribeServiceConnection);
        }
    }

    public void updateWordsView(String tagName) {
        int tag_id = Tag.getTagId(this, tagName.toLowerCase());
        Uri uri = ContentUris.withAppendedId(KeepinContentProvider.TAG_WORD_URI, tag_id);
        cursor = getContentResolver().query(uri, new String[]{"w." + Word._ID, Word.ENGLISH, Word.CHINESE},
                " w." + Word._ID + " = r." + WordTagRelationship.WORD_ID + " and r." + WordTagRelationship.TAG_ID + "= ?",
                new String[]{"" + tag_id}, Word.MODIFIED_DATE + " desc");

        if (!cursor.moveToFirst()) {
            toast("No words for the tag '" + tagName + "'!");
        }

        if (navigation != null) {
            navigation.clearClickedIDs();
        }
        FrameLayout container_layout = (FrameLayout) findViewById(R.id.container);
        navigation = new Navigation3D(container_layout, Vocabulary.createInstance(cursor, tagName));
        navigationByTouchListener.setNavigation3D(navigation);
        cursor.close();
    }

    @Override
    public void onTabChanged(String tagName) {
        updateWordsView(tagName);
    }

    private void toast(String message) {
        Toast.makeText(this,
                message,
                Toast.LENGTH_SHORT).show();
    }

    private ServiceConnection subscribeServiceConnection = new ServiceConnection() {

        public void onServiceConnected(ComponentName className, IBinder service) {
            subscribeWordsFromKeepinService = ((SubscribeWordsFromKeepinService.LocalSubscribeWordsServiceBinder) service).getService();
        }

        public void onServiceDisconnected(ComponentName componentName) {
            subscribeWordsFromKeepinService = null;
        }
    };

    private void doBindSubscribeService() {
        if (!subscribeServiceBound) {
            bindService(new Intent(this, SubscribeWordsFromKeepinService.class), subscribeServiceConnection, Service.BIND_AUTO_CREATE);
        }
        subscribeServiceBound = true;
    }

    private void login() {
        Intent intent = new Intent(this, ConfigureCredentialActivity.class);
        intent.setAction(Intent.ACTION_VIEW);
        startActivity(intent);
        finish();
    }

    private void initTags() {
        ContentValues values = new ContentValues();
        values.put(Tag.NAME, "familiar");

        getContentResolver().insert(KeepinContentProvider.TAG_URI, values);

        values.put(Tag.NAME, "unfamiliar");
        getContentResolver().insert(KeepinContentProvider.TAG_URI, values);

        values.put(Tag.NAME, "all");
        getContentResolver().insert(KeepinContentProvider.TAG_URI, values);
    }

}