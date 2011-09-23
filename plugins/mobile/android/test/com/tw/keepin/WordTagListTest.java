package com.tw.keepin;

import android.content.ContentValues;
import android.content.Intent;
import android.net.Uri;
import android.widget.ListView;
import android.widget.TextView;
import com.xtremelabs.robolectric.Robolectric;
import com.xtremelabs.robolectric.RobolectricTestRunner;
import com.xtremelabs.robolectric.shadows.ShadowIntent;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import static org.hamcrest.core.IsEqual.equalTo;
import static org.junit.Assert.*;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 7/29/11
 * Time: 9:36 AM
 */
@RunWith(DBtestRunner.class)
public class WordTagListTest {
    private WordTagListActivity tagListActivity = null;
    private TextView listView = null;
    private Uri testUri = Uri.parse("content://com.tw.keepin/test");

    @Before
    public void setup() {
        tagListActivity = new WordTagListActivity();
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_DEFAULT);
        intent.setData(testUri);
        tagListActivity.setIntent(intent);
        tagListActivity.onCreate(null);
        tagListActivity.setContentView(R.layout.word_tag_list);
        listView = (TextView)tagListActivity.findViewById(R.id.word_tag_list_id);
    }

    @Test
    public void should_have_a_list_view(){
        assertNotNull(listView);
    }

    @Test
    public void given_have_two_tags_familiar_and_unfamiliar_should_show_the_tow_tags_in_list_view()
    {
        // Given
        Uri uri = Uri.parse("content://com.tw.keepin/test/tags");
        tagListActivity.getContentResolver().delete(uri, null, null);
        ContentValues values = new ContentValues();
        values.put("Name", "familiar");
        tagListActivity.getContentResolver().insert(uri, values);

        // When
//        int count = listView.getCount();
        // Then
//        assertEquals(count, 2);
    }
}
