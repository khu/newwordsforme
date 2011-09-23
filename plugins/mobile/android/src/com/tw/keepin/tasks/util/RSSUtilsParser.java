package com.tw.keepin.tasks.util;

import com.sun.cnpi.rss.elements.Category;
import com.sun.cnpi.rss.elements.Item;
import com.sun.cnpi.rss.elements.Rss;
import com.sun.cnpi.rss.parser.RssParser;
import com.sun.cnpi.rss.parser.RssParserException;
import com.sun.cnpi.rss.parser.RssParserFactory;
import com.tw.keepin.Word;
import com.tw.keepin.vocabulary.WordItem;

import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 8/1/11
 * Time: 2:44 PM
 * Rss to Word object
 */
public class RSSUtilsParser {

    public List<WordItem> parseRSS(InputStream inputStream) {

        RssParser parser = null;
        Rss rss = null;
        try {
            parser = RssParserFactory.createDefault();
            rss = parser.parse(inputStream);
        } catch (RssParserException e) {
            e.printStackTrace();
        }

        List<WordItem> words = new ArrayList<WordItem>();
        Collection items = rss.getChannel().getItems();
        if( items != null && !items.isEmpty() ){
            Iterator iter = items.iterator();
            while(iter.hasNext()){
                Item item = (Item) iter.next();
                words.add(parseItemToWord(item));
            }
        }

        return words;
    }

    private WordItem parseItemToWord(Item item) {
        WordItem word = null;

        Collection<Category> categories = item.getCategories();

        int word_id = -1 ;
        String[] tags = null ;
        for( Category category : categories ){
            if( category.getDomain().equalsIgnoreCase("id") ) {
                word_id = Integer.parseInt(category.getText().trim());
            } else if ( category.getDomain().equalsIgnoreCase("tags")) {
                String tagString = category.getText();
                if( null != tagString ) {
                   tags = tagString.trim().split(",");
                }

            }
        }
        word = new WordItem(item.getTitle().getText(), item.getDescription().getText(), word_id);
        word.addTag(tags);
        word.setUpdate_date(parseDate(item.getPubDate().getText()));
        return word;
    }

    public Date parseDate(String value) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (value.contains("UTC"))
            format.setTimeZone(TimeZone.getTimeZone("UTC"));
        Date date = null;
        try {
            date = format.parse(value);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }
}
