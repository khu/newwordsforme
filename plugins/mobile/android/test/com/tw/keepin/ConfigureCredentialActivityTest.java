package com.tw.keepin;

import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import com.xtremelabs.robolectric.RobolectricTestRunner;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import static org.hamcrest.core.IsEqual.equalTo;
import static org.junit.Assert.*;

@RunWith(RobolectricTestRunner.class)
public class ConfigureCredentialActivityTest {

    private ConfigureCredentialActivity configureCredentialActivity;
    private Button clear;
    private Button signIn;
    private EditText passwordEdit;
    private EditText emailEdit;

    @Before
    public void setUp() throws Exception {
        configureCredentialActivity = new ConfigureCredentialActivity();
        configureCredentialActivity.onCreate(null);
        clear = (Button) configureCredentialActivity.findViewById(R.id.clearButton);
        signIn = (Button) configureCredentialActivity.findViewById(R.id.signInButton);
        emailEdit = (EditText) configureCredentialActivity.findViewById(R.id.emailEdit);
        passwordEdit = (EditText) configureCredentialActivity.findViewById(R.id.passwordEdit);
    }

    @Test
    public void testOnCreate() throws Exception {
        assertNotNull(configureCredentialActivity);
        assertThat(getTextFromTextView(R.id.emailText), equalTo("Email"));
        assertThat(getTextFromTextView(R.id.passwordText), equalTo("Password"));
        assertThat(getTextFromTextView(R.id.signInButton), equalTo("Sign In"));
        assertThat(getTextFromTextView(R.id.clearButton), equalTo("Clear"));
    }

    @Test
    public void testClearOnClick() throws Exception {
        emailEdit.setText("some text");
        passwordEdit.setText("some password");
        clear.performClick();
        assertThat(emailEdit.getText().toString(), equalTo(""));
        assertThat(passwordEdit.getText().toString(), equalTo(""));
    }

    @Test
    public void testSignInShouldSendHttpRequest() throws Exception {
        emailEdit.setText("t1@t.t");
        passwordEdit.setText("111111");
        signIn.performClick();
        //TODO: active changes
    }

    private String getTextFromTextView(int viewId) {
        return ((TextView) configureCredentialActivity.findViewById(viewId)).getText().toString();
    }
}
