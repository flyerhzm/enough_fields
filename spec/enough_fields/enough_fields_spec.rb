require "spec_helper"

describe EnoughFields do

  before :all do
    User.create(:login => 'flyerhzm', :email => 'flyerhzm@gmail.com')
    User.create(:login => 'richard', :email => 'richard@gmail.com')
    User.create(:login => 'test', :email => 'test@gmail.com')
  end

  it "should" do
    EnoughFields.enable
    Thread.current[:monit_hash] = EnoughFields::MonitHash.new
    p User.all.collect(&:email)
    # User.all.to_a
    Thread.current[:monit_hash].each do |field, value|
      used, call_stack = *value
      puts field
      puts used
      unless used
        puts call_stack.join("\n")
      end
    end
  end
end
