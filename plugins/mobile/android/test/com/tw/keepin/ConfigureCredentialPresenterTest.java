package com.tw.keepin;

import android.content.Intent;
import com.xtremelabs.robolectric.RobolectricTestRunner;
import com.xtremelabs.robolectric.shadows.ShadowActivity;
import com.xtremelabs.robolectric.shadows.ShadowIntent;
import org.hamcrest.CoreMatchers;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import static com.xtremelabs.robolectric.Robolectric.shadowOf;
import static org.hamcrest.core.IsEqual.equalTo;
import static org.junit.Assert.assertThat;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 8/14/11
 * Time: 5:19 PM
 * To change this template use File | Settings | File Templates.
 */
@RunWith(RobolectricTestRunner.class)
public class ConfigureCredentialPresenterTest {
    public static final String responseBody = "{\"state\":\"success\",\"data\":{\"user\":{\"created_at\":\"2011-07-28T08:02:50Z\",\"email\":\"twksos@qq.com\",\"encrypted_password\":\"william\",\"id\":2,\"name\":\"twksos\",\"updated_at\":\"2011-07-28T08:02:50Z\"}}}";
    private ConfigureCredentialPresenter presenter;
    private ConfigureCredentialActivity configureCredentialActivity;

    @Before
    public void setUp() throws Exception {
        configureCredentialActivity = new ConfigureCredentialActivity();
        configureCredentialActivity.onCreate(null);
        configureCredentialActivity .onPostCreate(null);
        presenter = new ConfigureCredentialPresenter(configureCredentialActivity);
    }

    @Test
    public void should_toast_invalid_username_or_password_when_sign_in_failed() throws Exception {
        presenter.signInCompleted(true, responseBody);
        assertThat(configureCredentialActivity.progressDialog.isShowing(), equalTo(false));
        assertThat(configureCredentialActivity.toastMessage, equalTo("invalid username or password"));
    }

    @Test
    public void should_start_browsing_words_activity_when_sign_in_success() throws Exception {
        presenter.signInCompleted(false, responseBody);
        assertThat(configureCredentialActivity.progressDialog.isShowing(), equalTo(false));
        ShadowActivity shadowActivity=shadowOf(configureCredentialActivity);
        Intent startedIntent = shadowActivity.getNextStartedActivity();
        ShadowIntent shadowIntent = shadowOf(startedIntent);
        assertThat(shadowIntent.getComponent().getClassName(), CoreMatchers.equalTo(BrowsingWordsActivity.class.getName()));
    }


}
