require "spec_helper"

module Rails
  def self.root
    File.dirname(__FILE__)
  end
end

describe EnoughFields do

  before :all do
    User.create(:login => 'flyerhzm', :email => 'flyerhzm@gmail.com', :first_name => 'richard', :last_name => 'huang')
    User.create(:login => 'richard', :email => 'richard@gmail.com', :first_name => 'richard', :last_name => 'huang')
    User.create(:login => 'test', :email => 'test@gmail.com', :first_name => 'test', :last_name => 'test')
  end

  it "should" do
    EnoughFields.enable = true
    EnoughFields.growl = true
    EnoughFields.start_request
    Thread.current[:monit_set] = EnoughFields::MonitSet.new
    p User.all.collect {|user| [user.email, user.login]}

    p User.only(:email).collect(&:email)
    # User.all.to_a
    if EnoughFields.notification?
      EnoughFields.perform_out_of_channel_notifications
    end
    EnoughFields.end_request
  end
end
