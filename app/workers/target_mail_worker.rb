require 'target_mail'

class TargetMailWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :dead => false

  def perform(account_id)
    account = Account.find(account_id)
    
    app_name = 'ANDRY BIRDS'
    app_url = 'https://itunes.apple.com/en/app/angry-birds/id343200656?mt=8'
    t = TargetMail.new
    t.add_platform(account.login,account.password,app_name,app_url)

    account.status = 'Синхронизировано'
    account.save

    rescue 
      account.status = 'Ошибка синхронизации'
      account.save
  end
end