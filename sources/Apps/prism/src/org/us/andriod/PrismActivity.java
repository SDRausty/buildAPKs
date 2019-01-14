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

 Developed 27 November 2011 by Audrius Meskauskas
*/

package org.us.andriod;

import android.app.Activity;
import android.os.Bundle;
import android.widget.SeekBar;
import android.widget.TextView;

/**
 * Prism demo application.
 */
public class PrismActivity extends Activity  {

	/**
	 * Placeholder.
	 */
	abstract class ProgressAdapter implements SeekBar.OnSeekBarChangeListener {
		public void onStartTrackingTouch(SeekBar seekBar) {
		}

		public void onStopTrackingTouch(SeekBar seekBar) {
		}
	}

	/**
	 * The timer update frequency (can be high as timer does not run then the sensor is silent).
	 */
	public static final int TIMER_UPDATE = 10;

	SeekBar density;
	TextView mProgressText;
	Prism prism;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.prism);

		density = (SeekBar) findViewById(R.id.density);

		prism = (Prism) findViewById(R.id.prism);
		prism.activity = this;
		mProgressText = (TextView) findViewById(R.id.text);

		density.setOnSeekBarChangeListener(new ProgressAdapter() {
			public void onProgressChanged(SeekBar seekBar, int density,
					boolean fromTouch) {
				//mProgressText.setText("Angle "+angle+" density "+density);
				prism.setDensity(toDensity(density));
				update();
			}
		});

		density.setMax(100);

		prism.setRayEntry(20);
		prism.setTopAngle(60);
		prism.setDensity(toDensity(density.getProgress()));
	}

	void update() {
		prism.invalidate();
		mProgressText.setText(String.format(
				"Prism: \u03b1 %d \u00ba, n %.2f, \u00c2 %d \u00ba", prism
						.getRayEntry(), prism.getDensity(),
				prism.getTopAngle()));
	}

	private double toDensity(int density) {
		return (density + 100.0) / 100.0;
	}


}