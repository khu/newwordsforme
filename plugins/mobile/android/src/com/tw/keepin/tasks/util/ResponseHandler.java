package com.tw.keepin.tasks.util;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpResponseException;

import java.io.IOException;
import java.util.Scanner;

public class ResponseHandler {

    private static String readResponseContent(HttpResponse response) throws HttpResponseException {
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