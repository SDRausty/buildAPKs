//
// MoonPhase.java:
// Calculate the phase of the moon.
//    Copyright 1996 by Akkana Peck.
// You may use or distribute this code under the terms of the GPL.
//    Ported to Android 28 Jun 2014 by Audrius Meskauskas
//

package akk.astro.droid.moonphase;

// class MoonPhase
class MoonPhase {
	static final double DEG2RAD = Math.PI / 180;

	// convert degrees to a valid angle:
	double angle(double deg) {
		while (deg >= 360.)
			deg -= 360.;
		while (deg < 0.)
			deg += 360.;
		return deg * DEG2RAD;
	}

	// Return the phase angle for the given date, in RADIANS.
	// Equation from Meeus eqn. 46.4.
	double getPhaseAngle(StarDate date) {
		if (date == null) {
			date = new StarDate();
		}

		// Time measured in Julian centuries from epoch J2000.0:
		StarDate Tepoch = new StarDate("2000 January 1.5");
		double T = (date.decimalYears() - Tepoch.decimalYears()) / 100.;
		double T2 = T * T;
		double T3 = T2 * T;
		double T4 = T3 * T;

		// Mean elongation of the moon:
		double D = angle(297.8502042 + 445267.1115168 * T - 0.0016300 * T2 + T3
				/ 545868 + T4 / 113065000);
		// Sun's mean anomaly:
		double M = angle(357.5291092 + 35999.0502909 * T - 0.0001536 * T2 + T3
				/ 24490000);
		// Moon's mean anomaly:
		double Mprime = angle(134.9634114 + 477198.8676313 * T + 0.0089970 * T2
				- T3 / 3536000 + T4 / 14712000);

		return (angle(180 - (D / DEG2RAD) - 6.289 * Math.sin(Mprime) + 2.100
				* Math.sin(M) - 1.274 * Math.sin(2 * D - Mprime) - 0.658
				* Math.sin(2 * D) - 0.214 * Math.sin(2 * Mprime) - 0.110
				* Math.sin(D)));
	}
}
