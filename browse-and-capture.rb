
devices = `adb devices|tail -n +2|cut -f1`.split("\n")

url = ARGV[0]

def screenshot(path, serial)
	cmd = "java -jar screenshotTaker.jar #{path} -s #{serial}"
	system( { "ANDROID_HOME"=>"/DevTools/adt-bundle-mac-x86_64/sdk/" }, cmd)
end

devices.each do |serial|
	launch_browser_cmd = "adb -s #{serial} shell am start -a android.intent.action.VIEW #{url}"
	system(launch_browser_cmd);
	sleep(5)
	screenshot("screenshot-#{serial}.png", serial)	
end

