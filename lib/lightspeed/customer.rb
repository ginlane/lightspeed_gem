module Lightspeed
  class Customer < Resource
    self.fields = [
      :name,
      :company,
      :email,
      :homepage,
      :phone_numbers,
      :photo,
      :is_company,
      :billing,
      :shipping,
      :flags,
      :birthdate,
      :credit_limit,
      :groups,
      :customer_id,
      :credit_status,
      :ar_balance,
      :import_id,
      :user,
      :tax_code,
      :tax_exemption,
      :language,
      :notes,
      :uri,
      :id
    ]

    attr_accessor *self.fields

    def first_name
      name && name[:first]
    end

    def last_name
      name && name[:last]
    end

    self.filters = [
      [:address1_1, :string, "Address line 1 (Billing address)"],
      [:address1_2, :string, "Address line 2 (Billing address)"],
      [:address2_1, :string, "Address line 1 (Shipping address)"],
      [:address2_2, :string, "Address line 2 (Shipping address)"],
      [:city1, :string, "City (Billing address)"],
      [:city2, :string, "City (Shipping address)"],
      [:company, :string, "Company name"],
      [:country1, :string, "Country (Billing Address)"],
      [:country2, :string, "Country (Shipping Address)"],
      [:credit_hold, :boolean, "is credit hold checked for customer?"],
      [:credit_limit, :float, "Value of Credit limit"],
      [:currency, :string, "Currency of customer"],
      [:date_cre, :date, "Created Date (YYYY-MM-DD or M-DD-YYYY)"],
      [:date_mod, :date, "Modified Date (YYYY-MM-DD or M-DD-YYYY)"],
      [:datetime_cre, :datetime, "Created Date and Time (YYYY-MM-DD hh:mm:ss)"],
      [:datetime_mod, :datetime, "Modified Date and Time (YYYY-MM-DD hh:mm:ss)"],
      [:email, :string, "Email address"],
      [:firstname, :string, "First name"],
      [:homepage, :string, "Homepage/Website Address"],
      [:id, :integer, "Resource ID"],
      [:lastname, :string, "Last name"],
      [:mainname, :string, "Main name (either full name or company name)"],
      [:mainphone, :string, "Main phone number"],
      [:mainphonetype, :string, "Main phone type"],
      [:new_import, :boolean, "is customer newly imported?"],
      [:new_update, :boolean, "is customer newly updated (via import tools)?"],
      [:phone1, :string, "Phone 1 number"],
      [:phone2, :string, "Phone 2 number"],
      [:phone3, :string, "Phone 3 number"],
      [:phone4, :string, "Phone 4 number"],
      [:phonetype1, :string, "Phone 1 type"],
      [:phonetype2, :string, "Phone 2 type"],
      [:phonetype3, :string, "Phone 3 type"],
      [:phonetype4, :string, "Phone 4 type"],
      [:state1, :string, "State (Billing Address)"],
      [:state2, :string, "State (Shipping Address)"],
      [:type, :string, "Company or Individual? ('c' or 'i')"],
      [:zip1, :string, "Zip (Billing Address)"],
      [:zip2, :string, "Zip (Shipping Address)"]
    ]
  end
end
