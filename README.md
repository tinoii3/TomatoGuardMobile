# 🍅 Tomato Guard: Tomato Leaf Disease Classification App

A mobile application for classifying tomato leaf diseases using Convolutional Neural Networks (CNN) with the **MobileNetV2** architecture.

## ✨ Key Features
- 📷 **Real-time classification:** Scan and analyze tomato leaf diseases using the camera, or select an image from the gallery.
- 🧠 **Offline AI engine:** Runs on-device with a TensorFlow Lite (TFLite) model for fast inference without an internet connection.
- 🛡️ **Outlier detection (Unknown class):** Helps prevent incorrect predictions when scanning non-leaf / irrelevant images.
- ⚠️ **Confidence threshold:** Enforces a minimum confidence (60%). The app prompts you to retake the photo if the image is unclear.
- 📊 **Scan history & statistics:** Automatically stores scan history in SQLite and summarizes frequently detected diseases.

## 🦠 Supported Classes
1. Bacterial Spot
2. Early Blight
3. Late Blight
4. Leaf Mold
5. Septoria Leaf Spot
6. Healthy
7. *Unknown / Outlier*

## 🛠️ Tech Stack
- **Frontend / Mobile Framework:** Flutter (Dart)
- **Machine Learning:** TensorFlow, Keras, MobileNetV2
- **On-Device ML:** TensorFlow Lite (`tflite_flutter`)
- **Local Database:** SQLite (`sqflite`)

## 🚀 Installation
1. Clone this repository

```bash
git clone https://github.com/your-username/tomato-guard-mobile.git
```

2. Go to the project folder and install dependencies

```bash
cd tomato-guard-mobile
flutter pub get
```

3. Run the app on an emulator or a physical device

```bash
flutter run
```

## Notes
- The `model_training/` folder contains Jupyter Notebooks (`.ipynb`) for training the model.