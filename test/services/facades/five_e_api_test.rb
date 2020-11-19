require 'test_helper'
require 'rest_client'

class FiveEApiTest < ActiveSupport::TestCase

  test 'get_spells should return the response when call is successfull' do
    mock = Minitest::Mock.new
    mock_response = Minitest::Mock.new

    mock.expect :get, mock_response, ['https://www.dnd5eapi.co/api/spells']

    RestClient.stub :get, mock_response do
      assert(Facades::FiveEApi.get_spells === mock_response)
    end
  end

  test 'get_spell should return the response when call is successfull and name type is used' do
    mock = Minitest::Mock.new
    mock_response = Minitest::Mock.new

    mock.expect :get, mock_response, ['https://www.dnd5eapi.co/api/spells/fireball']

    RestClient.stub :get, mock_response do
      assert(Facades::FiveEApi.get_spell('aCid aRRow','nAme') === mock_response)
    end
  end

  test 'get_spell should return the response when call is successfull and url type is used' do
    mock = Minitest::Mock.new
    mock_response = Minitest::Mock.new

    mock.expect :get, mock_response, ['https://www.dnd5eapi.co/api/spells/fireball']

    RestClient.stub :get, mock_response do
      assert(Facades::FiveEApi.get_spell('/api/spells/acid-arrow','uRl') === mock_response)
    end
  end

  test 'get_spell should return the response when call is successfull and index type is used' do
    mock = Minitest::Mock.new
    mock_response = Minitest::Mock.new

    mock.expect :get, mock_response, ['https://www.dnd5eapi.co/api/spells/fireball']

    RestClient.stub :get, mock_response do
      assert(Facades::FiveEApi.get_spell('acid-arrow','InDex') === mock_response)
    end
  end

  test 'get_spell should not return the response when incorrect value_type is used' do
    mock = Minitest::Mock.new
    mock_response = Minitest::Mock.new

    mock.expect :get, mock_response, ['https://www.dnd5eapi.co/api/spells/fireball']

    RestClient.stub :get, mock_response do
      err = assert_raises RuntimeError do
        Facades::FiveEApi.get_spell('acid-arrow', 'not index')
      end
      assert_match('Incorrect value type entered', err.message)
    end
  end
end
