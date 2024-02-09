class ProductsController < ApplicationController
  def index
    pp params[:category_id]
    @categories = Category.order(name: :asc).load_async
    @products = Product.with_attached_photo.order(created_at: :desc).load_async
    if params[:category_id]
      @products = Product.where(category_id: params[:category_id])
    end
  end
  def show
    product
  end
  def new
    @product = Product.new
  end
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: t('.created')
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    product
  end
  def update
    if product.update(product_params)
      redirect_to products_path, notice: t('.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    product.destroy
    redirect_to products_path, notice: t('.destroyed'), status: :see_other
  end
  private
  def product_params
    params.require(:product).permit(:title, :description, :price, :photo, :category_id)
  end
  def product
    @product = Product.find(params[:id])
  end
  def locale_from_header
    request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
  end
end