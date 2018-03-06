require 'helpers/entities'

RSpec.describe Reality::Describers::Wikipedia, 'entities' do
  let(:describer) { described_class.new }

  extend EntitiesHelper

  entity('Argentina')
  entity('Chewbacca')
  entity('Mammoth')
end