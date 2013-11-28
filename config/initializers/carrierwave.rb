CarrierWave.configure do |config|
	config.asset_host = "http://d154rvuufl6jl1.cloudfront.net"

	config.fog_credentials = {
        :provider => "AWS",
        :aws_access_key_id => "AKIAJUJWBWRZ7T4NY4IA",
        :aws_secret_access_key => "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"
    }
    config.fog_directory = "famru_testing"
    config.fog_attributes = {'Expires' => 99.years.from_now.httpdate }
end

