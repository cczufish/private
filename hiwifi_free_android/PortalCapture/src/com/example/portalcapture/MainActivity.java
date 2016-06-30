package com.example.portalcapture;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import android.os.Bundle;
import android.app.Activity;
import android.content.res.AssetManager;
import android.view.Menu;
import android.view.View;

public class MainActivity extends Activity {

	private MockRedirectWebView webView;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		webView = (MockRedirectWebView) findViewById(R.id.webview);

	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	@Override
	protected void onResume() {
		webView.loadUrl("http://m.baidu.com");
		super.onResume();
	}

//	public void alert(View view)
//	{
//		webView.execjs("var jsLoader=new JsLoader();"
//          +"jsLoader.onsuccess=function(){"
//          +"   x('123423232');"
//          +"}" 
//          +"  jsLoader.onfailure=function(){"
//           + "  alert(\"Œƒº˛‘ÿ»Î ß∞‹£°\");"
//     +"};jsLoader.load(\"http://m.hiwifi.com/x.js\");");
//	}

	public void loadjs(View view) {
//		webView.loadUrl("javascript:"
//		+ readStringFromFile("www/js/jsload.js"));
//				+ readStringFromFile("www/js/x.js"));
//		webView.execjs("HI_login_show(12321432)");
		webView.execjs(readStringFromFile("www/js/jquery_1.9.1.min.js"));
		webView.execjs(readStringFromFile("www/js/x.js"));
		webView.execjs("x(123)");
	}
	
	public void reload(View view)
	{
		webView.loadUrl("http://m.baidu.com");
	}
	

	String readStringFromFile(String path) {
		AssetManager assetManager = getAssets();
		try {
			assetManager.open(path);
			return readTextFile(assetManager.open(path));
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}

	}

	String readTextFile(InputStream inputStream) {
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		byte buf[] = new byte[1024];
		int len;
		try {
			while ((len = inputStream.read(buf)) != -1) {
				outputStream.write(buf, 0, len);
			}
			outputStream.close();
			inputStream.close();
		} catch (IOException e) {
		}
		return outputStream.toString();
	}
	


}
