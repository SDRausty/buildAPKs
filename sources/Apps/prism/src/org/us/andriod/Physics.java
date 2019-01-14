/*
 Ray diagram applet
 Copyright (C) 2009 Carlo Baracco

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

 Originated from  http://sourceforge.net/projects/physicsandmatha/files/ (RayDiagramsApplet.tar.gz 2009-05-01)

 Minor cleanup, image loading rewritten, plotlib size reduced in 10 August 2010 by Audrius Meskauskas
 Port to Android 27 November 2011 by Audrius Meskauskas, further fixes 27 January 2016.
 */
package org.us.andriod;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;

/**
 * The class that is used to calculate all physics involved in the application
 *
 * @author Carlo Barraco
  */
public class Physics {

	/**
	 * Optical object, either object or its image.
	 */
	public class OObject {
	
		float x;
		float y;
	
		/**
		 * The distance from the reflection medium
		 * @return The distance from the reflection medium
		 */
		public float getDistance() {
			return (lens.x - this.x);
		}
	
		public float getHeight() {
			return Math.abs(lens.y - this.y);
		}
		
		public boolean headDown() {
			return this.y > lens.y;
		}
	}

	/**
	 * This enum defines which demo actually runs.
	 */
	public Reflection state = Reflection.NOT_SET;

	/**
	 * Paint that is used to draw rays.
	 */
	Paint ray;
	
	/**
	 * Paint that is used to draw ray continuations.
	 */
	Paint rayContinuation;

	public Physics() {
		ray = new Paint();
		rayContinuation = new Paint();
		ray.setColor(Color.GREEN);
		rayContinuation.setColor(Color.GREEN);
		ray.setStrokeWidth(3);
	}

	/** Curvature length */
	public int rC = 120;
	
	/** Focal length */
	public int rF = rC / 2;
	
    /**
     * The image (coordinates reflect point above principal axis, another point is on the principal axis.
     */
	public OObject image = new OObject();
	
	/**
	 * The object (coordinates reflect point above principal axis, another point is on the principal axis.
	 */
	public OObject object = new OObject();
	
	/**
	 * The lens or mirror, coordinates reflect the point at the principal axis where the optical device is
	 * located. 
	 */
	public OObject lens = new OObject();
	
	public void setCurvatureLength(int cl) {
		rC = cl;
		rF = cl/2;
	}

	/**
	 * Moves the image to the appropriate place with 
	 */
	public void moveImage() {
		final float rI = image.getDistance();
		final float rO = object.getDistance();
		final float hO = object.getHeight();

		switch (state) {
		case CONVERGING_MIRROR:
			image.x = lens.x
					- (1.0f / (1.0f / rF - 1.0f / rO));
			if (object.y < lens.y) {
				image.y = lens.y
						- (-(rI / rO) * hO);
			} else {
				image.y = lens.y
						+ (-(rI / rO) * hO);
			}
			break;
		case DIVERGING_MIRROR:
			image.x = (lens.x - (1.0f / ((1.0f / (-rF)) - (1.0f / rO))));
			if (object.y < lens.y) {
				image.y = lens.y
						- (-(rI / rO) * hO);
			} else {
				image.y = lens.y
						+ (-(rI / rO) * hO);
			}
			break;
		case CONVERGING_LENS:
			if (object.x < lens.x) {
				image.x = lens.x
						+ (1.0f / (1.0f / rF - 1.0f / rO));
			} else {
				image.x = lens.x
						+ (1.0f / (1.0f / -rF - 1.0f / rO));
			}
			if (object.y < lens.y) {
				image.y = lens.y
						+ (-(rI / rO) * hO);
			} else {
				image.y = lens.y
						- (-(rI / rO) * hO);
			}
			break;
		case DIVERGING_LENS:
			if (object.x < lens.x) {
				image.x = lens.x
						+ (1.0f / (1.0f / -rF - 1.0f / rO));
			} else {
				image.x = lens.x
						+ (1.0f / (1.0f / rF - 1.0f / rO));
			}
			if (object.y < lens.y) {
				image.y = lens.y
						+ (-(rI / rO) * hO);
			} else {
				image.y = lens.y
						- (-(rI / rO) * hO);
			}
		}
	}

	/**
	 * Draws the rays onto the Canvas
	 * @param g The canvas to draw on
	 */
	public void drawRays(Canvas g) {
		int s = image.x < lens.x ? 1 : -1;

		drawRay(g, object.x, object.y, lens.x, object.y, true);
		drawRay(g, lens.x, object.y, image.x, image.y);
		drawRay(g, object.x, object.y, lens.x, image.y, true);
		drawRay(g, image.x, image.y, lens.x, image.y);
		drawRay(g, object.x, object.y, lens.x, lens.y, true);
		drawRay(g, lens.x, lens.y, image.x, image.y);

		if (state == Reflection.DIVERGING_LENS
				|| state == Reflection.DIVERGING_MIRROR) {
			rextend(image.x, image.y, lens.x, object.y, g);
			rextend(image.x, image.y, lens.x, image.y, g);
			rextend(image.x, image.y, lens.x, lens.y, g);
		} else if (state == Reflection.CONVERGING_LENS
				&& Math.abs(lens.x - object.x) < rF) {
			rextend(image.x, image.y, lens.x, lens.y, g);
		} else if (state == Reflection.CONVERGING_MIRROR
				&& Math.abs(lens.x - object.x) < rF) {
			rextend(image.x, image.y, lens.x, object.y, g);
			rextend(image.x, image.y, lens.x, image.y, g);
			rextend(image.x, image.y, lens.x, lens.y, g);
		}

		// Draw ray continuation that crosses the focal point.
		Paint p = new Paint();
		p.setColor(Color.LTGRAY);

		switch (state) {
		case DIVERGING_LENS:
			g.drawLine(lens.x + s * rF, lens.y, lens.x, image.y, p);
			break;
		case CONVERGING_LENS:
			if (Math.abs(lens.x - object.x) < rF) {
				g.drawLine(lens.x - s * rF, lens.y, object.x, object.y, p);
				drawRay(g, lens.x, object.y, lens.x + s * rF, lens.y, true);
				rextend(lens.x, object.y, lens.x + s * rF, lens.y, g);
                rextend(image.x, image.y, lens.x, image.y, g);
				rextend(lens.x, object.y, rF, 0, g);
			}
			break;

		case DIVERGING_MIRROR:
			g.drawLine(lens.x - s * rF, lens.y, lens.x, image.y, p);

		default:
		}
	}

	/**
	 * Draw extension of the ray, starting from where the ray specified by coordinates would end.
     */
	void rextend(float xa, float ya, float cx, float cy, Canvas g) {
		float dx = xa - cx;
		float dy = ya - cy;
		drawRay(g, cx, cy, cx - 20 * dx, cy - 20 * dy); 
	}

	void drawRay(Canvas g, float x1, float y1, float x2, float y2) {
		drawRay(g, x1, y1, x2, y2, false);
	}

	void drawRay(Canvas g, float x1, float y1, float x2, float y2, boolean forceRay) {
		boolean r = forceRay;
		if (!r) {
			r = (x1 < lens.x || x2 < lens.x);
			if (state == Reflection.CONVERGING_LENS
					|| state == Reflection.DIVERGING_LENS)
				r = !r;
		}

		Paint p = r ? ray : rayContinuation;
		g.drawLine(x1, y1, x2, y2, p);
	}
}

