/*
 Optics demo package
 Copyright (C) 2011 Audrius Meskauskas

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.

 Developed 27 November, 10 December 2011 by Audrius Meskauskas
*/

package org.us.andriod;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Point;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;

public class Prism extends View {

	int topAngle = 30;

	/**
	 * The top angle of the prism,
	 */
	double aa = Math.toRadians(topAngle);

	double tanAaHalf = Math.tan(Math.toRadians(topAngle / 2));

	/**
	 * Top
	 */
	Point A = new Point();

	/**
	 * Middle of the base
	 */
	Point AH = new Point();

	/**
	 * Left base point
	 */
	Point B1 = new Point();

	/**
	 * Right base point.
	 */
	Point B2 = new Point();

	/**
	 * Ray entry point.
	 */
	Point E = new Point();

	/**
	 * Ray exit point
	 */
	Point O = new Point();

	int h, l;

	int rayEntry;

	/**
	 * Optical density of the prism material.
	 */
	double n = 1.6;

	Paint bold = new Paint(); // new BasicStroke(3);
	Paint fine = new Paint();

	PrismActivity activity;

	public Prism(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	public Prism(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public Prism(Context context) {
		super(context);
	}

	/**
	 * Get the ray deviation of the prism.
	 * 
	 * @param a1 the entry angle (0 = right angle), radians
	 * 
	 * @return deviation angle radians
	 */
	public double dev(double a1) {
		a1 = Math.PI / 2 - a1;
		double sin_a1 = Math.sin(a1);
		double v = a1
				+ Math.asin(Math.sin(aa) * Math.sqrt(n * n - sin_a1 * sin_a1)
						- Math.cos(aa) * sin_a1) - aa;

		return v;
	}

	public double a2(double a1) {
		double v = Math.asin(n * Math.sin(aa - Math.asin(Math.sin(a1) / n)));
		return v;
	}

	public double beta1(double a1) {
		return Math.asin(Math.sin(a1) / n);
	}

	public double delta1(double a1) {
		return a1 - beta1(a1);
	}

	public void setRayEntry(int rayEntry) {
		this.rayEntry = rayEntry;
		invalidate();
	}

	boolean monochrome = false;

	protected void onDraw(Canvas g) {
		fine.setColor(Color.WHITE);
		fine.setStyle(Paint.Style.FILL);

		int width = getWidth();
		int height = getHeight();

		if (height > width)
			height = width;
		else if (width > height)
			width = height;

		// I do not think these lines below should be required
		// @TODO figure out that is wrong here.
		g.translate(width / 10, height / 10);
		g.scale(0.8f, 0.8f);
		g.save();

		fine.setColor(Color.YELLOW);

		A.x = width / 2;
		A.y = 0;

		h = height;

		AH.x = A.x;
		AH.y = h;

		l = (int) (h * tanAaHalf);

		B1.x = AH.x - l;
		B2.x = AH.x + l;

		B1.y = B2.y = h;

		E.x = (B1.x + A.x) / 2;
		E.y = (B1.y + A.y) / 2;

		O.x = (B2.x + A.x) / 2;
		O.y = (B2.y + A.y) / 2;

		line(g, B1, A, fine);
		line(g, A, B2, fine);
		line(g, B2, B1, fine);

		Paint paint = new Paint();

		paint.setColor(android.graphics.Color.YELLOW);
		paint.setStyle(Paint.Style.FILL);
		paint.setARGB((int) (100 * (n - 1)), 243, 229, 111);
		paint.setStyle(Paint.Style.FILL_AND_STROKE);
		paint.setAntiAlias(true);

		Path path = new Path();
		path.moveTo(B1.x, B1.y);
		path.lineTo(A.x, A.y);
		path.lineTo(B2.x, B2.y);
		path.close();

		g.drawPath(path, paint);

		fine.setAlpha(100);

		Canvas ggg = g;

		// Entering ray
		bold.setColor(monochrome ? Color.GREEN : Color.WHITE);
		bold.setStrokeWidth(3);
		float ra = (float) (-rayEntry + Math.toDegrees(aa / 2));
		ggg.rotate(ra, E.x, E.y);
		ggg.drawLine(E.x, E.y, E.x - width / 2, E.y, bold);

		// Continuation of the entering ray
		fine.setColor(Color.DKGRAY);
		ggg.drawLine(E.x, E.y, E.x + width, E.y, fine);
		ggg.restore();

		ll.x = ltop.x = l2.x = -1;
		
		double a1 = Math.toRadians(rayEntry);
		// double dev = delta1(a1);
		if (monochrome) {
			bold.setColor(Color.GREEN);
			drawRay(g, width, a1, true);
		} else if (n == 1.0) {
			bold.setColor(Color.WHITE);
			drawRay(g, width, a1, false);
		} else {
			double nn = n;

			for (float f = -0.5f; f <= 0.5f; f += 0.025f) {
				n = nn + (nn - 1.0) * f;
				// Approximate color.
				float w = f + 0.5f;

				float rr = 255 * (1.0f - w);
				float gg = 255 * (1.0f - Math.abs(0.5f - w));
				float bb = 255 * w;

				bold.setARGB(255, (int) rr, (int) gg, (int) bb);
				drawRay(g, width, a1, false);
			}
			n = nn;
		}
	}

	private Point ll = new Point();
	private Point ltop = new Point();
	private Point l2 = new Point();

	private void drawRay(Canvas g, int width, double a1, boolean continuation) {
		double a2 = a2(a1);

		double t1 = Math.PI / 2 - beta1(a1);
		double t2 = Math.PI / 2 - (aa - beta1(a1)); 

		double ab = distance(E, A);
		double ad = Math.sin(t1) * ab / Math.sin(t2); // The law of sines

		O.x = A.x + (int) (ad * Math.sin(aa / 2));
		O.y = A.y + (int) (ad * Math.cos(aa / 2));

		double ro = (a2 - aa / 2);
		if (Double.isNaN(ro))
			return;
			
		double r = 2* (width - O.x);
		double dh = (r * Math.tan(ro));		
		ll.x = (int) (O.x + r);
		ll.y = (int) (O.y + dh);
		
		if (O.y < B2.y && !Double.isNaN(dh)) {
			if (ltop.x > 0) {
				Path path = new Path();
				path.moveTo(O.x, O.y);
				path.lineTo(E.x, E.y);
				path.lineTo(ltop.x, ltop.y);
				path.close();
				g.drawPath(path, bold);
				
				path.reset();
				path.moveTo(O.x, O.y);
				path.lineTo(ltop.x, ltop.y);
				path.lineTo(l2.x, l2.y);
				path.lineTo(ll.x, ll.y);
				path.close();
				g.drawPath(path, bold);
				
			} else {
				line(g, E, O, bold);
				g.drawLine(O.x, O.y, ll.x, ll.y, bold);
			}
		}

		if (continuation && !Double.isNaN(dh))
			g.drawLine(O.x, O.y, O.x - width, (float) (O.y - dh), fine);

		ltop.x = O.x;
		ltop.y = O.y;
		l2.x = ll.x;
		l2.y = ll.y;
	}

	private double distance(Point a, Point b) {
		double xx = a.x - b.x;
		double yy = a.y - b.y;
		return Math.sqrt(xx * xx + yy * yy);
	}

	private void line(Canvas g, Point a, Point b, Paint p) {
		g.drawLine(a.x, a.y, b.x, b.y, p);
	}

	public void setDensity(double n) {
		this.n = n;
	}

	public void setTopAngle(int angle) {
		topAngle = angle;
		aa = Math.toRadians(topAngle);
		tanAaHalf = Math.tan(Math.toRadians(topAngle / 2));
	}

	public int getTopAngle() {
		return topAngle;
	}

	public double getDensity() {
		return n;
	}

	public int getRayEntry() {
		return rayEntry;
	}

	MotionEvent.PointerCoords p1 = new MotionEvent.PointerCoords();
	MotionEvent.PointerCoords p2 = new MotionEvent.PointerCoords();

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		if (event.getPointerCount() > 2) {
			monochrome = !monochrome;
		} else if (event.getPointerCount() > 1) {
			// Multi touch - resize the prism

			event.getPointerCoords(0, p1);
			event.getPointerCoords(1, p2);

			int a = (int) Math.abs((64 * (p1.x - p2.x) / (getWidth() / 2))) % 90;
			if (a > 10 && a < 80) {
				setTopAngle(a);
			}
		} else if (event.getX() < A.x) {
			
			double x = event.getX();
			double y = event.getY();
			
			double dx = x - E.x;
			double dy = y - E.y;
			
			double r = Math.sqrt(dx*dx + dy*dy);
			double ralpha = Math.asin(dy/r) + aa/2;
			int alpha = (int) Math.toDegrees(ralpha);
			
			// Single touch - change the entry angle
			if (alpha < 90 && alpha > -90) 
			{
				setRayEntry(alpha);
			}
		}
		invalidate();
		return true;
	}
}
