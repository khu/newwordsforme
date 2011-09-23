package com.tw.keepin;

import org.json.JSONException;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 8/14/11
 * Time: 4:52 PM
 * To change this template use File | Settings | File Templates.
 */
public class ConfigureCredentialPresenter {

    private ConfigureCredentialActivityCallBack configureCredentialActivityCallBack;

    public ConfigureCredentialPresenter(ConfigureCredentialActivityCallBack configureCredentialActivityCallBack) {
        this.configureCredentialActivityCallBack = configureCredentialActivityCallBack;
    }

    public void signInCompleted(boolean fail, String result) {
        configureCredentialActivityCallBack.dismissProgressDialog();

        if (fail) {
            configureCredentialActivityCallBack.toast("invalid username or password");
        } else {
            try {
                configureCredentialActivityCallBack.toShowWordsActivity(result);
            } catch (JSONException e) {
                configureCredentialActivityCallBack.toast("server error");
            }
        }
    }
}
