# 🦐 OpenClaw LINE Bot (น้องกุ้ง)

AI Chatbot ที่รันบน local เชื่อมต่อกับ LINE Messaging API ใช้ OpenClaw เป็น agent framework

---

## 📋 สิ่งที่ต้องเตรียม

| สิ่งที่ต้องการ | ฟรี? | ลิงก์ |
|-------------|------|-------|
| OpenClaw CLI | ✅ | https://openclaw.ai |
| ngrok | ✅ (Free tier) | https://ngrok.com |
| LINE Developers Account | ✅ | https://developers.line.biz |
| OpenAI API Key | ❌ (มีค่าใช้จ่าย) | https://platform.openai.com |

---

## 🚀 ขั้นตอนติดตั้ง

### 1. ติดตั้ง OpenClaw

เปิด PowerShell (Windows) หรือ Terminal (Mac/Linux):

**Windows:**
```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

**Mac/Linux:**
```bash
curl -fsSL https://openclaw.ai/install.sh | sh
```

ตรวจสอบ:
```bash
openclaw --version
```

---

### 2. ตั้งค่า OpenClaw ครั้งแรก

รันคำสั่ง config เพื่อเลือกโมเดล:
```bash
openclaw config
```

เลือก:
- **Model**: `openai/gpt-4o-mini` (ถูกที่สุด) หรือโมเดลอื่นที่ต้องการ
- ใส่ **OpenAI API Key** ของคุณ

ตรวจสอบว่าตั้งค่าสำเร็จ:
```bash
openclaw config get agents.defaults.model
```

---

### 3. สร้าง LINE Messaging API Channel

1. ไปที่ https://developers.line.biz/console/
2. **Create a Provider** (หรือเลือก provider ที่มีอยู่)
3. คลิก **Create a new channel** → เลือก **Messaging API**
4. กรอกข้อมูล:
   - Channel name: ตั้งชื่อบอทของคุณ (เช่น "น้องกุ้ง")
   - Channel description: อธิบายบอท
5. หลังสร้างแล้ว ไปที่ **Messaging API** tab:
   - คัดลอก **Channel Secret** (อยู่ใน Basic settings)
   - คัดลอก **Channel Access Token** (คลิก Issue ถ้ายังไม่มี)

---

### 4. ตั้งค่า LINE Channel ใน OpenClaw

สร้างไฟล์ `openclaw.json` ในโฟลเดอร์โปรเจค:

```json
{
  "agents": {
    "defaults": {
      "workspace": "~/.openclaw/workspace",
      "model": "openai/gpt-4o-mini"
    }
  },
  "channels": {
    "line": {
      "enabled": true,
      "channelAccessToken": "ใส่ Channel Access Token ของคุณ",
      "channelSecret": "ใส่ Channel Secret ของคุณ",
      "dmPolicy": "pairing",
      "mediaMaxMb": 10
    }
  }
}
```

**หมายเหตุ:** ไฟล์นี้มี token ลับ ห้าม push ขึ้น git!

---

### 5. รัน OpenClaw Gateway

```bash
openclaw gateway --port 18789
```

เปิดทิ้งไว้ใน terminal นี้

---

### 6. รัน ngrok (Terminal ใหม่)

เปิด terminal/PowerShell ใหม่ แล้วรัน:

```bash
ngrok http 18789
```

จะได้ URL แบบนี้:
```
Forwarding  https://xxxx-xxx-xxx-xxx.ngrok-free.app -> http://localhost:18789
```

**คัดลอก URL นี้ไว้**

---

### 7. ตั้งค่า Webhook URL ใน LINE

1. กลับไปที่ LINE Developers Console
2. เลือก channel ของคุณ → **Messaging API** tab
3. ที่ **Webhook URL** ใส่:
   ```
   https://YOUR_NGROK_URL/line/webhook
   ```
   ตัวอย่าง:
   ```
   https://8689-203-144-229-194.ngrok-free.app/line/webhook
   ```
4. คลิก **Update** แล้วคลิก **Verify** (ควรขึ้น Success)
5. เปิด **Use webhook** = `Enabled`
6. ปิด **Auto-reply messages** = `Disabled` (ไม่งั้นจะตอบซ้ำ)

---

### 8. ทดสอบบอท

1. เปิด LINE บนมือถือ
2. สแกน QR Code ของ channel หรือเพิ่มเพื่อนจาก LINE Developers Console
3. ส่งข้อความ "ทดสอบ" ใน LINE
4. บอทควรตอบกลับ! 🎉

**ถ้าไม่ตอบ:**
- เช็ค terminal ที่รัน `openclaw gateway` ว่ามี error อะไร
- เช็คว่า ngrok ยังรันอยู่
- เช็คว่า webhook URL ตั้งค่าถูกต้อง

---

## ⚡ Quick Start (สำหรับครั้งถัดไป)

หลังจากติดตั้งครั้งแรกเสร็จแล้ว ครั้งต่อไปใช้สคริปต์นี้:

### Windows (PowerShell):

**เริ่มทุกอย่าง:**
```powershell
.\start.ps1
```

สคริปต์จะเปิด:
- OpenClaw Gateway (port 18789)
- ngrok tunnel

**หยุดทุกอย่าง:**
```powershell
.\stop.ps1
```

### Manual (ถ้าไม่ใช้สคริปต์):

**Terminal 1 - OpenClaw Gateway:**
```bash
openclaw gateway --port 18789
```

**Terminal 2 - ngrok:**
```bash
ngrok http 18789
# หรือ .\ngrok.exe http 18789 (Windows)
```

**อย่าลืม:** ทุกครั้งที่ ngrok restart ต้องอัปเดต webhook URL ใน LINE Console!

---

## 🔧 คำสั่งที่มีประโยชน์

```bash
# ดูโมเดลที่ใช้อยู่
openclaw config get agents.defaults.model

