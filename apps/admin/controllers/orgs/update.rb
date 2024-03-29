module Admin
  module Controllers
    module Orgs
      class Update
        include Admin::Action
        include Main::Authentication

        before :authenticate!

        params do
          required(:id).filled(:int?)
          required(:org).schema do
            required(:name).filled(:str?)
            optional(:display_name).maybe(:str?)
            required(:address).filled(:str?)
            optional(:phone_numbers).maybe(:str?)
          end
        end

        def initialize(org_repo: OrgRepository.new)
          @org_repo = org_repo
        end

        def call(params)
          unless superadmin_user?
            flash[:errors] = ["You're not allowed to access this page"]
            redirect_to Main.routes.root_path
          end

          unless params.valid?
            flash[:errors] = params.error_messages
            self.status = 422
            return
          end

          @org = @org_repo.find(params.get(:id))
          if @org.nil?
            flash[:errors] = ['Organization not found']
            self.status = 404
            return
          end

          org_entity = Org.new(org_params)
          @org = @org_repo.update(@org.id, org_entity)

          flash[:info] = ['Organization has been successfully updated']
          redirect_to routes.orgs_path
        end

        private

        def org_params
          org = params.get(:org)
          org[:updated_by_id] = current_user.profile.id
          org
        end
      end
    end
  end
end
