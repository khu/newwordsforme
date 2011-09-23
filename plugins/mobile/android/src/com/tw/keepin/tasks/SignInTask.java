package com.tw.keepin.tasks;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.widget.Toast;
import com.tw.keepin.BrowsingWordsActivity;
import com.tw.keepin.tasks.util.ConfigurationParamters;
import com.tw.keepin.tasks.util.KeepInHttpServer;
import org.apache.http.client.HttpResponseException;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by IntelliJ IDEA.
 * User: Wei Guangcheng & Yang Zhen
 * Date: 7/29/11
 * Time: 3:27 PM
 * To  Show a Progress Dialog on ConfigureCredentialActivity
 */
public class SignInTask extends AsyncTask<Void, Void, String> {
    private KeepInHttpServer keepInHttpServer;
    private ProgressDialog progressDialog;

    private Activity setUserActivity;
    private boolean fail = false;
    static final String KEEPIN = ConfigurationParamters.KEEPIN_PERF_NAME;

    public SignInTask(Activity setUserActivity, String email, String password) {
        this.setUserActivity = setUserActivity;
        keepInHttpServer = KeepInHttpServer.getInstance();
        keepInHttpServer.SetEmailAndPassword(email, password);
        progressDialog = new ProgressDialog(this.setUserActivity);
        progressDialog.setMessage("Please Wait...");
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
    protected void onPreExecute() {
        progressDialog.show();
    }

    @Override
    protected void onPostExecute(String result) {
        progressDialog.dismiss();

        if (fail) {
            toast("invalid username or password");
        } else {
            try {
                JSONObject jsonObject = new JSONObject(result);
//                System.out.println(result);
                saveUserPreference(jsonObject.getJSONObject("data").getJSONObject("user"));

                toShowWordsActivity();

            } catch (JSONException e) {
                toast("server error");
            }
        }
    }

    private void toShowWordsActivity() {
        setUserActivity.startActivity(new Intent(setUserActivity, BrowsingWordsActivity.class));
        setUserActivity.finish();
    }

    private void toast(String message) {
        Toast.makeText(setUserActivity.getApplicationContext(),
                message,
                Toast.LENGTH_SHORT).show();
    }

    private void saveUserPreference(JSONObject jsonObject) {
        SharedPreferences.Editor editor = setUserActivity.getSharedPreferences(KEEPIN, Context.MODE_PRIVATE).edit();
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
}
