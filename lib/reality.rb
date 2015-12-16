require 'infoboxer'

module Reality
  # basic functionality
  %w[measure].each do |mod|
    require_relative "reality/#{mod}"
  end

  # entities
  %w[country].each do |mod|
    require_relative "reality/#{mod}"
  end
end
