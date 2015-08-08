require 'sinatra'
require "sinatra/reloader" if development?
require 'dotenv'
Dotenv.load

require 'digest/md5'

error 403 do
  "Access forbidden\n"
end

def authorize(key)
  ENV['AUTHORIZE_KEYS'].gsub(/\s/,'').split(',').include?(key)
end

get '/' do
  'index'
end

post '/upload' do
  return 403 unless authorize params['key']
  id = params['id']
  imagedata = params['imagedata'][:tempfile].read
  hash = Digest::MD5.hexdigest(imagedata)

  ext = params['ext'] || 'png'
  exit unless ['png','gif','jpg'].include?(ext)

  fname = "#{hash}.#{ext}"
  File.open("../data/#{fname}","w").print(imagedata)
  status 200
  headers 'X-Gyazo-Id' => '000'
  body "https://img.cnosuke.com/d/#{hash}.#{ext}"
end
