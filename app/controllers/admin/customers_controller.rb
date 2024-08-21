class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  def index
    if params[:query].present?
      @customers = Customer.where("name LIKE ? OR email LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
                           .order(created_at: :desc)
                           .page(params[:page])
                           .per(10) # ページごとの表示件数を指定
    else
      @customers = Customer.order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to admin_customers_path, notice: "会員が削除されました"
  end

  def update
    # 画像削除機能
    if params[:customer][:remove_image] == "1"
      @customer.image.purge
    end

    if @customer.update(customer_params)
      redirect_to admin_customer_path(@customer), notice: "会員情報が更新されました。"
    else
      render :edit
    end
  end

    private
      def set_customer
        @customer = Customer.find(params[:id])
      end

      def customer_params
        params.require(:customer).permit(:name, :email, :profile_image)
      end
end
