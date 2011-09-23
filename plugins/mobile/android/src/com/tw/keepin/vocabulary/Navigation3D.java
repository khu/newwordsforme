package com.tw.keepin.vocabulary;

import android.content.ContentValues;
import android.view.View;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.DecelerateInterpolator;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.widget.ViewFlipper;
import com.tw.keepin.KeepinContentProvider;
import com.tw.keepin.R;
import com.tw.keepin.Tag;

import java.util.ArrayList;
import java.util.List;

public class Navigation3D {

    private static final String FAMILIAR = "familiar";
    private static final String UNFAMILIAR = "unfamiliar";

    private FrameLayout container;
    private FrameLayout translationContainer;
    private FrameLayout wordContainer;
    private Vocabulary vocabulary;
    private TextView translationView;
    private TextView wordView;
    private boolean position = true;
    private ViewFlipper mFlipper;
    private long unfamiliarTagId, familiarTagId;

    private List<Integer> clickedWordIDs;

    public Navigation3D(FrameLayout container, Vocabulary vocabulary) {
        this.container = container;
        this.vocabulary = vocabulary;
        translationView = (TextView) container.findViewById(R.id.translation);
        wordView = (TextView) container.findViewById(R.id.word);
        translationContainer = (FrameLayout) container.findViewById(R.id.translation_container);
        wordContainer = (FrameLayout) container.findViewById(R.id.word_container);
        mFlipper = (ViewFlipper) container.getParent();

        clickedWordIDs = new ArrayList<Integer>();
        setInitialWord();
        getInitialTags();
        setDefaultState();
    }

    private void setInitialWord() {
        WordItem firstWord = vocabulary.firstToShow();
        setViewText(firstWord.getEng(), firstWord.getTranslation());
    }

    private void getInitialTags() {
        unfamiliarTagId = Tag.getTagId(container.getContext(), UNFAMILIAR);
        familiarTagId = Tag.getTagId(container.getContext(), FAMILIAR);
    }

    private void setDefaultState() {
        translationContainer.setVisibility(View.GONE);
        if (vocabulary.size() > 0) {
            wordContainer.setVisibility(View.VISIBLE);
        } else {
            wordContainer.setVisibility(View.GONE);
        }
    }

    public void flipWord() {
        container.requestFocus();
        container.setFocusableInTouchMode(true);
        if (vocabulary.size() == 0) {
            return;
        }
        position = !position;
        applyRotation(position, 0, -90);
        CharSequence text = wordView.getText();
        WordItem w = vocabulary.current(text.toString());
        if (!isWordClicked(w.getId())) {
            clickedWordIDs.add(w.getId());
            updateTag(w, familiarTagId, unfamiliarTagId);
        }
    }

    private void updateTag(WordItem w, long originTagId, long targetTagId) {
        ContentValues values = new ContentValues();
        values.put(WordTagRelationship.TAG_ID, "" + targetTagId);
        values.put(WordTagRelationship.WORD_ID, w.getId());
        container.getContext().getContentResolver().update(KeepinContentProvider.WORD_TAG_RELATION_URI, values,
                WordTagRelationship.TAG_ID + "=? AND " + WordTagRelationship.WORD_ID + "= ?",
                new String[]{"" + originTagId, "" + w.getId()});
    }

    private boolean isWordClicked(int word_id) {
        return clickedWordIDs.contains(word_id);
    }

    public void leftSlideWord() {
        container.requestFocus();
        container.setFocusableInTouchMode(true);
        CharSequence text = wordView.getText();

        WordItem current_word = vocabulary.current(text.toString());
        if (!isWordClicked(current_word.getId())) {
            updateTag(current_word, unfamiliarTagId, familiarTagId);
        }

        if (vocabulary.isFirst(text.toString())) {
            return;
        }
        if (translationContainer.getVisibility() == View.VISIBLE) {
            position = !position;
        }
        setContainerVisible(View.VISIBLE, View.GONE);
        WordItem word = vocabulary.previous(text.toString());
        setViewText(word.getEng(), word.getTranslation());

        mFlipper.setInAnimation(AnimationUtils.loadAnimation(container.getContext(),
                R.anim.push_right_in));
        mFlipper.setOutAnimation(AnimationUtils.loadAnimation(container.getContext(),
                R.anim.push_right_out));
        mFlipper.showPrevious();
    }

