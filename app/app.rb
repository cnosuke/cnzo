require 'sinatra'
require "sinatra/reloader" if development?
require 'dotenv'
Dotenv.load

require 'digest/md5'
require './s3_uploader'

EXT_WHITELIST = %w(
  png
  gif
  jpg
).inject([]){ |m,x| m.push(x,x.upcase) }

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
  image_file = params['imagedata'][:tempfile]
  hash = Digest::MD5.hexdigest(image_file.read)
  image_file.seek(IO::SEEK_SET)

  ext = params['ext'] || 'png'
  exit unless EXT_WHITELIST.include?(ext)

  fname = "#{hash}.#{ext}"
  s3key = "d/#{fname}"
  S3Uploader.put(s3key, image_file)

  status 200
  headers 'X-Gyazo-Id' => '000'
  body "https://img.cnosuke.com/#{s3key}"
end
