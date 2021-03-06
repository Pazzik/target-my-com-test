class TargetMail
  
  attr_accessor :login, :password, :app_name, :app_url

  def add_platform(login,password,app_name,app_url)
    @login = login
    @password = password
    @app_name = app_name
    @app_url = app_url
    @browser = Watir::Browser.new :firefox

    @browser.goto 'https://target.my.com/create_pad_groups/'
    login_in_mail
    add_campaign
    add_fullscreen_block
    slot_ids = get_slot_ids
    @browser.close

    return slot_ids
  end

  private
  def login_in_mail
    @browser.span(:class => 'mycom-auth__social-icon mycom-auth__social-icon_mail js-oauth-button').when_present.click  
    @browser.window(:title => 'Mail.Ru — Access request').use do
      @browser.text_field(:id => 'login').when_present.set @login
      @browser.text_field(:id => 'password').when_present.set @password
      @browser.button(:type => "submit").when_present.click  
    end
  end

  def add_campaign
    @browser.text_field(:class => 'pad-setting__description__input js-setting-pad_description js-setting-field').when_present.set @app_name
    @browser.text_field(:class => 'pad-setting__url__input js-setting-pad-url').when_present.set @app_url
    @browser.text_field(:class => 'adv-block-form__row__input js-adv-block-description js-adv-block-field').when_present.set 'Standard'
    @browser.div(:class => 'format-item__image format-item__image_standard').when_present.click
    @browser.span(:class => 'main-button__label').when_present.click
  end

  def add_fullscreen_block
    @browser.link({:class => 'pad-groups-list__link js-pad-groups-label',:text => @app_name}).when_present.click
    @browser.a(:class => 'pads-control-panel__button pads-control-panel__button_create').when_present.click
    @browser.text_field(:class => 'adv-block-form__row__input js-adv-block-description js-adv-block-field').when_present.set 'Fullscreen'
    @browser.div(:class => 'format-item__image format-item__image_fullscreen').when_present.click       
    @browser.span(:class => 'create-pad-page__save-button js-save-button').when_present.click
  end

  def get_slot_ids
    @browser.div(:class => 'pads-stat-page__pads-list-wrapper js-pads-list-wrapper').wait_until_present

    links = []
    @browser.links(:class => 'pads-list__link js-pads-list-label').each {|link| links << link.href }

    slot_ids = []
    links.each do |link|
      @browser.goto link
      text = @browser.p(:class => 'pad-stat-page__partner-instruction__pph js-slot-id').when_present.text
      slot_ids << text.split[1]
    end

    return slot_ids
  end

end
