json.array!(@accounts) do |account|
  json.extract! account, :id, :login, :password, :status
  json.url account_url(account, format: :json)
end
