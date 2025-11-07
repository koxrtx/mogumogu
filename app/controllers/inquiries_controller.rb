class InquiriesController < ApplicationController
  # 問い合わせ
  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)

    if @inquiry.save
      flash[:notice] = "お問い合わせを送信しました。返信までしばらくお待ちください。"
      redirect_to @inquiry
    else
      render :new, status: :unprocessable_content
    end
  end

  # 管理者画面
  def index
    @inquiries = Inquiry.all.page(params[:page]).per(20)
  end

  private

  # 問い合わせパラメーター
  def inquiry_params
    params.require(:inquiry).permit(:name, :email,:inquiry_comment)
  end
end
