package com.tw.keepin.tasks.util;

import com.tw.keepin.Word;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 8/1/11
 * Time: 2:44 PM
 * Rss to Word object
 */
public class RSSHandler extends DefaultHandler {
    List<Word> words = new ArrayList<Word>();
    Word word;
    String element;

    @Override
    public void characters(char[] ch, int start, int length) throws SAXException {
        String value = "";
        for (int i = start; i < start + length; i++) {
            value += ch[i];
        }
        value = value.trim();

        if (null != word && value.length() > 0) {
            if (element.equals("category")) {
                word.id = Integer.parseInt(value);
            }
            if (element.equals("title")) {
                word.english = value;
            }
            if (element.equals("description")) {
                if (value != null)
                    word.translation += value;
            }
            if (element.equals("pubDate")) {
                try {
                    word.update_date = parseDate(value);

                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public Date parseDate(String value) throws ParseException {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (value.contains("UTC"))
            format.setTimeZone(TimeZone.getTimeZone("UTC"));
        return format.parse(value);
    }

    @Override
    public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
        if (qName == "item") {
            word = new Word();
        }
        element = qName;

    }

    @Override
    public void endElement(String uri, String localName, String qName) throws SAXException {
        if (qName == "item") {
            words.add(word);
        }

    }

    public List<Word> getWords() {
        for (Word word : words) {
            System.out.println(word.english + "," + word.translation);
        }
        return words;
    }
}
