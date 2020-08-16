package com.example.funny_todo_app;

import androidx.annotation.NonNull;

import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    // 此处的名字要和 dart 侧的一致
    private static final String CHANNEL = "com.funny_flutter.todo_list.channel";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        // 新建一个 MethodChannel 对象
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((MethodCall call, MethodChannel.Result result) -> {
                    // 当收到名为 getCurrentLocation 的方法调用时，返回getCurrentLocation()函数的结果
                    if (call.method.equals("getCurrentLocation")) {
                        result.success(getCurrentPosition());
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }

    public HashMap<String, String> getCurrentPosition() {
        // 返回当前位置
        return new HashMap<String, String>() {{
            put("latitude", "39.92");
            put("longitude", "116.46");
            put("description", "北京");
        }};
    }
}
