package com.tw.keepin.vocabulary;

import android.graphics.PointF;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;

public class NavigationByTouchListener implements View.OnTouchListener {
    private Navigation3D navigation;
    PointF start = new PointF();
    PointF end = new PointF();
    boolean isMove = false;

    public NavigationByTouchListener(Navigation3D navigation) {
        this.navigation = navigation;
    }

    public void setNavigation3D(Navigation3D navigation3D){
        this.navigation = navigation3D;
    }

    public boolean onTouch(View view, MotionEvent motionEvent) {

        int actionCode = motionEvent.getAction();

        switch (actionCode) {
            case MotionEvent.ACTION_DOWN:
                isMove = false;
                start.set(motionEvent.getX(), motionEvent.getY());
                break;
            case MotionEvent.ACTION_MOVE:
                isMove = true;
                break;
            case MotionEvent.ACTION_POINTER_UP:
                break;
            case MotionEvent.ACTION_UP:
                isMove = false;
                end.set(motionEvent.getX(), motionEvent.getY());

                // single click
                if (Math.abs(end.x - start.x) <= 10) {
                    navigation.flipWord();
                    return true;
                }
                // move right
                else if (end.x - start.x > 10) {
                    navigation.rightSlideWord();
                }
                // move left
                else {
                    navigation.leftSlideWord();
                }
                break;
            default:
                break;
        }

        return true;
    }
}
