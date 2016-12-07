#!/usr/bin/ruby
#
# Run rspec for a host and report its result

require 'json'
require 'net/http'
require 'date'

FOREMAN_URL = ENV['FOREMAN_URL'] || 'http://localhost:3000'
USER = ENV['FOREMAN_USER'] || 'admin'
PASSWORD = ENV['FOREMAN_PW']


class Report
  def initialize(json_file)
    @report = JSON.parse(File.read(json_file))
    @report['host'] = File.basename(json_file, '.json')
    @report['reported_at'] = DateTime.now
  end

  def json
    { 'serverspec_report': @report }.to_json
  end
end


class ReportServer
  @@uri = URI("#{FOREMAN_URL}/api/v2/tests/serverspec_reports")

  def initialize
    @http = Net::HTTP.new(@@uri.host, @@uri.port)
  end
  
  def post(report)
    req = Net::HTTP::Post.new(@@uri,
                              'Content-Type' => 'application/json')
    req.basic_auth USER, PASSWORD
    req.body = report.json
    @http.request(req)
  end
end


class ServerspecRunner
  def initialize(host)
    @host = host
  end 

  def run()
    out = "#{@host}.json"
    File.unlink(out) rescue true
    system("rake spec:#{@host}")
    out
  end
end


if __FILE__ == $0
  host = ARGV[0] or abort("No hostname given")
  out = ServerspecRunner.new(host).run()
  report = Report.new(out)
  puts ReportServer.new().post(report)
end

