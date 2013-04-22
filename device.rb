require "calabash-android/operations"

class Device < Calabash::Android::Operations::Device

	def initialize(serial)
		super nil, serial, nil, nil, nil
		@model = "";
	end

	def model
		cmd = "#{adb_command} shell getprop ro.product.model"
		
		@model = `#{cmd}`.strip.sub(" ", "-") if(@model == "")
		
		@model
	end

end
