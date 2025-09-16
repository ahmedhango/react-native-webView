package com.rnwebviewnative;

import android.content.Intent;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

public class WebViewNativeModule extends ReactContextBaseJavaModule {
  private final ReactApplicationContext context;

  public WebViewNativeModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.context = reactContext;
    WebViewNativeEmitter.setContext(reactContext);
  }

  @Override public String getName() { return "WebViewNativeModule"; }

  @ReactMethod
  public void open(ReadableMap config, Promise promise) {
    try {
      String url = config.hasKey("url") ? config.getString("url") : "";
      String html = config.hasKey("html") ? config.getString("html") : "";
      Intent i = new Intent(context, WebViewNativeActivity.class);
      i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      i.putExtra("url", url);
      i.putExtra("html", html);
      context.startActivity(i);
      promise.resolve(true);
    } catch (Exception e) {
      promise.reject("ERR_OPEN", e);
    }
  }
}