# เปลี่ยนโมเดล
openclaw config

# ดู logs
openclaw logs

# ตรวจสอบสถานะ gateway
openclaw gateway status

# หยุด gateway
# กด Ctrl+C ใน terminal ที่รัน gateway
```

---

## ⚠️ Troubleshooting

### บอทไม่ตอบกลับ

1. **เช็ค gateway ว่ารันอยู่หรือไม่:**
   ```bash
   openclaw gateway status
   ```

2. **เช็ค ngrok ว่ายังรันอยู่:**
   - ดูใน terminal ที่รัน ngrok
   - ถ้า ngrok หยุด URL จะเปลี่ยน ต้องอัปเดต LINE webhook ใหม่

3. **เช็ค API rate limit:**
   - ดู log ว่ามีข้อความ "API rate limit reached" หรือไม่
   - ถ้ามี ต้องรอหรือเติมเครดิต OpenAI

4. **เช็ค LINE webhook:**
   - ไปที่ LINE Developers Console
   - คลิก Verify webhook ดูว่าผ่านหรือไม่

### LINE Provider restart ซ้ำๆ

- แสดงว่า LINE channel config ไม่ถูกต้อง
- เช็ค `channelAccessToken` และ `channelSecret` ใน `openclaw.json`

---

## 📝 หมายเหตุ

- ไฟล์ `openclaw.json` มี token ลับ **ห้าม push ขึ้น git**
- ngrok free tier จะได้ URL ใหม่ทุกครั้งที่รีสตาร์ท
- OpenAI API มีค่าใช้จ่าย แนะนำใช้ `gpt-4o-mini` เพื่อประหยัดค่าใช้จ่าย

---

## 📚 เอกสารเพิ่มเติม

- OpenClaw Docs: https://docs.openclaw.ai
- LINE Messaging API: https://developers.line.biz/en/docs/messaging-api/
- ngrok Docs: https://ngrok.com/docs
