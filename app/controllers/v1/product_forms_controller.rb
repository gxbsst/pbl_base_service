module V1
  class ProductFormsController < BaseController

    private

    def configures
      {
        have_parent_resource: false,
        clazz: ProductForm,
        clazz_resource_name: 'product_forms'
      }
    end

    def clazz_params
      params.fetch(:product_form, {}).permit!
    end

  end
end
