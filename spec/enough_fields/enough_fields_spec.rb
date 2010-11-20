require "spec_helper"

describe EnoughFields do

  before :all do
    User.create(:login => 'flyerhzm', :email => 'flyerhzm@gmail.com')
    User.create(:login => 'richard', :email => 'richard@gmail.com')
    User.create(:login => 'test', :email => 'test@gmail.com')
  end

  it "should" do
    EnoughFields.enable = true
    EnoughFields.growl = true
    EnoughFields.start_request
    Thread.current[:monit_hash] = EnoughFields::MonitHash.new
    p User.all.collect(&:email)
    # User.all.to_a
    EnoughFields.end_request
    EnoughFields.perform_out_of_channel_notifications
  end
end
