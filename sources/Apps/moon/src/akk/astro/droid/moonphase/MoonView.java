//
// MoonPhase.java:
// Calculate the phase of the moon.
//    Copyright 2014 by Audrius Meskauskas
// You may use or distribute this code under the terms of the GPLv3
//
package akk.astro.droid.moonphase;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.View;

public class MoonView extends View {
	public static final int moonColor = Color.WHITE;
	public static final int earthshineColor = Color.rgb(20,20,40);
	
	private final Paint paint = new Paint();
	private final MoonPhase moon = new MoonPhase();
	private Bitmap moonImage;
	private RectF oval = new RectF();

	public MoonView(Context context) {
		super(context);
		loadMoonImage(context);
	}

	private void loadMoonImage(Context context) {
		Drawable monDrawable = context.getResources().getDrawable(
				R.drawable.moon);
		int w = monDrawable.getIntrinsicWidth();
		int h = monDrawable.getIntrinsicHeight();
		moonImage = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
		Canvas canvas = new Canvas(moonImage);
		monDrawable.setBounds(0, 0, w, h);
		monDrawable.draw(canvas);
	}

	public MoonView(Context context, AttributeSet attrs) {
		super(context, attrs);
		loadMoonImage(context);
	}

	public MoonView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		loadMoonImage(context);
	}

	@Override
	protected void onDraw(Canvas g) {
		// Create new each time so it is update on every redraw.
		StarDate date = new StarDate();

		int width = getWidth();
		int height = getHeight();
		double phaseAngle = moon.getPhaseAngle(date);

		int xcenter = width / 2;
		int ycenter = height / 2;

		int moonradius;

		try {
			int w = moonImage.getWidth();
			int h = moonImage.getHeight();
			moonradius = (int) Math.min(w, h) / 2;
			int xslop = (width - w) / 2;
			if (xslop < 0)
				xslop = 0;
			int yslop = (height - h) / 2;
			if (yslop < 0)
				yslop = 0;
			g.drawBitmap(moonImage, xslop, yslop, paint);
		} catch (NullPointerException e) {
			moonradius = (int) (Math.min(width, height) * .4);
			// draw the whole moon disk, in moonColor:
			paint.setColor(moonColor);
			oval.set(xcenter - moonradius, ycenter - moonradius, xcenter
					+ moonradius, ycenter + moonradius);
			g.drawOval(oval, paint);
		}

		/* The phase angle is the angle sun-moon-earth,
		 so 0 = full phase, 180 = new.
		 What we're actually interested in for drawing purposes
		 is the position angle of the sunrise terminator,
		 which runs the opposite direction from the phase angle,
		 so we have to convert. */
		double positionAngle = Math.PI - phaseAngle;
		if (positionAngle < 0.)
			positionAngle += 2. * Math.PI;

		// Okay, now fill in the dark part.
		paint.setColor(earthshineColor);

		double cosTerm = Math.cos(positionAngle);
		//if (cosTerm < 0) cosTerm = -cosTerm;
		double rsquared = moonradius * moonradius;
		int whichQuarter = ((int) (positionAngle * 2. / Math.PI) + 4) % 4;
		int j;
		for (j = 0; j <= moonradius; ++j) {
			double rrf = Math.sqrt(rsquared - j * j);
			int rr = (int) (rrf + .5);
			int xx = (int) (rrf * cosTerm);
			int x1 = xcenter - (whichQuarter < 2 ? rr : xx);
			int w = rr + xx + 1;
			g.drawRect(x1, ycenter - j, w + x1, ycenter - j + 1, paint);
			g.drawRect(x1, ycenter + j, w + x1, ycenter + j + 1, paint);
		}
	}
}
