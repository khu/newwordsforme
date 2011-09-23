package com.tw.keepin.vocabulary;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class WordItem {
    private int word_id;
    private String eng;
    private String translation;
    private Date update_date;
    private List<String> tags = new ArrayList<String>();
    public static WordItem NULL = new WordItem("", "", -1);
    public static WordItem NO_MORE = new WordItem("", "", -1);

    public WordItem(String eng, String translation) {
        this.eng = eng;
        this.translation = translation;
    }

    public Date getUpdate_date() {
        return update_date;
    }

    public void setUpdate_date(Date update_date) {
        this.update_date = update_date;
    }

    public void addTag(String tag) {
        tags.add(tag);
    }

    public void addTag(String[] tags) {
        if(tags == null)
        {
            return;
        }

        for (String tag : tags)
        {
            this.addTag(tag);
        }
    }

    public List<String> getTags(){
        return this.tags;
    }

    public WordItem(String eng, String translation, int id) {
        this.eng = eng;
        this.translation = translation;
        this.word_id = id;
    }

    public int getId() {
        return word_id;
    }

    public String getEng() {
        return eng;
    }

    public String getTranslation() {
        return this.translation;
    }

    public void addTo(List<WordItem> words) {
        if (this.equals(WordItem.NULL)) {
            return;
        }
        words.add(this);
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        WordItem word = (WordItem) o;

        if (eng != null ? !eng.equals(word.eng) : word.eng != null)
            return false;

        return true;
    }

    @Override
    public int hashCode() {
        return eng != null ? eng.hashCode() : 0;
    }


    public WordItem translate() {
        return this;
    }

//    private static Word parseFromGoolgeTranslation(String english, String responseBodyAsString) {
//        try {
//            JSONObject jsonObject = new JSONObject(responseBodyAsString);
//            JSONObject responseData = jsonObject.getJSONObject("responseData");
//            return new Word(english, responseData.getString("translatedText"));
//        } catch (Exception e) {
//            return Word.NULL;
//        }
//    }
//
//    public static Word parseFromTwitteSyntax(String text) {
//
//        Pattern reg = Pattern.compile("([a-zA-Z]+)\\s*@单词本");
//        Matcher matcher = reg.matcher(text.trim());
//        if (matcher.matches()) {
//            Log.i(">>>>", "parse result of text is (" + matcher.group(1) + ")");
//            return new Word(matcher.group(1), "");
//        }
//        return Word.NULL;
//    }

    @Override
    public String toString() {
        return getEng() + "@" + getTranslation();
    }
}
