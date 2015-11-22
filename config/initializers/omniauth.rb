OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do 
	provider :facebook, "456395417884604", "bdf3956aef24e652c586f3739e18f8f8"
end