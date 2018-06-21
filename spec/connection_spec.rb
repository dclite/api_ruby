require 'spec_helper'

describe DCLite::Connection do
  let(:connection) { DCLite::Connection.new('1', '2') }

  before(:each) do
    stub_connection = Faraday.new do |builder|
      # builder.response :logger
      builder.response :json

      builder.adapter :test do |stubs|
        stubs.post("/", {username: '1', password: '2', method: 'get_good', param: 'value'} ) do
          [200, {}, {
            'response' =>
              {
                'msg' => { 'text' => "OK", 'err_code' => 0 },
                'data' => { 'ok' => "ok" }
              }
          }]
        end

        stubs.post("/", {username: '1', password: '2', method: 'get_bad', param: 'value'} ) do
          [200, {}, {
            'response' =>
              {
                'msg' => { 'text' => "Error", 'err_code' => 1 },
                'data' => { 'ok' => "ok" }
              }
          }]
        end

        stubs.post("/", {username: '1', password: '2', method: 'get_none', param: 'value'} ) do
          [200, {}, {
            'response' =>
              {
                'msg' => { 'text' => "Error", 'err_code' => 4 },
                'data' => { 'ok' => "ok" }
              }
          }]
        end
      end
    end

    expect(connection).to receive(:connection).and_return(stub_connection)
  end

  describe "#call_method" do
    it "returns response data" do
      expect(connection.call_method('get_good', {param: 'value'})).to eq('ok' => "ok")
    end

    it "raises error when bad response received" do
      expect { connection.call_method('get_bad', {param: 'value'}) }.to raise_error(DCLite::ApiException)
    end

    it "raises no_data error when bad response received" do
      expect { connection.call_method('get_none', {param: 'value'}) }.to raise_error(DCLite::NoDataException)
    end
  end
end
