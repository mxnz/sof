module ControllerMacros

  def self.included(base)
    base.extend(ClassMethods)
  end


  def current_user
    controller.current_user
  end

  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end


  module ClassMethods
    def login_user
      before do
        user = create(:user)
        login user
      end
    end
  end
end
