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
end
