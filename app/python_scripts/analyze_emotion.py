from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import numpy as np

# モデルをロードする
model = load_model('/path/to/your/final_model.h5')  # 保存されたモデルのパスを指定

def analyze_emotion(img_path):
    # 画像を読み込んで予測する
    img = image.load_img(img_path, target_size=(150, 150))
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)  # バッチ次元を追加

    # 予測を実行
    predictions = model.predict(img_array)
    predicted_class = np.argmax(predictions)

    # 感情ラベル
    emotion_labels = ['relaxed', 'angry', 'happy']
    return emotion_labels[predicted_class]

if __name__ == "__main__":
    import sys
    # コマンドライン引数から画像のパスを受け取る
    image_path = sys.argv[1]
    result = analyze_emotion(image_path)
    print(result)