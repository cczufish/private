package com.hiwifi.app.views;

import android.app.Activity;
import android.content.Context;
import android.util.AttributeSet;
import android.view.Display;
import android.widget.RelativeLayout;

public class InputMethodRelativeLayout extends RelativeLayout {
	private int width;

	private int height;

	private int screenHeight;

	private boolean sizeChanged = false;

	private OnSizeChangedListener onSizeChangedListener;

	public InputMethodRelativeLayout(Context context, AttributeSet attrs,
			int defStyle) {
		super(context, attrs, defStyle);
		Display localDisplay = ((Activity) context).getWindowManager()
				.getDefaultDisplay();
		screenHeight = localDisplay.getHeight();
		// TODO Auto-generated constructor stub
	}

	public InputMethodRelativeLayout(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
	}

	public InputMethodRelativeLayout(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		// TODO Auto-generated method stub
		this.width = widthMeasureSpec;
		this.height = heightMeasureSpec;
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
	}

	@Override
	protected void onSizeChanged(int w, int h, int oldw, int oldh) {
		// TODO Auto-generated method stub
		if (this.onSizeChangedListener != null && w == oldw && h != 0
				&& oldh != 0) {
			if (h >= oldh || (Math.abs(h - oldh) <= 1 * this.screenHeight / 4)) {
				sizeChanged = false;
			} else if (h <= oldh
					|| (Math.abs(h - oldh) <= 1 * this.screenHeight / 4)) {
				sizeChanged = true;
			}
			this.onSizeChangedListener.onSizeChange(sizeChanged,h);
			measure(this.width - w + getWidth(), this.height - h + getHeight());
		}
	}

	/**
	 * @Title: setOnSizeChangedListener
	 * @Description: Ϊ��ǰ��������onSizeChanged������
	 * @param sizeChangedListener
	 * @return void
	 */
	public void setOnSizeChangedListener(
			OnSizeChangedListener sizeChangedListener) {
		this.onSizeChangedListener = sizeChangedListener;
	}

	public abstract interface OnSizeChangedListener {

		public abstract void onSizeChange(boolean flag,int h);
	}
}