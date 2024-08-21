module ApplicationHelper
  # 投稿日時の表示
  def time_ago_in_japanese(time)
    seconds_ago = Time.now - time
    case seconds_ago
    when 0..59
      "#{seconds_ago.to_i}秒前"
    when 60..3599
      "#{(seconds_ago / 60).to_i}分前"
    when 3600..86399
      "#{(seconds_ago / 3600).to_i}時間前"
    when 86400..2591999
      "#{(seconds_ago / 86400).to_i}日前"
    when 2592000..31103999
      "#{(seconds_ago / 2592000).to_i}ヶ月前"
    else
      "#{(seconds_ago / 31104000).to_i}年前"
    end
  end
end
