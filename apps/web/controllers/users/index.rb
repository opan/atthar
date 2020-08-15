module Web
  module Controllers
    module Users
      class Index
        include Web::Action
        include Web::Authentication

        before :authenticate!

        expose :users

        def initialize(repo = UserRepository.new)
          @repo = repo
        end

        def call(params)
          @users = @repo.all
        end
      end
    end
  end
end
