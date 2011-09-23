package com.tw.keepin;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.util.Log;
import com.tw.keepin.tasks.FetchRSSTask;

/**
 * Created by IntelliJ IDEA.
 * User: twer
 * Date: 7/26/11
 * Time: 11:29 PM
 */
public class SubscribeWordsFromKeepinService extends Service {

    private final IBinder subscribeWordsBinder = new LocalSubscribeWordsServiceBinder();

    private FetchRSSTask fetchRSSTask;

    @Override
    public void onCreate() {
        fetchRSSTask = new FetchRSSTask(this, false);
    }

    @Override
    public void onStart(Intent intent, int startId) {
        fetchRSSTask.execute();

    }

    @Override
    public void onDestroy() {
        Log.i("SubscribeService:", "destroy-----");
    }

    public IBinder onBind(Intent intent) {
        fetchRSSTask.execute();
        return subscribeWordsBinder;
    }

    public class LocalSubscribeWordsServiceBinder extends Binder {
        SubscribeWordsFromKeepinService getService() {
            return SubscribeWordsFromKeepinService.this;
        }
    }


}
