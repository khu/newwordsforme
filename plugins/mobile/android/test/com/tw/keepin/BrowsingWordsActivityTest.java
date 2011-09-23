package com.tw.keepin;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import com.tw.keepin.tasks.util.ConfigurationParamters;
import com.xtremelabs.robolectric.RobolectricTestRunner;
import com.xtremelabs.robolectric.shadows.ShadowActivity;
import com.xtremelabs.robolectric.shadows.ShadowIntent;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import static com.xtremelabs.robolectric.Robolectric.shadowOf;
import static org.hamcrest.CoreMatchers.equalTo;
import static org.junit.Assert.assertThat;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 8/11/11
 * Time: 11:33 AM
 */
@RunWith(RobolectricTestRunner.class)
public class BrowsingWordsActivityTest {
    BrowsingWordsActivity browsingWordsActivity;
    SharedPreferences sharedPreferences;

    @Before
    public void setUp() throws Exception {
        browsingWordsActivity = new BrowsingWordsActivity();
        browsingWordsActivity.onCreate(null);
        sharedPreferences = browsingWordsActivity.getSharedPreferences(ConfigurationParamters.USER_ID_ATTR, Context.MODE_PRIVATE);
    }

    @Test
    public void test_should_start_ConfigurationActivity_since_no_user_configured() throws Exception {
        // Given
        sharedPreferences.edit().putString(ConfigurationParamters.USER_ID_ATTR, ConfigurationParamters.DEFAULT_USER_ID);
        ShadowActivity shadowActivity=shadowOf(browsingWordsActivity);
        Intent startedIntent = shadowActivity.getNextStartedActivity();
        ShadowIntent shadowIntent = shadowOf(startedIntent);

        assertThat(shadowIntent.getComponent().getClassName(), equalTo(ConfigureCredentialActivity.class.getName()));
    }
}
