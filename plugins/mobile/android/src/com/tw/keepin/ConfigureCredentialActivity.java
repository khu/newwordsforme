package com.tw.keepin;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import com.tw.keepin.tasks.util.ConfigurationParamters;
import com.tw.keepin.tasks.util.KeepInHttpServer;
import org.apache.http.client.HttpResponseException;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by IntelliJ IDEA.
 * User: Wei Guangcheng & Yang Zhen
 * Date: 7/27/11
 * Time: 11:06 AM
 * This Activity is for sign in to the system
 */
public class ConfigureCredentialActivity extends Activity implements ConfigureCredentialActivityCallBack {

    public EditText passwordEdit;
    public EditText emailEdit;
    public Button signInButton;
    public Button clearButton;
    public ProgressDialog progressDialog;
    public ConfigureCredentialPresenter presenter;
    public String toastMessage;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.setuser);

        initFields();

        setListeners();
    }

    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        progressDialog = new ProgressDialog(this);
        presenter = new ConfigureCredentialPresenter(this);
    }

    private void initFields() {
        emailEdit = (EditText) findViewById(R.id.emailEdit);
        passwordEdit = (EditText) findViewById(R.id.passwordEdit);
        signInButton = (Button) findViewById(R.id.signInButton);
        clearButton = (Button) findViewById(R.id.clearButton);
    }

    private void setListeners() {
        signInButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                signIn();
            }
        });

        clearButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                onClearButtonClick(view);
            }
        });
    }

    private void signIn() {
        SignInTask signInTask = new SignInTask(this, emailEdit.getText().toString(), passwordEdit.getText().toString());
        signInTask.execute();
    }

    void onClearButtonClick(View view) {
        emailEdit.setText("");
        passwordEdit.setText("");
    }

    @Override
    public void showProgressDialog() {
        if (progressDialog == null) return;
        progressDialog.show();
    }

    @Override
    public void dismissProgressDialog() {
        if (progressDialog == null) return;
        progressDialog.dismiss();
    }

    @Override
    public void toShowWordsActivity(String result) throws JSONException {
//        JSONObject jsonObject = new JSONObject(result);
//        saveUserPreference(jsonObject.getJSONObject("data").getJSONObject("user"));
        startActivity(new Intent(this, BrowsingWordsActivity.class));
        finish();
    }

    @Override
    public void toast(String message) {
        toastMessage = message;
        Toast.makeText(this.getApplicationContext(),
                message,
                Toast.LENGTH_SHORT).show();
    }

    private void saveUserPreference(JSONObject jsonObject) {
        SharedPreferences.Editor editor = this.getSharedPreferences(ConfigurationParamters.KEEPIN_PERF_NAME, Context.MODE_PRIVATE).edit();
        try {
            editor.putString("userid", jsonObject.getString("id"));
            editor.putString("username", jsonObject.getString("name"));
            editor.putString("email", jsonObject.getString("email"));
            editor.putString("password", jsonObject.getString("encrypted_password"));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        editor.commit();
    }


    private class SignInTask extends AsyncTask<Void, Void, String> {
        private KeepInHttpServer keepInHttpServer;

        private Activity setUserActivity;
        private boolean fail = false;
        static final String KEEPIN = ConfigurationParamters.KEEPIN_PERF_NAME;

        public SignInTask(Activity setUserActivity, String email, String password) {
            this.setUserActivity = setUserActivity;
            keepInHttpServer = KeepInHttpServer.getInstance();
            keepInHttpServer.SetEmailAndPassword(email, password);
        }

        @Override
        protected void onPreExecute() {
            progressDialog.setMessage("Please Wait...");
            progressDialog.show();
        }

        @Override
        protected String doInBackground(Void... voids) {
            String result = null;
            try {
                result = keepInHttpServer.signIn();
            } catch (HttpResponseException e) {
                fail = true;
            }
            return result;
        }

        @Override
        protected void onPostExecute(String result) {
            presenter.signInCompleted(fail, result);
        }
    }

}