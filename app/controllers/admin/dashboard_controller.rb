class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!

  def index
    # 統計情報の収集
    @total_customers = Customer.count
    @new_customers_today = Customer.where("created_at >= ?", Time.zone.now.beginning_of_day).count
    @total_posts = Post.count
    @total_comments = PostComment.count
    @total_likes = Favorite.count
    @total_follows = Relationship.count
    @total_reports = Report.count # 通報数

    # 最近の活動の収集
    @recent_customers = Customer.order(created_at: :desc).limit(5)
    @recent_posts = Post.order(created_at: :desc).limit(5)
    @recent_comments = PostComment.order(created_at: :desc).limit(5)
    @recent_likes = Favorite.order(created_at: :desc).limit(5)
    @recent_follows = Relationship.order(created_at: :desc).limit(5)
    @recent_reports = Report.order(created_at: :desc).limit(5) # 通報された投稿
  end
end
