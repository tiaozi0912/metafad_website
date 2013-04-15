#S3_DEV_BUCKET="testing-item-photos-akiajbfjoiwfjzd6aypa"

S3_STG_BUCKET="staging-item-photos-akiajbfjoiwfjzd6aypa"
S3_PRO_BUCKET="metafad-production"
S3_DEV_BUCKET="MuseMe-images-bucket-akiajbfjoiwfjzd6aypa"

S3_PRO_KEY="AKIAJI5MZU6KL6UUYPSQ"
S3_PRO_SECRET="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"

S3_DEV_KEY="AKIAJBFJOIWFJZD6AYPA"
S3_DEV_SECRET="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"
	
if Rails.env.production?
	bucket = S3_PRO_BUCKET
	S3_KEY = S3_PRO_KEY
    S3_SECRET = S3_PRO_SECRET
else
	bucket = S3_DEV_BUCKET
	S3_KEY = S3_DEV_KEY
    S3_SECRET = S3_DEV_SECRET
end

S3_CREDENTIALS = {
  :access_key_id => S3_KEY,
  :secret_access_key => S3_SECRET,
  :bucket => bucket
}
