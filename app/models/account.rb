class Account < ActiveRecord::Base
  before_save :default_values
  def default_values
    self.status ||= 'Не синхронизировано'
  end
end
