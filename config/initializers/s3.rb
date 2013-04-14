S3_KEY="AKIAJBFJOIWFJZD6AYPA"
S3_SECRET="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"
#S3_DEV_BUCKET="testing-item-photos-akiajbfjoiwfjzd6aypa"

S3_STG_BUCKET="staging-item-photos-akiajbfjoiwfjzd6aypa"
S3_PRO_BUCKET="MuseMe-images-bucket-akiajbfjoiwfjzd6aypa"

S3_DEV_BUCKET="MuseMe-images-bucket-akiajbfjoiwfjzd6aypa"


if Rails.env.development?
	bucket = S3_DEV_BUCKET
elsif Rails.env.production?
	bucket = S3_PRO_BUCKET
else
	bucket = S3_STG_BUCKET
end

S3_CREDENTIALS = {
  :access_key_id => S3_KEY,
  :secret_access_key => S3_SECRET,
  :bucket => bucket
}
