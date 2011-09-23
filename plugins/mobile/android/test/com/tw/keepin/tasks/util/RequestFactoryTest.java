package com.tw.keepin.tasks.util;

import com.tw.keepin.DBtestRunner;
import com.xtremelabs.robolectric.Robolectric;
import com.xtremelabs.robolectric.RobolectricTestRunner;
import org.apache.http.Header;
import org.apache.http.client.methods.HttpUriRequest;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.sql.Time;
import java.util.Date;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.junit.Assert.*;

@RunWith(RobolectricTestRunner.class)
public class RequestFactoryTest {
    @Test
    public void test_createSignInRequest_should_return_httpPost_request_with_address_of_sign_in() throws Exception {
        HttpUriRequest signIn = RequestFactory.createSignInRequest("twksos@qq.com", "william");
        assertNotNull(signIn);
        assertThat(signIn.getMethod(), equalTo("POST"));
        assertThat(signIn.getURI().toString(), equalTo(RequestFactory.host + RequestFactory.signInAddress));
        assertTrue(signIn.containsHeader("Content-Type"));
        Header[] headers = signIn.getAllHeaders();
        for (Header header : headers) {
            if (header.getName().equalsIgnoreCase("Content-Type"))
                assertThat(header.getValue(), equalTo("application/json"));
        }
    }

    @Test
    public void testgetRSS_should_return_httpGet_with_address_of_rss_given_default_last_request_time() throws Exception {
        HttpUriRequest RSSsource = RequestFactory.createRSSRequest("1", ConfigurationParamters.DEFAULT_LAST_REQUEST_DATE);
        assertNotNull(RSSsource);
        assertThat(RSSsource.getMethod(), equalTo("GET"));
        assertThat(RSSsource.getURI().toString(), equalTo(RequestFactory.host + String.format(RequestFactory.rssAddress, "1")));
        assertTrue(RSSsource.containsHeader("Content-Type"));
        Header[] headers = RSSsource.getAllHeaders();
        for (Header header : headers) {
            if (header.getName().equalsIgnoreCase("Content-Type"))
                assertThat(header.getValue(), equalTo("application/xml"));
        }

    }


    @Test
    public void testgetRSS_should_return_httpGet_with_address_of_rss_given_certain_last_request_time() throws Exception {
        HttpUriRequest RSSsource = RequestFactory.createRSSRequest("1", new Date().toGMTString());
        System .out.println(new Date().toGMTString());
        assertNotNull(RSSsource);
        assertThat(RSSsource.getMethod(), equalTo("GET"));
        assertThat(RSSsource.getURI().toString(), equalTo(RequestFactory.host + String.format(RequestFactory.rssAddress, "1") + "?date=" + new Date().toGMTString().replace(" ", "%20")));
        assertTrue(RSSsource.containsHeader("Content-Type"));
        Header[] headers = RSSsource.getAllHeaders();
        for (Header header : headers) {
            if (header.getName().equalsIgnoreCase("Content-Type"))
                assertThat(header.getValue(), equalTo("application/xml"));
        }

    }
}
