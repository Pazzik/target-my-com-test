require 'target_mail'
require 'watir'

describe TargetMail do

	before do
		@t = TargetMail.new
	end

	it "can add platform" do
		login = 'mail_login'
		password = 'mail_password'
		app_name = 'ANGRY BIRDS'
		app_url = 'https://itunes.apple.com/en/app/angry-birds/id343200656?mt=8'

		test_ids = @t.add_platform(login,password,app_name,app_url)

		browser = Watir::Browser.new :firefox
		browser.goto 'https://target.my.com/pad_groups'

		browser.span(:class => 'mycom-auth__social-icon mycom-auth__social-icon_mail js-oauth-button').when_present.click	
		browser.window(:title => 'Mail.Ru — Access request').use do
			browser.text_field(:id => 'login').when_present.set login
			browser.text_field(:id => 'password').when_present.set password
			browser.button(:type => "submit").when_present.click  
		end
	
		browser.link({:class => 'pad-groups-list__link js-pad-groups-label',:text => app_name}).when_present.click
		browser.div(:class => 'pads-stat-page__pads-list-wrapper js-pads-list-wrapper').wait_until_present
		
		links = []
		browser.links(:class => 'pads-list__link js-pads-list-label').each {|link| links << link.href }

		slot_ids = []
		links.each do |link|
			browser.goto link
			text = browser.p(:class => 'pad-stat-page__partner-instruction__pph js-slot-id').when_present.text
			slot_ids << text.split[1]
		end

		browser.close

		expect(test_ids).to eq slot_ids
	end

end