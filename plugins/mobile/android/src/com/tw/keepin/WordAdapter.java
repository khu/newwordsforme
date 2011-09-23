package com.tw.keepin;

import android.accounts.Account;
import android.content.Context;
import android.widget.Adapter;
import com.j256.ormlite.android.AndroidConnectionSource;
import com.j256.ormlite.dao.BaseDaoImpl;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.TableUtils;

import java.sql.SQLException;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 8/1/11
 * Time: 4:05 PM
 * To change this template use File | Settings | File Templates.
 */
public class WordAdapter {

    ConnectionSource connectionSource;
    private Dao<Word, String> wordDao;

    public WordAdapter(Context context) {
        connectionSource = new AndroidConnectionSource(new DatabaseHelper(context));
    }


    public void init() throws SQLException {
        wordDao = BaseDaoImpl.createDao(connectionSource, Word.class);
        TableUtils.createTable(connectionSource, Word.class);

    }

    public void create(Word word) throws SQLException {
        if (wordDao.create(word) != 1) {
            throw new SQLException("Failure adding account");
        }
        connectionSource.close();
    }

    public List<Word> getWords() throws SQLException {
        return wordDao.queryForAll();
    }
}
