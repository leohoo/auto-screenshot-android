require_relative "device"

PAUSE_BEFORE_SHOT = 5

devices = `adb devices|tail -n +2|cut -f1`.split("\n")
start_time = DateTime.now.strftime "%Y%m%d-%H%M"
screenshot_path = "screenshot/#{start_time}"

puts "screenshot will be put in #{screenshot_path}"

url = ARGV[0]

`mkdir -p #{screenshot_path}`

threads = [];
devices.each do |serial|
	threads << Thread.new{
		d = Device.new serial

		launch_browser_cmd = "#{d.adb_command} shell am start -a android.intent.action.VIEW #{url}"
		system(launch_browser_cmd)
		sleep(PAUSE_BEFORE_SHOT)
		model = d.model
		d.screenshot(:name=>"#{screenshot_path}/#{model}.png")
		puts "screenshot taken for #{url} on device #{model}(#{serial})"
	}	
end

threads.each { |t|
	t.join
}
