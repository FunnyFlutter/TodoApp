package com.example.funny_todo_app;

import android.content.Context;
import android.view.View;
import android.widget.TextView;

import io.flutter.plugin.platform.PlatformView;
public class PlatformTextView implements PlatformView {
    public final int id;
    private TextView textView;

    PlatformTextView(Context context, int id, Object args) {
        this.id = id;
        String text = args.toString();
        this.textView = new TextView(context);
        this.textView.setText(text);
    }

    @Override
    public View getView() {
        return this.textView;
    }

    @Override
    public void dispose() {
        this.textView = null;
    }
}