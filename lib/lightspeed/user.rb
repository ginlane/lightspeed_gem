module Lightspeed
  class User < Resource
    self.fields = [
      :password,
      :email,
      :uri,
      :id,
      :full_render,
      :username,
      :name,
      :account_locked,
      :privilege_group,
      :read_eula,
      :hidden,
      :enabled,
      :phone,
      :open_to_pos,
      :can_open_from_otr,
      :can_discount,
      :internal_user,
      :active,
      :expired,
      :display_welcome,
      :product,
      :product_code,
      :gsx_tech_id
    ]

    attr_accessor *self.fields

    self.filters = [
      [:can_open_from_otr, :boolean, "Can user access reports from OTR?"],
      [:email, :string, "Email address"],
      [:enabled, :boolean, "Is user enabled"],
      [:eula, :boolean, "Did user read EULA?"],
      [:firstname, :string, "First name"],
      [:gsx_tech_id, :string, "GSX Tech ID"],
      [:hidden, :boolean, "Is user hidden?"],
      [:id, :integer, "Resource ID"],
      [:internal_user, :boolean, "Is user an internal user?"],
      [:lastname, :string, "Last name"],
      [:open_to_pos, :boolean, "Does user login to POS mode?"],
      [:phone, :string, "Phone number"],
      [:username, :string, "Username"]
    ]
  end
end

