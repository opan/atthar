# frozen_string_literal: true

module Main
  module Controllers
    module PointOfSales
      class New
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :pos_session
        expose :root_org

        def initialize(pos_repo: PointOfSaleRepository.new, org_repo: OrgRepository.new)
          @pos_repo = pos_repo
          @org_repo = org_repo
        end

        def call(_)
          user_profile = current_user.profile

          @root_org = @org_repo.find_root_org_by_member(user_profile.id)
          if @root_org.nil?
            flash[:errors] = ["Can't find root organization for current user"]
            redirect_to Main.routes.point_of_sales_path
          end

          open_pos = @pos_repo.find_open_pos_by_user(user_profile.id)
          unless open_pos.nil?
            flash[:errors] = ['There is still active POS session created by you.
              Please close it first before create a new session']
            redirect_to Main.routes.point_of_sales_path
          end

          @pos_session = PointOfSale.new(cashier_id: user_profile.id, session_id: generate_session)
        end

        private

        # Generate session ID for POS
        # It is constructed from:
        # YY/MM/DD/{4-digit-random-alphanumeric}/{3-digit-milisecod}-{user-id}
        def generate_session
          rand_an = [*('a'..'z'), *('0'..'9')].sample(4).join.upcase
          Time.now.strftime(Time.now.strftime("%Y/%m/%d/#{rand_an}/%L-#{current_user.id}"))
        end
      end
    end
  end
end
