class Public::ChatsController < ApplicationController
   before_action :reject_non_related, only: [:show]
   
  # def show
  #   @customer = Customer.find(params[:id])
  #   rooms = current_customer.customer_rooms.pluck(:room_id)
  #   customer_rooms = CustomerRoom.find_by(customer_id: @customer.id, room_id: rooms)
   
  # unless customer_rooms.nil?
  #   @room = customer_rooms.room
  # else
  #   @room = Room.new
  #   @room.save
  #   CustomerRoom.create(customer_id: current_customer.id, room_id: @room.id)
  #   CustomerRoom.create(customer_id: @customer.id, room_id: @room.id)
  #end
  # @chats = @room.chats
  # @chat = Chat.new(room_id: @room.id)
  #   # binding.pry # ここで処理が一時停止します
  # end
  def show
  # byebug
  case params[:source]
  when 'notification'
    chat = Chat.find(params[:id])  # `params[:id]` が Chat の ID であると仮定
    @customer = chat.customer      # `Chat` から関連する `Customer` を取得
  else
    begin
      @customer = Customer.find(params[:id])  # `params[:id]` が Customer の ID である場合
    rescue ActiveRecord::RecordNotFound
      redirect_to public_customer_path(current_customer), alert: '該当する顧客が見つかりませんでした。'
      return
    end
  end

  rooms = current_customer.customer_rooms.pluck(:room_id)
  customer_rooms = CustomerRoom.find_by(customer_id: @customer.id, room_id: rooms)

  unless customer_rooms.nil?
    @room = customer_rooms.room
  else
    @room = Room.new
    @room.save
    CustomerRoom.create(customer_id: current_customer.id, room_id: @room.id)
    CustomerRoom.create(customer_id: @customer.id, room_id: @room.id)
  end

  @chats = @room.chats
  @chat = Chat.new(room_id: @room.id)
  end
 
  def create
    @chat = current_customer.chats.new(chat_params)
     if @chat.save
      # recipient をここで定義します
      recipient = @chat.recipient  # @chat.recipient を使って受信者を取得

      if recipient
        Notification.create!(
          sender_id: current_customer.id,  # メッセージを送ったユーザー
          recipient_id: recipient.id,  # メッセージを受け取るユーザー
          chat_id: @chat.id,
          action: 'chat',
          read: false
        )
      else
        Rails.logger.debug "Recipient not found for chat #{@chat.id}"
      end

      @chats = @chat.room.chats
      render 'public/chats/chats_toggle.js.erb'
    else
      render js: "alert('メッセージの送信に失敗しました');"
    end
  end
  
  def destroy
    @chat = current_customer.chats.find(params[:id])
    @chat.destroy
    @room = @chat.room
    @chats = @room.chats # `@chats` 変数を初期化して、ビューに渡す
    @customer = Customer.find(params[:chat_user_id])
    render 'public/chats/chats_toggle.js.erb'
    # redirect_to public_chat_path(@chat.room_id), notice: 'メッセージが削除されました'
  end

  def destroy_all
    current_customer.chats.where(room_id: params[:room_id]).destroy_all
    # chats変数の再設定
    @chats = current_customer.chats.where(room_id: params[:room_id]) 
    render 'public/chats/chats_toggle.js.erb'
    # redirect_to public_chat_path(params[:room_id]), notice: '全てのメッセージが削除されました'
  end
  

  private
  
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def reject_non_related
     # チャットの削除アクションの場合、チェックをスキップ
    return if action_name == 'destroy'

    customer = Customer.find(current_customer.id)

    if customer.nil?
      redirect_to root_path, alert: '指定されたユーザーが見つかりませんでした。'
      return
    end
  end
  # チャット通知
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
end


