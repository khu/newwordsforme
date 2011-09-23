package com.tw.keepin.tasks.util;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpResponseException;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.cookie.Cookie;
import org.apache.http.impl.client.DefaultHttpClient;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Scanner;

/**
 * Created by IntelliJ IDEA.
 * User: Wei Guangcheng & Yang Zhen
 * Date: 7/28/11
 * Time: 2:51 PM
 * A support class to make it possible send HTTP requests
 */
public class KeepInHttpServer {
    private List<Cookie> cookies;
    private DefaultHttpClient httpClient;
    private HttpResponse response;
    private String email;
    private String password;

    static KeepInHttpServer server;

    KeepInHttpServer() {
        httpClient = new DefaultHttpClient();
    }

    public static KeepInHttpServer getInstance(){
        if(server == null)
            server = new KeepInHttpServer();
        return server;
    }

    public void SetEmailAndPassword(String email, String password) {
        this.email = email;
        this.password = password;
    }

    public String signIn() throws HttpResponseException {
        try {
            HttpPost signInPost = RequestFactory.createSignInRequest(email, password);
            response = httpClient.execute(signInPost);
            cookies = httpClient.getCookieStore().getCookies();
        } catch (IOException e) {
            throw new HttpResponseException(403, "forbidden");
        }
        return processResponse(response);
    }

    public InputStream getRSSStream(String userId, String dateStr) throws IOException {
        HttpUriRequest httpGet = RequestFactory.createRSSRequest(userId, dateStr);
        try {
            response = httpClient.execute(httpGet);
        } catch (IOException e) {
            e.printStackTrace(); 
        }
        return response.getEntity().getContent();

    }

    private String processResponse(HttpResponse response) throws HttpResponseException {
        String state = null;
        int statusCode = response.getStatusLine().getStatusCode();
        if (statusCode == 200) {
            state = readResponseContent(response);
        } else {
            throw new HttpResponseException(statusCode, response.toString());
        }
        return state;
    }

    private String readResponseContent(HttpResponse response) throws HttpResponseException {
        String state = "";
        HttpEntity entity = response.getEntity();
        try {
            Scanner scanner = new Scanner(entity.getContent());
            while (scanner.hasNext()) {
                state += scanner.nextLine();
            }
        } catch (IOException e) {
            throw new HttpResponseException(403, "forbidden");
        }
        return state;
    }
}