package com.tw.keepin.tasks.util;

import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.entity.StringEntity;

import java.io.UnsupportedEncodingException;
import java.util.Date;

/**
 * Created by IntelliJ IDEA.
 * User: Wei Guangcheng & Yang Zhen
 * Date: 8/1/11
 * Time: 10:45 AM
 * produce http requests.
 */
public class RequestFactory {
    static String host = "http://keepin3.heroku.com";
    final static String signInAddress = "/sessions";
    public static String rssAddress = "/users/%s.rss";

    public static HttpPost createSignInRequest(String email, String password) throws UnsupportedEncodingException {
        HttpPost signInPost = new HttpPost(host + signInAddress);
        signInPost.setHeader("Content-Type", "application/json");
        signInPost.setHeader("Accept", "application/json");
        StringEntity parameters = new StringEntity("{session:{email:\"" + email + "\", password:\"" + password + "\"}}");
        signInPost.setEntity(parameters);
        return signInPost;
    }

    public static HttpUriRequest createRSSRequest(String userId, String dateStr) {
        HttpGet getRss;
        if (dateStr.equals(new Date(1, 1, 1))) {
            getRss = new HttpGet(host + String.format(rssAddress, userId));
        } else {
            String url = host + String.format(rssAddress, userId) + "?date=" + dateStr.replace(" ", "%20");
            getRss = new HttpGet(url.toString());
        }

        getRss.setHeader("Content-Type", "application/xml");
        return getRss;
    }
}
