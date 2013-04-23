require_relative "device"
require 'optparse'

options = {}
 
optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: browse-and-capture.rb [options] [url1 url2 ...]"

  # Define the options, and what they do
  options[:urlfile] = nil
  opts.on( '-f', '--urlfile FILE', 'Read urls from FILE' ) do|file|
    options[:urlfile] = file
  end

  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

optparse.parse!

if(options[:urlfile]==nil && ARGV.count==0)
	puts optparse.banner
	exit
end

urls = [];
if options[:urlfile]!=nil
	file = File.open(options[:urlfile], "r")
	urls = file.read.split("\n")
	file.close
else
	urls = ARGV
end

PAUSE_BEFORE_SHOT = 5

list_devices_cmd = "#{ENV["ANDROID_HOME"]}/platform-tools/adb devices|tail -n +2|cut -f1"
devices = `#{list_devices_cmd}`.split("\n")

if devices.count==0
	puts "Please connect devices to this machine and turn on their debug mode."
	exit
end

start_time = DateTime.now.strftime "%Y%m%d-%H%M"

threads = [];
devices.each do |serial|
	threads << Thread.new{
		d = Device.new serial

		urls.each do |url|
			launch_browser_cmd = "#{d.adb_command} shell am start -a android.intent.action.VIEW #{url}"
			system(launch_browser_cmd)
			sleep(PAUSE_BEFORE_SHOT)
			model = d.model
			screenshot_path = "screenshot/#{start_time}/#{model}"
			`mkdir -p #{screenshot_path}`

			d.screenshot(:name=>"#{screenshot_path}/screenshot.png")
			puts "screenshot taken for #{url} on device #{model}(#{serial})"
		end
	}	
end

threads.each { |t|
	t.join
}
