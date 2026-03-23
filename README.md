# 🍅 Tomato Guard: Tomato Leaf Disease Classification App

โมบายแอปพลิเคชันสำหรับการจำแนกโรคใบมะเขือเทศด้วยเทคนิคโครงข่ายประสาทเทียมแบบคอนโวลูชัน (CNN) โดยใช้สถาปัตยกรรม **MobileNetV2**

## ✨ ฟีเจอร์หลัก (Features)
- 📷 **Real-time Classification:** สแกนและวิเคราะห์โรคใบมะเขือเทศผ่านกล้องถ่ายรูป หรือเลือกจากคลังภาพ (Gallery)
- 🧠 **Offline AI Engine:** ประมวลผลด้วยโมเดล TensorFlow Lite (TFLite) ภายในตัวเครื่อง รวดเร็วและไม่ต้องใช้เน็ต
- 🛡️ **Outlier Detection (Unknown Class):** มีระบบป้องกันการทำนายผิดพลาดเมื่อสแกนภาพที่ไม่ใช่ใบพืช หรือภาพขยะ 
- ⚠️ **Confidence Threshold:** มีเกณฑ์ความมั่นใจขั้นต่ำ (ุ60%) ระบบจะแจ้งเตือนให้ถ่ายใหม่หากภาพไม่ชัดเจน
- 📊 **Scan History & Statistics:** บันทึกประวัติการสแกนอัตโนมัติด้วยฐานข้อมูล SQLite และสรุปสถิติโรคที่พบบ่อย

## 🦠 โรคที่สามารถจำแนกได้ (Supported Classes)
1. โรคใบจุดแบคทีเรีย (Bacterial Spot)
2. โรคใบจุดวง (Early Blight)
3. โรคใบไหม้ (Late Blight)
4. โรครากำมะหยี่ (Leaf Mold)
5. โรคใบจุดวงกลม (Septoria Leaf Spot)
6. ใบสุขภาพดี (Healthy)
7. *ไม่สามารถระบุได้ (Unknown / Outlier)*

## 🛠️ เครื่องมือและเทคโนโลยี (Tech Stack)
- **Frontend / Mobile Framework:** Flutter (Dart)
- **Machine Learning:** TensorFlow, Keras, MobileNetV2
- **On-Device ML:** TensorFlow Lite (`tflite_flutter`)
- **Local Database:** SQLite (`sqflite`)

## 🚀 วิธีการติดตั้งและรันโปรเจกต์ (Installation)
1. โคลน Repository นี้ลงในเครื่องของคุณ
   ```bash
   git clone [https://github.com/your-username/tomato-guard-mobile.git](https://github.com/your-username/tomato-guard-mobile.git)

2. เข้าไปที่โฟลเดอร์โปรเจกต์และติดตั้ง Packages
   ```bash
   cd tomato-guard-mobile
   flutter pub get

3. รันแอปพลิเคชันบน Emulator หรือเครื่องจริง
   ```bash
   flutter run

## folder model_training for file Jupyter Notebook ('.ipynb')