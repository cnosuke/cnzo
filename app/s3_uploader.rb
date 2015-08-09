require 'aws-sdk'
require 'dotenv'
Dotenv.load

# Regions and credentials are sets by dotenv automatically.
# http://docs.aws.amazon.com/sdkforruby/api/index.html

class S3Uploader
  DEFAULT_PUT_OPTIONS = {
    acl: 'public-read',
    server_side_encryption: 'AES256',
    storage_class: 'REDUCED_REDUNDANCY', # accepts STANDARD, REDUCED_REDUNDANCY, LT
  }

  def initialize(bucket_name = nil)
    @s3 = Aws::S3::Resource.new
    bkt = bucket_name || ENV['AWS_S3_BUCKET'] || (raise ArgumentError, 'S3 Bucket name is missing')
    @bucket = @s3.bucket(bkt)
  end

  def put(key, file, opts ={})
    obj = @bucket.object(key)
    put_opts = DEFAULT_PUT_OPTIONS.merge(opts).merge({ body: file })

    obj.put(put_opts)
  end

  def self.put(key, file, opts = {})
    new(opts[:bucket]).put(key, file, opts)
  end
end
