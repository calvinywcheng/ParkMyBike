OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do 
	provider :facebook, "706274382806077", "0ebecdc770dc8f7e6c04c266ec2afc23", scope: "publish_actions"
end