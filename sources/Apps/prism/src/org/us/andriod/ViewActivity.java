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

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringWriter;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;

public class ViewActivity extends Activity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.help);

		WebView vw = (WebView) findViewById(R.id.help);

		InputStream in = getResources().openRawResource(getIntent().getIntExtra("content", -1));
		StringWriter builder = new StringWriter(1000);
		BufferedReader r = new BufferedReader(new InputStreamReader(in)); 
		String s;
		try {
			while ((s = r.readLine()) != null)
				builder.append(s);
			r.close();
		} catch (IOException e) {
			e.printStackTrace(new PrintWriter(builder));
		}

		vw.loadData(builder.toString(),
				"text/html", "UTF-8");
	}
}
