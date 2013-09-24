json.array!(@pages) do |page|
  json.extract! page, :title, :content, :home, :published
  json.url admin_page_url(page, format: :json)
end
