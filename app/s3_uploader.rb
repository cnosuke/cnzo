require 'aws-sdk'
require 'dotenv'
Dotenv.load

# Regions and credentials are sets by dotenv automatically.
# http://docs.aws.amazon.com/sdkforruby/api/index.html

class S3Uploader
  def initialize(bucket_name = nil)
    @s3 = Aws::S3::Resource.new
    bkt = bucket_name || ENV['AWS_S3_BUCKET'] || (raise ArgumentError, 'S3 Bucket name is missing')
    @bucket = @s3.bucket(bkt)
  end

  def put(key, file)
    obj = @bucket.object(key)
    obj.put(body: file)
  end

  def self.put(key, file, bucket: nil)
    new(bucket).put(key, file)
  end
end
