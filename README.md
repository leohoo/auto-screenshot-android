auto-screenshot-android
=======================

Take screenshots of all connected android devices.

Prepare the environment:

- Install [android sdk](http://developer.android.com/sdk/index.html) if you have not installed it yet.
- Set ```ANDROID_HOME=<path-to-android-sdk>```
- Install the package:

```
git clone git@ghe.amb.ca.local:liu-wei-gn/auto-screenshot-android.git
cd auto-screenshot-android
bundle install
```

- Connect android devices to your machine through usb.
- Turn on debug mode of the devices, check the "Stay awake" option.

Run the following command to take screenshots of all the devices:

```
ruby browse-and-capture.rb "http://24log.jp/"
```

