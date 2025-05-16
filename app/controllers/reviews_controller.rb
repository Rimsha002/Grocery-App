class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :check_purchase, only: [:new, :create]

  def new
    @review = @product.reviews.build
  end

  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user
    @review.verified_purchase = true if @purchased

    if @review.save
      redirect_to product_path(@product), notice: 'Review was successfully submitted.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to product_path(@product), notice: 'Review was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to product_path(@product), notice: 'Review was successfully deleted.'
  end

  private

  def set_product
    @product = Product.find_by!(slug: params[:product_id])
  end

  def set_review
    @review = current_user.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def check_purchase
    @purchased = current_user.orders.completed.joins(:order_items)
                           .where(order_items: { product_id: @product.id })
                           .exists?
  end
end 