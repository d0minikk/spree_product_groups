module Spree
  module Admin
    class ProductScopesController < BaseController
      helper 'spree/admin/product_groups'

      respond_to :html, :js

      def create
        @product_group = ProductGroup.find_by_permalink(params[:product_group_id])
        @product_scope = @product_group.product_scopes.build(product_scope_params)
        if @product_scope.save
          respond_with(@product_scope) do |format|
            format.html { redirect_to edit_admin_product_group_path(@product_group) }
            format.js   { render :layout => false }
          end
        else
          respond_with(@product_scope)
        end
      end

      def destroy
        @product_scope = ProductScope.find(params[:id])
        if @product_scope.destroy
          @product_group = @product_scope.product_group
          @product_group.update_memberships
          respond_with(@product_scope) do |format|
            format.html { redirect_to edit_admin_product_group_path(@product_group) }
            format.js   { render :layout => false }
          end
        else
          respond_with(@product_scope) do |format|
            format.html { redirect_to edit_admin_product_group_path(@product_scope.product_group) }
          end
        end
      end

      private

      def product_scope_params
        params.require(:product_scope).permit!
      end

    end
  end
end
