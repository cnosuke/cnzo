require 'sinatra'
# if development?
#   require 'sinatra/reloader'
#   require 'pry'
# end

require 'digest/md5'
require './s3_uploader'

DL_HOST = ENV['DL_HOST']

EXT_WHITELIST = %w(
  png
  gif
  jpg
).inject([]){ |m,x| m.push(x,x.upcase) }

error 403 do
  "Access forbidden\n"
end

def authorize(key)
  (ENV['AUTHORIZE_KEYS'] || '').gsub(/\s/,'').split(',').include?(key)
end

get '/' do
  'index'
end

post '/upload' do
  return 403 unless authorize(request.env['HTTP_X_FAZO_TOKEN'])

  image_file = params['image_file'][:tempfile]
  hash = Digest::MD5.hexdigest(image_file.read)
  image_file.seek(IO::SEEK_SET)

  ext = params['ext'] || 'png'
  exit unless EXT_WHITELIST.include?(ext)

  fname = "#{hash}.#{ext}"
  s3key = "img/#{fname}"
  S3Uploader.put(s3key, image_file)

  status 200
  body "#{DL_HOST}/#{s3key}"
end
