
ActiveSupport::Reloader.to_prepare do
  EgovUtils::User.default_role = 'candidate'
end

require 'azahara_schema/tiles_output'
ActiveSupport::Reloader.to_prepare do
  AzaharaSchema::Outputs.register(AzaharaSchema::TilesOutput)
end
