package com.tw.keepin;

import org.json.JSONException;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 8/14/11
 * Time: 4:55 PM
 * To change this template use File | Settings | File Templates.
 */
public interface ConfigureCredentialActivityCallBack {

    void showProgressDialog();

    void dismissProgressDialog();

    void toShowWordsActivity(String result) throws JSONException;

    void toast(String s);
}
