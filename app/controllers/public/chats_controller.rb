class Public::ChatsController < ApplicationController
   before_action :reject_non_related, only: [:show]
   
  def show
    @customer = Customer.find(params[:id])
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
    @chat.save
    @chats = @chat.room.chats
  end
  
   def destroy
    @chat = current_customer.chats.find(params[:id])
    @chat.destroy
    # binding.pry
    @customer = Customer.find(params[:chat_user_id])
    render :show
    
    #redirect_to public_chat_path(@chat.room_id), notice: 'メッセージが削除されました'
  end

  def destroy_all
    current_customer.chats.where(room_id: params[:room_id]).destroy_all
    # binding.pry
    @customer = Customer.find(params[:chat_user_id])
    render :show
    ##redirect_to public_chat_path(params[:room_id]), notice: '全てのメッセージが削除されました'
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
      # unless current_customer.following?(customer) && customer.following?(current_customer)
      #   redirect_to root_path, alert: 'そのユーザーとのチャットは許可されていません。'
      # end
  end
end


