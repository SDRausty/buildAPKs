// StarDate.java:
// StarDate Class for astronomical calculations.
// Copyright 1996 by Akkana Peck.
// You may use or distribute this code under the terms of the GPL v3 or any later version.
// Modified September 11, 2010 by Audrius Meskauskas: cleanup, modified to run on standard JRE 1.5+
// Ported to Android 28 Jun, 9 Jul 2014 by Audrius Meskauskas

package akk.astro.droid.moonphase;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import android.util.Log;

/** A date class which can calculate decimal years, and knows how
* to initialize itself from a string with decimal days, e.g.
* "1997 Apr 1.034170"
* Prints in a format like: "May 15 17:05:37 PDT 1997"
*/
@SuppressWarnings("serial")
class StarDate extends Date {

	StarDate() {
		super(System.currentTimeMillis());
	}

	StarDate(Date d) {
		super();
		setTime(d.getTime());
	}

	StarDate(String s) {
		super();
		setTime(s);
	}

	// setTime() may throw java.lang.illegalArgumentException
	void setTime(String s) {
		// see if the day is decimal:
		int dot = s.indexOf('.');
		if (dot > 0) {
			String maindate = s.substring(0, dot);
			String decimal = s.substring(dot);
			float correction = Float.valueOf(decimal).floatValue() * 24 * 60
					* 60 * 1000;

			// This is so stupid -- Date has a ctor to set itself
			// from a string, but has no way of setting itself
			// from a string after construction!  Sigh.
			Date stupid;
			try {
				stupid = new Date(maindate);
			} catch (java.lang.IllegalArgumentException e) {
				Log.w("moon", "Error initializing time!");
				stupid = new Date();
			}

			// Now add the appropriate decimal days:
			setTime(stupid.getTime() + (long) correction);
		} else {
			try {
				SimpleDateFormat stupidFormat = new SimpleDateFormat(
						"MMM dd HH:mm:ss Z yyyy");
				Date stupid = stupidFormat.parse(s);
				setTime(stupid.getTime());
			} catch (ParseException e) {
				throw new IllegalArgumentException(s, e);
			}
		}
	}

	public void addDays(int days) {
		setTime(getTime() + days * (24 * 60 * 60 * 1000));
	}

	public double daysSince(StarDate t) {
		return ((double) (getTime() - t.getTime())) / (24. * 60. * 60. * 1000.);
	}

	public double decimalYears() {
		// getTime() returns milliseconds Math.since Jan 1, 1970, so:
		return getTime() / 365.242191 / (24 * 60 * 60 * 1000);
	}

	public double getTimeAsDecimalDay() {
		Double doub = new Double((double) getTime() / (24. * 60. * 60. * 1000.));
		return doub.doubleValue() - doub.intValue();
	}

	//
	// toDateString() only prints the date, not day or time:
	//
	public String toDateString() {
		String s = super.toString();
		// we only want the second, third, and last words (month day year):
		int firstindex = s.indexOf(' ') + 1;
		int index = s.indexOf(' ', firstindex);
		index = s.indexOf(' ', index + 1);
		int yearindex = s.lastIndexOf(' ');
		return s.substring(firstindex, index) + s.substring(yearindex);
	}

	//
	// toString() prints the date and time, but not day of the week
	//
	public String toString() {
		String s = super.toString();
		// we want everything except the first word:
		int firstindex = s.indexOf(' ') + 1;
		return s.substring(firstindex);
	}
}
