require 'Httparty'
require 'nokogiri'
require 'active_support/core_ext/hash/conversions'

@cookie = "B=/"

def show(response)
  puts response.body,puts "\n"
  puts response.code,puts "\n"
  puts response.message,puts "\n"
  puts @cookie,puts "\n"
  puts response.headers.inspect,puts "\n\n\n\n"
end

#
# Get Wifi Information
#

response = HTTParty.get( 'https://gmp.oracle.com/captcha/files/airespace_pwd.txt', :headers => { 'Cookie' => @cookie }, :follow_redirects => false )
location = response.headers["location"]
@cookie = response.headers['set-cookie']

# show(response)

#
# Follow Redirect to Login Screen
#

response = HTTParty.get( location, :headers => { 'Cookie' => @cookie }, :follow_redirects => false )
@cookie = response.headers['set-cookie']

# show(response)

#
# Parse all of the variables and submit
#

dom = Nokogiri::XML(response.body)
hash = Hash.from_xml(dom.to_s)

site2pstoretoken = hash["html"]["body"]["form"]["input"]["value"]
v = hash["html"]["body"]["form"]["input"]["input"]["value"]
request_id = hash["html"]["body"]["form"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["value"]
oam_req = hash["html"]["body"]["form"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["input"]["value"]

query = {
  :ssousername => ARGV[0],
  :password => ARGV[1],
  :v => v,
  :request_id => request_id,
  :OAM_REQ => oam_req,
  :site2pstoretoken => site2pstoretoken
}

response = HTTParty.post( 'https://login.oracle.com/oam/server/sso/auth_cred_submit', :query => query, :follow_redirects => false )
location = response.headers["location"]
@cookie = response.headers['set-cookie']

# show(response)

#
# Follow Redirect to Accecpt Screen
#

response = HTTParty.get( location, :headers => { 'Cookie' => @cookie }, :follow_redirects => false )
location = response.headers["location"]
@cookie = response.headers['set-cookie']

# show(response)

#
# Follow Follow Redirect back to original request
#

response = HTTParty.get( location, :headers => { 'Cookie' => @cookie } )

puts response
