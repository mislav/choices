gem 'minitest'
require 'minitest/autorun'
require 'choices'
require 'pathname'

describe Choices do
  before do
    path = Pathname.new(__FILE__)
    @without_local = path + '../settings/without_local.yml'
    @with_local = path + '../settings/with_local.yml'
  end

  describe 'when loading a settings file' do
    it 'should return a mash for the specified environment' do
      Choices.load_settings(@without_local, 'defaults').name.must_equal 'Defaults'
      Choices.load_settings(@without_local, 'production').name.must_equal 'Production'
    end

    it 'should load the local settings' do
      Choices.load_settings(@with_local, 'defaults').name.must_equal 'Defaults'
      Choices.load_settings(@with_local, 'development').name.must_equal 'Development'
      Choices.load_settings(@with_local, 'production').name.must_equal 'Production local'
    end
  end
end
