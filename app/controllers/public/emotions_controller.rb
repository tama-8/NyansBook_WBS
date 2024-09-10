class Public::EmotionsController < ApplicationController
  def analyze
    # アップロードされた画像のパスを取得
    image_path = params[:image].path

    # Pythonスクリプトを実行して感情を分析する
    result = ""
    IO.popen(["python3", "#{Rails.root}/app/python_scripts/analyze_emotion.py", image_path]) do |pipe|
      result = pipe.read.strip  # Pythonスクリプトの出力を取得
    end

    # 分析結果をJSON形式で返す
    render json: { emotion: result }
  end
end