    public void rightSlideWord() {
        container.requestFocus();
        container.setFocusableInTouchMode(true);
        CharSequence text = wordView.getText();

        WordItem current_word = vocabulary.current(text.toString());
        if (!isWordClicked(current_word.getId())) {
            updateTag(current_word, unfamiliarTagId, familiarTagId);
        }

        if (vocabulary.isLast(text.toString())) {
            return;
        }

        if (translationContainer.getVisibility() == View.VISIBLE) {
            position = !position;
        }
        setContainerVisible(View.VISIBLE, View.GONE);
        WordItem word = vocabulary.next(text.toString());
        setViewText(word.getEng(), word.getTranslation());
        mFlipper.setInAnimation(AnimationUtils.loadAnimation(container.getContext(),
                R.anim.push_left_in));
        mFlipper.setOutAnimation(AnimationUtils.loadAnimation(container.getContext(),
                R.anim.push_left_out));
        mFlipper.showNext();
    }

    private void setViewText(String wordViewText, String translationViewText) {
        wordView.setText(wordViewText);
        translationView.setText(translationViewText);
    }

    private void setContainerVisible(int wordContainerVisible, int translationContainerVisible) {
        wordContainer.setVisibility(wordContainerVisible);
        translationContainer.setVisibility(translationContainerVisible);
    }

    private void applyRotation(boolean position, float start, float end) {
        // Find the center of the container
        final float centerX = container.getWidth() / 2.0f;
        final float centerY = container.getHeight() / 2.0f;

        // Create a new 3D rotation with the supplied parameter
        // The animation listener is used to trigger the next animation
        final Rotate3dAnimation rotation =
                new Rotate3dAnimation(start, end, centerX, centerY, 310.0f, true);
        rotation.setDuration(500);
        rotation.setFillAfter(true);
        rotation.setInterpolator(new AccelerateInterpolator());
        rotation.setAnimationListener(new DisplayNextView(position));

        container.startAnimation(rotation);
    }

    private final class DisplayNextView implements Animation.AnimationListener {
        private final boolean mPosition;

        private DisplayNextView(boolean position) {
            mPosition = position;
        }

        public void onAnimationStart(Animation animation) {
        }

        public void onAnimationEnd(Animation animation) {

            container.post(new SwapViews(mPosition));
        }

        public void onAnimationRepeat(Animation animation) {
        }
    }

    public void clearClickedIDs() {
        this.clickedWordIDs.clear();
        this.clickedWordIDs = null;
    }

    private final class SwapViews implements Runnable {
        private final boolean mPosition;

        public SwapViews(boolean position) {
            mPosition = position;
        }

        public void run() {
            final float centerX = container.getWidth() / 2.0f;
            final float centerY = container.getHeight() / 2.0f;
            Rotate3dAnimation rotation;

            if (mPosition) {
                translationContainer.setVisibility(View.GONE);
                wordContainer.setVisibility(View.VISIBLE);
                wordContainer.requestFocus();

                rotation = new Rotate3dAnimation(90, 0, centerX, centerY, 310.0f, false);
            } else {
                wordContainer.setVisibility(View.GONE);
                translationContainer.setVisibility(View.VISIBLE);
                translationContainer.requestFocus();

                rotation = new Rotate3dAnimation(90, 0, centerX, centerY, 310.0f, false);
            }

            rotation.setDuration(500);
            rotation.setFillAfter(true);
            rotation.setInterpolator(new DecelerateInterpolator());

            container.startAnimation(rotation);
        }
    }
}
