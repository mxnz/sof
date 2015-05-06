module FeaturesMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def sign_in_soc_network(soc_network, options)
    OmniAuth.config.mock_auth[soc_network] = nil
    OmniAuth.config.add_mock(soc_network, options)
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def find_link(str, options)
    text = options[:in]
    link = text.match(/<a.*?>.*?#{str}.*?<\/a>/).to_s
    return nil unless link
    href = link.to_s.match(/href=".*?"/) 
    return nil unless href
    href.to_s.sub('href="http://localhost:3000', '').sub('"', '')
  end

end
