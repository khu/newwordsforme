package com.tw.keepin.tasks.util;

import com.xtremelabs.robolectric.Robolectric;
import com.xtremelabs.robolectric.RobolectricTestRunner;
import org.apache.http.client.HttpResponseException;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import static org.hamcrest.CoreMatchers.containsString;
import static org.junit.Assert.assertThat;

@RunWith(RobolectricTestRunner.class)
public class KeepInHttpServerTest {

    static final String emulatorHost = "http://10.0.2.2:3000" ;
    static final String testHost = "http://localhost:3000" ;
    public static final String responseBody = "{\"state\":\"success\",\"data\":{\"user\":{\"created_at\":\"2011-07-28T08:02:50Z\",\"email\":\"twksos@qq.com\",\"encrypted_password\":\"william\",\"id\":2,\"name\":\"twksos\",\"updated_at\":\"2011-07-28T08:02:50Z\"}}}";
    private KeepInHttpServer keepInHttpServer;
    private String state;

    @Before
    public void setUp() throws Exception {
        RequestFactory.host= testHost;
        keepInHttpServer = new KeepInHttpServer();
    }

    @Test(expected = HttpResponseException.class)
    public void should_return_http_response_exception_when_user_and_password_not_matched() throws Exception {
        Robolectric.addPendingHttpResponse(404, "failure");

        keepInHttpServer.SetEmailAndPassword("t1@t.t", "111111111");
        state = keepInHttpServer.signIn();
    }

    @Test
    public void should_return_success_and_user_id_when_correct() throws Exception {
        Robolectric.addPendingHttpResponse(200, responseBody);
        keepInHttpServer.SetEmailAndPassword("twksos@qq.com", "william");
        state = keepInHttpServer.signIn();
        assertThat(state, containsString("success"));
        assertThat(state, containsString("twksos@qq.com"));
        assertThat(state, containsString("william"));
    }

    @Test
    public void test_getRSS_Should_return_RSS_of_user() throws Exception {
//        keepInHttpServer.SetEmailAndPassword("twksos@qq.com", "william");
//        String rss= keepInHttpServer.getRSS("1",new Date(1,1,1).toGMTString());
//        assertNotNull(rss);
//        assertTrue(rss.length()>0);
//        assertThat(rss,equalTo("<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
//                "<rss version=\"2.0\">" +
//                "  <channel>" +
//                "    <title>Words</title>" +
//                "    <description>All the words which twksos is learning</description>" +
//                "    <link>http://localhost:3000/users/1.rss</link>" +
//                "    <item>" +
//                "      <title>a</title>" +
//                "      <description>a &#19968;</description>" +
//                "      <pubDate>2011-07-28 06:41:49 UTC</pubDate>" +
//                "    </item>" +
//                "  </channel>" +
//                "</rss>"));
    }
}
