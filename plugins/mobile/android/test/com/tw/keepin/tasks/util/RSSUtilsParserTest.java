package com.tw.keepin.tasks.util;

import com.tw.keepin.vocabulary.WordItem;
import org.junit.Before;
import org.junit.Test;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.List;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 8/10/11
 * Time: 3:55 PM
 * To change this template use File | Settings | File Templates.
 */
public class RSSUtilsParserTest {
    RSSUtilsParser rssUtilsParser;
    String string = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
            "<rss version=\"2.0\">\n" +
            "  <channel>\n" +
            "    <title>Words</title>\n" +
            "    <description>All the words which t1 is learning</description>\n" +
            "    <link>http://localhost:3000/users/1.rss</link>\n" +
            "    <item>\n" +
            "      <title>yes</title>\n" +
            "      <description>&#26159;</description>\n" +
            "      <pubDate>2011-08-09 07:53:02 UTC</pubDate>\n" +
            "      <category domain=\"id\">9</category>\n" +
            "      <category domain=\"tags\">unfamiliar</category>\n" +
            "    </item>\n" +
            "    <item>\n" +
            "      <title>do</title>\n" +
            "      <description>&#20570;</description>\n" +
            "      <pubDate>2011-08-09 07:20:42 UTC</pubDate>\n" +
            "      <category domain=\"id\">4</category>\n" +
            "      <category domain=\"tags\">unfamiliar</category>\n" +
            "    </item>\n" +
            "  </channel>\n" +
            "</rss>";
    private InputStream stream= new ByteArrayInputStream(string.getBytes());
    List<WordItem> wordItemList;

    @Before
    public void setUp() throws Exception {
        rssUtilsParser = new RSSUtilsParser();
    }

    @Test
    public void test_should_prase_RSSStream_to_Words() throws Exception {
        wordItemList = rssUtilsParser.parseRSS(stream);
        assertFalse(wordItemList.isEmpty());
        for (WordItem wordItem : wordItemList) {
            assertNotNull(wordItem.getId());
        }
    }
}
