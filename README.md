EnoughFields
============

EnoughFields helps you to use specified fields for mongoid.

Best practice is to use EnoughFields in development mode or custom mode (staging, profile, etc.).

Usage
-----

EnoughFields won't do ANYTHING unless you tell it to explicitly. Append to <code>config/environments/development.rb</code> initializer with the following code:
    config.after_initialize do
      EnoughFields.enable = true
      EnoughFields.alert = true
      EnoughFields.enough_fields_logger = true
      EnoughFields.console = true
      EnoughFields.growl = true
      EnoughFields.xmpp = { :account => 'enough_fields_account@jabber.org',
                            :password => 'enough_fields_password_for_jabber',
                            :receiver => 'your_account@jabber.org',
                            :show_online_status => true }
      EnoughFields.rails_logger = true
      EnoughFields.disable_browser_cache = true
    end

The notifier of enough_fields is a wrap of "uniform_notifier":https://github.com/flyerhzm/uniform_notifier

The code above will enable all six of the EnoughFields notification systems:

* <code>EnoughFields.enable</code>: enable EnoughFields plugin/gem, otherwise do nothing
* <code>EnoughFields.alert</code>: pop up a JavaScript alert in the browser
* <code>EnoughFields.enough_fields_logger</code>: log to the EnoughFields log file (Rails.root/log/enough_fields.log)
* <code>EnoughFields.rails_logger</code>: add warnings directly to the Rails log
* <code>EnoughFields.console</code>: log warnings to your browser's console.log (Safari/Webkit browsers or Firefox w/Firebug installed)
* <code>EnoughFields.growl</code>: pop up Growl warnings if your system has Growl installed. Requires a little bit of configuration
* <code>EnoughFields.xmpp</code>: send XMPP/Jabber notifications to the receiver indicated. Note that the code will currently not handle the adding of contacts, so you will need to make both accounts indicated know each other manually before you will receive any notifications. If you restart the development server frequently, the 'coming online' sound for the enough_fields account may start to annoy - in this case set :show_online_status to false; you will still get notifications, but the enough_fields account won't announce it's online status anymore.
* <code>EnoughFields.disable_browser_cache</code>: disable browser cache which usually causes unexpected problems

Growl Support
-------------

To get Growl support up-and-running for EnoughFields, follow the steps below:

* Install the ruby-growl gem: <code>gem install ruby-growl</code>
* Open the Growl preference pane in Systems Preferences
* Click the "Network" tab
* Make sure both "Listen for incoming notifications" and "Allow remote application registration" are checked. *Note*: If you set a password, you will need to set <code>EnoughFields.growl_password = { :password => 'growl password' }</code> in the config file.
* Restart Growl ("General" tab -> Stop Growl -> Start Growl)
* Boot up your application. EnoughFields will automatically send a Growl notification when Growl is turned on. If you do not see it when your application loads, make sure it is enabled in your initializer and double-check the steps above.

Ruby 1.9 issue
--------------

ruby-growl gem has an issue about md5 in ruby 1.9, if you use growl and ruby 1.9, check this gist http://gist.github.com/300184

XMPP/Jabber Support
-------------------

To get XMPP support up-and-running for EnoughFields, follow the steps below:

* Install the xmpp4r gem: <code>gem install xmpp4r</code>
* Make both the enough_fields and the recipient account add each other as contacts.
  This will require you to manually log into both accounts, add each other
  as contact and confirm each others contact request.
* Boot up your application. EnoughFields will automatically send an XMPP notification when XMPP is turned on.

Important
---------

If you find enough_fields does not work for you, *please disable your browser's cache*.
