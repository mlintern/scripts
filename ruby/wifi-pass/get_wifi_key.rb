# encoding: utf-8
# frozen_string_literal: true

require 'httparty'
require 'nokogiri'
require 'active_support/core_ext/hash/conversions'
require 'redis'

# OracleSSO Class
class OracleSSO
  USER = ARGV[0]
  PASS = ARGV[1]
  AUTH_COOKIE_KEY = 'oracle_sso_cookie'.freeze

  def initialize
    @redis = Redis.new
    existing_cookie = nil # @redis.get(AUTH_COOKIE_KEY)
    @cookie = existing_cookie.nil? ? 'B=/' : existing_cookie
  end

  def exec_request(type, url, options = {})
    options[:follow_redirects] = false unless options.key?(:follow_redirects)
    options[:headers] = {} unless options.key?(:headers)
    options[:headers]['Cookie'] = @cookie

    response = HTTParty.send(type, url, options)

    if response.headers.key?('location') && !response.headers['location'].nil? && %r{^https:\/\/login.oracle.com}.match(response.headers['location'])
      # puts 'Auth required, doing flow'
      new_location = do_auth_flow(response)
      options[:follow_redirects] = true # Necessary because for some reason auth sends us to a non-ssl that will just 301
      options[:headers]['Cookie'] = @cookie # Refresh to latest cookie
      response = HTTParty.send(type, new_location, options)
    end

    response
  end

  private

  # Ripped from get-wifi-key.rb, mostly
  def do_auth_flow(response)
    location = response.headers['location']
    # @cookie = response.headers['set-cookie']

    # Follow Redirect to Login Screen
    response = HTTParty.get(location, headers: { 'Cookie' => @cookie }, follow_redirects: false)
    @cookie = response.headers['set-cookie']

    # Parse all of the variables and submit
    dom = Nokogiri::XML(response.body)
    dom.search('//comment()').remove
    hash = Hash.from_xml(dom.to_s)

    form = hash['html']['head']['body']['form']
    site2pstoretoken = form['input']['value']
    v = form['input']['input']['value']
    request_id = form['input']['input']['input']['input']['input']['input']['input']['input']['input']['input']['input']['input']['input']['input']['value']
    oam_req = form['input']['input']['input']['input']['input']['input']['input']['input']['input']['input']['input']['input']['input']['input']['input']['value']

    query = {
      ssousername: USER,
      password: PASS,
      v: v,
      request_id: request_id,
      OAM_REQ: oam_req,
      site2pstoretoken: site2pstoretoken
    }

    response = HTTParty.post('https://login.oracle.com/oam/server/sso/auth_cred_submit', query: query, follow_redirects: false)
    location = response.headers['location']
    @cookie = response.headers['set-cookie']

    # Follow Redirect to Accecpt Screen
    response = HTTParty.get(location, headers: { 'Cookie' => @cookie }, follow_redirects: false)
    location = response.headers['location']
    @cookie = response.headers['set-cookie']

    # puts "Got auth cookie #{@cookie}"
    @redis.set(AUTH_COOKIE_KEY, @cookie)

    # Return new forward
    location
  end
end

#
# Get Wifi Information
#

sso = OracleSSO.new
response = sso.exec_request('get', 'https://gmp.oracle.com/captcha/files/airespace_pwd.txt',
                            follow_redirects: false)
text = response.body
words = text.split(/\W+/)
extra = ARGV[2] || ''
words.each do |word|
  text.gsub!(word, extra + word) if word.length > 2
end

puts text
