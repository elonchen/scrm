json.array!(@faqs) do |faq|
  json.extract! faq, :id, :title, :member_id, :question, :answer
  json.url faq_url(faq, format: :json)
end
