package com.example.funny_todo_app;

import android.content.Context;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class PlatformTextViewFactory extends PlatformViewFactory {

    PlatformTextViewFactory() {
        super(StandardMessageCodec.INSTANCE);
    }

    @Override
    public PlatformView create(Context context, int id, Object argument) {
        return new PlatformTextView(context, id, argument);
    }
}

