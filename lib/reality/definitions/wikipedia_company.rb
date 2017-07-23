module Reality
  # @private
  module Company
    extend Entity::WikipediaType

    infobox_name 'Infobox company'

    infobox 'industry', :industry, [:string], parse: ->(var) { var.text.split(/\s*,\s*/) }
    infobox 'founders', :founders, [:string], parse: ->(var) { var.text.split(/\s*,\s*/) }
  end
end
