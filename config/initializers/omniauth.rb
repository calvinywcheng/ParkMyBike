OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do 
	provider :facebook, "693971600740452", "ea437f7d04ece97dec60c5c3cd090d1e", scope: "publish_stream"
end