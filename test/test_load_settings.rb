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

    describe 'variables substitution' do
      it 'should substitute variables' do
        Choices.load_settings(@without_local, 'defaults').email.must_equal 'Defaults@localhost'
        Choices.load_settings(@without_local, 'test').email.must_equal 'Test@localhost'
        Choices.load_settings(@without_local, 'production').email.must_equal 'Production@production.com'
      end

      it 'should substitute from local settings too' do
        Choices.load_settings(@with_local, 'defaults').email.must_equal 'Defaults@localhost'
        Choices.load_settings(@with_local, 'production').email.must_equal 'Production local@production.local'
      end

      it 'should raise an exception when substitution key does not exist' do
        error = lambda {
          Choices.load_settings(@without_local, 'index_error')
        }.must_raise(IndexError)
        error.message.must_equal %{Missing key for "%{nonexistent.key}" in `#{@without_local}'}
      end
    end

    it 'should raise an exception if the environment does not exist' do
      error = lambda {
        Choices.load_settings(@with_local, 'nonexistent')
      }.must_raise(IndexError)
      error.message.must_equal %{Missing key for "nonexistent" in `#{@with_local}'}
    end
  end
end
