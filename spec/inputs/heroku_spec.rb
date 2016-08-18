require_relative "../spec_helper"

describe LogStash::Inputs::Heroku do

  before :each do
    @client = Heroku::Client.new("test", "pw")
    allow(Heroku::Client).to receive(:new).and_return(@client)
    allow(Heroku::Auth).to receive(:user).and_return("test")
    allow(Heroku::Auth).to receive(:password).and_return("pw")
    @input = LogStash::Plugin.lookup("input","heroku").new("app" => "test")
  end

  it "should register" do
    expect{ @input.register }.to_not raise_error
  end

  context "when operating" do

    before :each do
      @queue = []
    end

    it "should read logs" do 
      allow(@client).to receive(:read_logs).and_yield("LOG LOG LOG LOG")
      @input.run(@queue)
      expect(@queue.length).to eq 1
      expect(@queue.first.to_hash["message"]).to eq "LOG LOG LOG LOG"
    end
  end
end
