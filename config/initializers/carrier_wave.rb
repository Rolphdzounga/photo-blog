if Rails.env.production?

	CarrierWave.configure do |config|

		config.fog_credentials = {

		:provider => 'AWS',
		#COMMENTS
		:aws_access_key_id => ENV['RP_ACCESS_KEY'],

		:aws_secret_access_key => ENV['RP_SECRET_KEY']

		:region => ENV['RP_REGION']

		}

		config.fog_directory = ENV['RP_BUCKET']

	end

end

