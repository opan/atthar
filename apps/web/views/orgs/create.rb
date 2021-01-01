module Web
  module Views
    module Orgs
      class Create
        include Web::View
        layout :admin
        template 'orgs/new'
      end
    end
  end
end
