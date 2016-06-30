package com.example.portalcapture;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Handler;
import android.util.AttributeSet;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

@SuppressLint("SetJavaScriptEnabled")
public class MockRedirectWebView extends WebView {

	private String mJSString;
	private Handler mHandler;
	private Boolean mExcuted;

	public MockRedirectWebView(Context context) {
		super(context);
		init();
	}

	public MockRedirectWebView(Context context, AttributeSet attrs) {
		super(context, attrs);
		init();
	}

	public MockRedirectWebView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		init();
	}

	public static final String checkUrl() {
		return "http://check.51y5.net/check.html?t="
				+ System.currentTimeMillis();
	}

	@JavascriptInterface
	private void init() {
		WebSettings webSettings = getSettings();
		webSettings.setJavaScriptEnabled(true);
		webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
		 addJavascriptInterface(new Object(){
			 public void toast(String msg)
			 {
				 Toast.makeText(getContext(), msg, Toast.LENGTH_SHORT).show();
			 }
			 
		 }, "hiwifi");
		 setWebViewClient(new HWFWebViewClient());
		 setWebChromeClient(new WebChromeClient());
	}
	
	public void login(String username, String password)
	{
		this.mExcuted = true;
		loadUrl("javascript: wifilocating_auto_login(\"" + username + "\", \"" + password + "\"); ");
	    this.mHandler.sendEmptyMessageDelayed(2, 5000L);
	}
	
	public void setJsString(String jsString)
	{
		mJSString = "javascript:"+jsString;
	}
	
	
	public void execjs(String jscode)
	{
		setJsString(jscode);
		loadUrl(this.mJSString);
	}
	
	public void setTargetHandler(Handler handler)
	{
		this.mHandler = handler;
	}

}
