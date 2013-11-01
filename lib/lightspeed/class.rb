module Lightspeed
  class Class < Resource

    self.fields = [
      :name
    ]

    self.filters = [
      [:id, :integer, "Resource ID"],
      [:classname, :string, "Name of class"]
    ]
  end
end
