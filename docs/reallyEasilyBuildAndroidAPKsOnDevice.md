### Really Easily Build an Android APK on an Android Device (Smartphone or Tablet).

Install [Termux](https://termux.com/) on Android. Copy and paste the following into [Termux.](https://termux.com/) Run each of the following command lines separately, as running them all at once may generate errors. 

```
pkg up
pkg install aapt apksigner dx ecj findutils git
cd && git clone https://github.com/sdrausty/buildAPKs
./buildAPKs/scripts/build/buildMyFirstAPK.sh

```

This may take some time dependent on system speed and configuration for these command-line commands to complete. This means packages will probably be installed in [Termux.](https://termux.com/) and then one of the packages, `git` will fetch the buildAPKs repository, and then the last command. While it should be fairly self-explanatory, it builds one of the APKs in the showcase and places it in the Downloads folder using the tools that we have at our disposal today, in [Termux,](https://termux.com/) on-the-fly. Upon completion, output as follows will print onto the screen:


```
It is ready to be installed.
Install moon.apk from /sdcard/Download/ using your file manager from Android.
```

After you're done installing your first APK from the downloads directory (File Manager > Download (**Tap moon.apk with your finger to install**)); You can build hundreds of other exciting, amazing and beautiful APKs by running [shell scripts](https://www.google.com/search?q=shell+scripts) from the [sources directory.](https://github.com/sdrausty/buildAPKs/tree/master/sources)

Prefix these bash scripts by typing dot slash `./` in the [sources](https://github.com/sdrausty/buildAPKs/tree/master/sources) directory on your Android smartphone or tablet in Termux, i.e. type `./b` at the prompt ($), press TAB TAB (x2). The prompt should magically add `uild`; Then add a capitol `A` and small `l`. Press TAB TAB (x2) again. This should build the following command on the command line `./buildAll.sh` for you. Press enter (return) in `~/buildAPKs/sources/` and watch as hundreds of APKs build on device..

Your built APKs will be deposited into /sdcard/Download/builtAPKs for installing onto your smartphone or tablet through your file manager. Have fun and enjoy compiling and running these select APKs!

Please contribute to this project through either [the issues page](https://github.com/sdrausty/buildAPKs/issues) or [pull requests.](https://github.com/sdrausty/buildAPKs/pulls) Now you don't need Google Play, f-droid or others to enjoy wonderfully working APKs on your smartphone and tablet thanks to [Termux](./pages/asac) on [Android](https://source.android.com/) and [Github.](https://github.com)

Enjoy building these select APKs for Termux [projects,](https://github.com/sdrausty/buildAPKs/tree/master/sources) and please find the time to post your feelings [here,](https://github.com/sdrausty/buildAPKs/issues) or [at this wiki.](https://github.com/sdrausty/buildAPKs/wiki
)

![Prism Screenshot](./bitpics/prism.png)

#### When you press and momentarily hold the `volumeDown+power` buttons simultaneously on a smartphone, it takes a screenshot much like this one which shows the screen and the [the source code for this page](https://raw.githubusercontent.com/sdrausty/buildAPKs/master/docs/reallyEasilyBuildAndroidAPKsOnDevice.md) in [vim](http://www.vim.org/git.php) running on [Termux](./pages/asac) on [Android.](https://source.android.com/)

![Screenshot](./bitpics/reallyEasilyBuildAndroidAPKsOnDevice.png)

#### This animation was created with [imagemagick](https://sdrausty.github.io/pages/im.html) in [Termux](https://sdrausty.github.io/pages/asac.html) on an Android smartphone.

![Screenshot Animation](./bitpics/ps1.gif)

If you're confused by this page try [this link,](http://tldp.org/) or you might want to try [this one.](https://www.debian.org/doc/) Post your what you have found at [the wiki,](https://github.com/sdrausty/buildAPKs/wiki) [donate](https://sdrausty.github.io/pages/donate) and help [this website grow!](https://sdrausty.github.io/)

[Up One Level](./../)

🛳⛴🛥🚢🚤🚣⛵

