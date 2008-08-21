require File.dirname(__FILE__) + '/helper'

context "Nested Params" do

  setup do
    Sinatra.application = nil
  end

  specify "destructures nested params" do
    get '/hi' do
      'Hello ' + params['person']['first_name']
    end

    get_it '/hi', 'person[first_name]' => 'Pat'
    should.be.ok
    body.should.equal 'Hello Pat'
  end

  specify "handles multiple params under the same nesting" do
    get '/hi' do
      'Hello ' + params['person']['first_name'] + ' ' + params['person']['last_name']
    end

    get_it '/hi', 'person[first_name]' => 'Pat', 'person[last_name]' => 'Maddox'
    should.be.ok
    body.should.equal 'Hello Pat Maddox'
  end

  specify "handles params multiple nestings deep" do
    get '/hi' do
      params
      'Hello ' + params['person']['name']['first'] + ' ' + params['person']['name']['last']
    end

    get_it '/hi', 'person[name][first]' => 'Pat', 'person[name][last]' => 'Maddox'
    should.be.ok
    body.should.equal 'Hello Pat Maddox'
  end

  specify "handles params of varying nesting levels" do
    get '/hi' do
      params
      'Hello ' + params['person']['name']['first'] + ' ' + params['person']['reputation']
    end

    get_it '/hi', 'person[name][first]' => 'Pat', 'person[reputation]' => 'awesome'
    should.be.ok
    body.should.equal 'Hello Pat awesome'
  end
end
