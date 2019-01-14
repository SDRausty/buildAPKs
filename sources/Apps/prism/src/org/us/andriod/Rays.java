/*
 Ray diagram applet
 Copyright (C) 2009 Carlo Baracco, 2010 Audrius Meskauskas

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

 Minor cleanup, image loading rewritten, plotlib size reduced 10 August 2010 by Audrius Meskauskas
 Ghost added to indicate virtual image 19 December 2010 by Audrius Meskauskas
 Port to Android 27 November 2011 by Audrius Meskauskas
 F adjustment by multitouch December 7 by Audrius Meskauskas
*/
package org.us.andriod;
 
import org.us.andriod.R; 
import org.us.andriod.Physics.OObject;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;

/**
 * A class for handling all drawing involved in the program
 * 
 * @author Carlo Barraco
 * @author Audrius Meskauskas
 */
public class Rays extends View {

	Physics physics = new Physics();
	Point mouse;

	static Drawable imgConcaveMirror;
	static Drawable imgConvexMirror;
	static Drawable imgConcaveLens;
	static Drawable imgConvexLens;
	static Drawable imgVirtualImage;
	static Drawable imgFeather;
	static Drawable imgFeatherMirr;

	int fw;

	/**
	 * Initializes the variables needed and sets up the GridObject settings
	 */
	public Rays(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public Rays(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	public Rays(Context context) {
		super(context);
	}

	protected void setup() {
		// Images can be shared.
		if (imgVirtualImage == null) {
			imgConcaveMirror = getImage(R.drawable.concavemirror);
			imgConvexMirror = getImage(R.drawable.convexmirror);
			imgConcaveLens = getImage(R.drawable.concavelens);
			imgConvexLens = getImage(R.drawable.convexlens);

			// Ghost from http://commons.wikimedia.org/wiki/File:Rainbowghost.svg, public domain license.		
			imgVirtualImage = getImage(R.drawable.ghost);
			imgFeather = getImage(R.drawable.feather);
			imgFeatherMirr = getImage(R.drawable.feathermirr);
		}
		// Offset to center font (half char width)
		fw = 10;
		physics.setCurvatureLength(getWidth() / 4);
		resetObjectLocation();
	}

	public void resetObjectLocation() {
		mouse = new Point();
		mouse.x = getWidth() / 4;
		mouse.y = getHeight() / 4;
		invalidate();
	}

	private Drawable getImage(int image) {
		return getResources().getDrawable(image);
	}

	void updatePhysics() {
		physics.object.x = mouse.x;
		physics.object.y = mouse.y;
		physics.moveImage();
	}

	/**
	 * Draws the appropriate apparatus and Objects used in the program
	 * 
	 * @param g
	 *            The canvas to draw on
	 */
	public void onDraw(Canvas g) {
		if (mouse == null) {
			resetObjectLocation();
			setup();
		}

		final int w = this.getWidth();
		final int h = this.getHeight();

		physics.lens.x = w / 2;
		physics.lens.y = getHeight() / 2;

		Paint p = new Paint();
		p.setColor(Color.WHITE);

		physics.lens.x = w / 2;
		physics.lens.y = getHeight() / 2;

		updatePhysics();

		g.drawLine(0, physics.lens.y, w, physics.lens.y, p);

		if (physics.state == Reflection.CONVERGING_MIRROR
				|| physics.state == Reflection.DIVERGING_MIRROR)
			if (physics.object.x > physics.lens.x) {
				// Object other side of the mirror
				if (physics.state == Reflection.CONVERGING_MIRROR) {
					drawLens(g, imgConcaveMirror, w, h);
				} else if (physics.state == Reflection.DIVERGING_MIRROR) {
					drawLens(g, imgConvexMirror, w, h);
				}
				g.drawText("Move to left side of the mirror", 3, h / 3, p);
				return;
			}

		p.setColor(Color.GREEN);

		final float f = physics.lens.x - physics.rF - 3;
		final float ff = physics.lens.x - 3 + physics.rF;

		if (physics.state == Reflection.CONVERGING_MIRROR) {
			final float c = physics.lens.x - physics.rC - 3;
			ghostIfOpposite(g, h, false);
			drawLens(g, imgConcaveMirror, w, h);
			drawCriticalPoints(g, f, -1, c);
		} else if (physics.state == Reflection.DIVERGING_MIRROR) {
			final float c = physics.lens.x - 3 + physics.rC;
			ghostIfOpposite(g, h, false);
			drawLens(g, imgConvexMirror, w, h);
			drawCriticalPoints(g, -1, ff, c);
		} else {
			final float c = physics.lens.x + 3 - physics.rC;
			if (physics.state == Reflection.CONVERGING_LENS) {
				ghostIfOpposite(g, h, true);
				drawLens(g, imgConcaveLens, w, h);
				drawCriticalPoints(g, f, ff, c);
			} else if (physics.state == Reflection.DIVERGING_LENS) {
				ghostIfOpposite(g, h, true);
				drawGhost(g, h);
				drawLens(g, imgConvexLens, w, h);
				drawCriticalPoints(g, f, ff, c);
			}
		}
		physics.drawRays(g);

		drawObject(g, physics.image);
		drawObject(g, physics.object);
	}

	protected void drawObject(Canvas g, OObject image) {
		int h = (int) image.getHeight();
		int w = imgFeather.getMinimumWidth() * h
				/ imgFeather.getMinimumHeight();
		int y = (int) image.y;
		int root = (int) image.x - w / 2;
		if (image.headDown())
			drawImage(g, imgFeatherMirr, root, y - h, w, h);
		else
			drawImage(g, imgFeather, root, y, w, h);

	}

	protected void ghostIfOpposite(Canvas g, final int h, boolean invert) {
		boolean imgLeft = physics.image.x < physics.lens.x;
		boolean objLeft = physics.object.x < physics.lens.x;
		boolean draw = imgLeft != objLeft;
		if (invert)
			draw = !draw;
		if (draw)
			drawGhost(g, h);
	}

	protected void drawGhost(Canvas g, final int h) {
		// Virtual image - draw ghost.
		int width = imgVirtualImage.getMinimumWidth();
		int height = imgVirtualImage.getMinimumHeight();

		int gw = width / 2;
		int hw = 0;
		if (physics.image.y > h / 2) {
			// Image below the X line, draw the ghost above
			hw = -height;
		}
		drawImage(g, imgVirtualImage, (int) physics.image.x - gw, h / 2 + hw,
				width, height);
	}

	protected void drawLens(Canvas g, Drawable image, final int w, final int h) {
		final int iw = image.getMinimumWidth();
		drawImage(g, image, w / 2 - iw / 2, 5, iw, h - 5);
	}

	protected void drawCriticalPoints(Canvas g, final float f, final float ff,
			final float c) {
		Paint p = new Paint();
		p.setColor(Color.WHITE);
		g.drawText("C", c - fw, physics.lens.y - 10, p);
		g.drawLine(f + 3, physics.lens.y - 3, f + 3, physics.lens.y + 15, p);
		g.drawLine(c + 3, physics.lens.y - 3, c + 3, physics.lens.y + 15, p);

		if (f > 0) {
			g.drawText("F", f - fw, physics.lens.y - 10, p);
			g
					.drawLine(f + 3, physics.lens.y - 3, f + 3,
							physics.lens.y + 15, p);
		}

		if (ff > 0) {
			g.drawText(f > 0 ? "F'" : "F", ff, physics.lens.y - 10, p);
			g.drawLine(ff + 3, physics.lens.y - 3, ff + 3, physics.lens.y + 15,
					p);
		}
	}

	private void drawImage(Canvas g, Drawable img, int x, int y, int w, int h) {
		img.setBounds(x, y, x + w, y + h);
		img.draw(g);
	}

	public Reflection getState() {
		return physics.state;
	}

	/**
	 * Set the type of the demo. We do not need update/repaint functionality
	 * here as in Android port the role, if set, never changes (different
	 * tabs are used instead). The state is normally only set once, during
	 * the initial construction of the application.
	 */
	public void setState(Reflection state) {
		physics.state = state;
	}

	MotionEvent.PointerCoords p1 = new MotionEvent.PointerCoords();
	MotionEvent.PointerCoords p2 = new MotionEvent.PointerCoords();

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		if (event.getPointerCount() > 1) {
			// Multi touch - resize the prism

			event.getPointerCoords(0, p1);
			event.getPointerCoords(1, p2);

			int a = (int) Math.abs(p1.x - p2.x);
			physics.rF = a;
			physics.rC = 2 * a;

		} else {
			// Single touch
			mouse.x = (int) event.getX();
			mouse.y = (int) event.getY();
		}
		invalidate();
		return true;
	}
}
