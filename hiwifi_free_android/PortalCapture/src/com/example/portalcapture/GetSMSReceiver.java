package com.example.portalcapture;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


import android.app.ActivityManager;
import android.app.ActivityManager.RunningTaskInfo;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences.Editor;
import android.os.SystemClock;
import android.telephony.SmsMessage;
import android.text.TextUtils;

public class GetSMSReceiver extends BroadcastReceiver {

	private static GetSmsListener listener = null;
	private static GetSmsLoadingListener listen = null;

	public static void setListener(GetSmsListener list) {
		GetSMSReceiver.listener = list;
	}
	
	public static void setMessageListener(GetSmsLoadingListener list) {
		GetSMSReceiver.listen = list;
	}

	@Override
	public void onReceive(Context context, Intent intent) {

		Object[] messages = (Object[]) intent.getExtras().get("pdus");
		for (Object message : messages) {
			SmsMessage sms = SmsMessage.createFromPdu((byte[]) message);
			String content = sms.getMessageBody();// 
//
//			SimpleDateFormat format = new SimpleDateFormat(
//					"yyyy-MM-dd HH:mm:ss");
//			String time = format.format(date);
//			String decodeMessage = decodeMessage(content);
			String matcherMessage = matcherMessage(content); // 
			if (!TextUtils.isEmpty(matcherMessage) && listener != null && isTopActivity(context, "com.hiwifi.helper.UI.RegisterOfPhoneActivity")) {
				listener.setVerifyCode(matcherMessage);
			}
			if (!TextUtils.isEmpty(matcherMessage) && listen != null &&  isTopActivity(context, "com.hiwifi.helper.UI.UserLoginActivity")) {
				listen.setVerifyCode(matcherMessage);
			}
		}

	}

	public String decodeMessage(String content) {
		String ret = "";
		if (content.contains("") || content.contains("hiwifi")) {
			int startlocation = content.indexOf(':');
			int endlocation = content.indexOf(',');
			if (startlocation < 0)
				startlocation = content.indexOf("极路由");
			if (endlocation < 0)
				endlocation = content.indexOf("bb");
			if ((startlocation > 0) && (endlocation > 0))
				ret = content.substring(startlocation + 1, endlocation).trim();
			if (ret.length() != 6)
				ret = "";
		}
		return ret;
	}

	public String matcherMessage(String str) {
		String ret = "";
		if (str.contains("aaa") || str.contains("hiwifi")
				|| str.contains("HiWiFi")) {
			String regex = "\\d*";
			Pattern p = Pattern.compile(regex);
			Matcher m = p.matcher(str);
			while (m.find()) {
				if (!"".equals(m.group()) && m.group().length() == 6) {
					ret = m.group();
					break;
				}
				// System.out.println("come here:" + m.group());
			}
		}
		return ret;
	}

	public String matcherMessageOther(String str) {
		String ret = "";
		String regex = "\\d*";
		Pattern p = Pattern.compile(regex);
		Matcher m = p.matcher(str);
		while (m.find()) {
			if (!"".equals(m.group()) && m.group().length() == 6) {
				ret = m.group();
				break;
			}
		}
		return ret;
	}
	
	
	
	public boolean isTopActivity(Context context, String activityName) {  
	    ActivityManager am = (ActivityManager) context  
	            .getSystemService(Context.ACTIVITY_SERVICE);  
	    List<RunningTaskInfo> runningTasks = am.getRunningTasks(100);  
	    for (RunningTaskInfo task : runningTasks) {  
	        if (task.topActivity.getClassName().equals(activityName)) return true;  
	    }  
	    return false;  
	}  

	public abstract interface GetSmsListener {
		public abstract void setVerifyCode(String code);
	}
	
	public abstract interface GetSmsLoadingListener {
		public abstract void setVerifyCode(String code);
	}
	

}
