require_relative "device"

PAUSE_BEFORE_SHOT = 5

list_devices_cmd = "#{ENV["ANDROID_HOME"]}/platform-tools/adb devices|tail -n +2|cut -f1"
devices = `#{list_devices_cmd}`.split("\n")

if devices.count==0
	puts "Please connect devices to this machine and turn on their debug mode."
	exit
end

start_time = DateTime.now.strftime "%Y%m%d-%H%M"

url = ARGV[0]

threads = [];
devices.each do |serial|
	threads << Thread.new{
		d = Device.new serial

		launch_browser_cmd = "#{d.adb_command} shell am start -a android.intent.action.VIEW #{url}"
		system(launch_browser_cmd)
		sleep(PAUSE_BEFORE_SHOT)
		model = d.model
		screenshot_path = "screenshot/#{model}"
		`mkdir -p #{screenshot_path}`

		d.screenshot(:name=>"#{screenshot_path}/screenshot.png")
		puts "screenshot taken for #{url} on device #{model}(#{serial})"
	}	
end

threads.each { |t|
	t.join
}
