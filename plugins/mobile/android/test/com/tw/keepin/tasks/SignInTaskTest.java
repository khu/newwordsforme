package com.tw.keepin.tasks;

import android.app.Activity;
import android.content.SharedPreferences;
import com.tw.keepin.ConfigureCredentialActivity;
import com.xtremelabs.robolectric.RobolectricTestRunner;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import static org.hamcrest.core.StringContains.containsString;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertThat;

@RunWith(RobolectricTestRunner.class)
public class SignInTaskTest {
    private Activity setUserActivity;
    String state = "{\"state\":\"success\",\"data\":{\"user\":{\"created_at\":\"2011-07-28T06:41:45Z\"," +
            "\"email\":\"twksos@qq.com\",\"encrypted_password\":\"william\",\"id\":1,\"name\":\"twksos\"," +
            "\"updated_at\":\"2011-07-28T06:41:45Z\"}}}";
    JSONObject user;

    @Before
    public void setUp() throws Exception {
        setUserActivity = new ConfigureCredentialActivity();
        user = new JSONObject("{\"created_at\":\"2011-07-28T06:41:45Z\"," +
                "\"email\":\"twksos@qq.com\",\"encrypted_password\":\"william\",\"id\":1,\"name\":\"twksos\"," +
                "\"updated_at\":\"2011-07-28T06:41:45Z\"}");
    }


    @Test
    public void testOnPostExecute() throws Exception {
        SignInTask signInTask = new SignInTask(setUserActivity, "t1@t.t", "111111");
        signInTask.onPostExecute(state);
        SharedPreferences settings = setUserActivity.getSharedPreferences("KeepIn", 0);
        assertThat(settings.getString("userid", ""), containsString(user.getString("id")));
        assertThat(settings.getString("username", ""), containsString(user.getString("name")));
        assertThat(settings.getString("email", ""), containsString(user.getString("email")));
        assertThat(settings.getString("password", ""), containsString(user.getString("encrypted_password")));
    }

    @Test
    public void testOnDoInBackGroud() throws Exception {
        SignInTask signInTask = new SignInTask(setUserActivity, "t1@t.t", "111111");
        String result= signInTask.doInBackground();
        assertNotNull(result);
    }
}
