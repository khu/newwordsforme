package com.tw.keepin.tasks.util;

import com.tw.keepin.R;
import org.junit.Before;
import org.junit.Test;

import java.util.Date;

import static org.junit.Assert.*;


public class RSSHandlerTest {
    RSSHandler rssHandler;

    @Before
    public void setUp() throws Exception {
        rssHandler = new RSSHandler();
    }


    @Test
    public void test_dateParse() throws Exception {
        Date date= rssHandler.parseDate("2011-07-28 07:40:08 UTC");

        System.out.println(date.toString());

        assertNotNull(date);

    }
}
