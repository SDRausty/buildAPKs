package org.us.andriod;

import android.app.TabActivity; 
import android.content.Intent;
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
import android.content.res.Resources;
import android.os.Bundle;
import android.widget.TabHost;

/**
 * Prism demo application.
 */
public class An_StartActivity extends TabActivity {

	public static final String DEMOKEY = "demo";

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		Resources res = getResources(); // Resource object to get Drawables
		TabHost tabHost = getTabHost();
		TabHost.TabSpec spec; // Reusable TabSpec for each tab
		Intent intent; // Reusable Intent for each tab
		// Initialize a TabSpec for each tab and add it to the TabHost

		intent = new Intent().setClass(this, OtherActivity.class).putExtra(
				DEMOKEY, Reflection.CONVERGING_LENS);
		spec = tabHost.newTabSpec(Reflection.CONVERGING_LENS.toString())
				.setIndicator("", res.getDrawable(R.drawable.concavelensic))
				.setContent(intent);
		tabHost.addTab(spec);

		intent = new Intent().setClass(this, OtherActivity.class).putExtra(
				DEMOKEY, Reflection.DIVERGING_LENS);
		spec = tabHost.newTabSpec(Reflection.DIVERGING_LENS.toString())
				.setIndicator("", res.getDrawable(R.drawable.convexlensic))
				.setContent(intent);
		tabHost.addTab(spec);

		intent = new Intent().setClass(this, OtherActivity.class).putExtra(
				DEMOKEY, Reflection.CONVERGING_MIRROR);
		spec = tabHost.newTabSpec(Reflection.CONVERGING_MIRROR.toString())
				.setIndicator("", res.getDrawable(R.drawable.concavemirroric))
				.setContent(intent);
		tabHost.addTab(spec);

		intent = new Intent().setClass(this, OtherActivity.class).putExtra(
				DEMOKEY, Reflection.DIVERGING_MIRROR);
		spec = tabHost.newTabSpec(Reflection.DIVERGING_MIRROR.toString())
				.setIndicator("", res.getDrawable(R.drawable.convexmirroric))
				.setContent(intent);
		tabHost.addTab(spec);

		intent = new Intent().setClass(this, PrismActivity.class);
		spec = tabHost.newTabSpec("prism").setIndicator("",
				res.getDrawable(R.drawable.prism_tab)).setContent(intent);
		tabHost.addTab(spec);
		
		// These two are not finished.
		/*
		intent = new Intent().setClass(this, MicroscopeActivity.class);
		spec = tabHost.newTabSpec("microscope").setIndicator("",
				res.getDrawable(R.drawable.microscope)).setContent(intent);
		tabHost.addTab(spec);
		
		intent = new Intent().setClass(this, TelescopeActivity.class);
		spec = tabHost.newTabSpec("telescope").setIndicator("", 
				res.getDrawable(R.drawable.telescope)).setContent(intent);
		tabHost.addTab(spec);
		*/		

		intent = new Intent().setClass(this, ViewActivity.class).putExtra(
				"content", R.raw.documentation);
		spec = tabHost.newTabSpec("doc1").setIndicator("",
				res.getDrawable(android.R.drawable.ic_dialog_info)).setContent(
				intent);
		tabHost.addTab(spec);
 
		tabHost.setCurrentTab(0);
	}
}
