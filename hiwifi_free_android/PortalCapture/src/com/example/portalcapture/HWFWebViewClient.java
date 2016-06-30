package com.example.portalcapture;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import android.app.Application;
import android.content.res.AssetManager;
import android.webkit.WebView;
import android.webkit.WebViewClient;

final class HWFWebViewClient extends WebViewClient {

	public HWFWebViewClient() {
	}

	@Override
	public void onPageFinished(WebView view, String url) {
		view.loadUrl("javascript:alert('load sucess');");
		super.onPageFinished(view, url);
	}



}
