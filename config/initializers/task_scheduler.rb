require 'rubygems'
require 'rufus/scheduler'
require 'net/http'
require 'uri'

scheduler = Rufus::Scheduler.start_new

scheduler.every("5m") do 
	# send request to musememobile.com
	domain = "http://www.metafad.com"
	uri = URI.parse(domain)
	res = Net::HTTP.get_response(uri)
end