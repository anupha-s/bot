# 🤖 OpenClaw LINE Chatbot Agent

AI Agent ที่ทำงานบนเครื่อง local เชื่อมต่อกับ LINE พร้อม:
- 💬 **แชทบอท** — ตอบคำถามทั่วไปใน LINE ส่วนตัว
- 📊 **ราคาคริปโต Top 10** — ดึงข้อมูลจาก CoinGecko (ฟรี)
- 📰 **ข่าวคริปโต** — ดึงจาก CryptoPanic RSS (ฟรี)
- ⏰ **ส่งอัตโนมัติ** — 08:00 (ราคา), 09:00 (ข่าว), 20:00 (ราคา) ทุกวัน

---

## 📋 สิ่งที่ต้องเตรียม

| สิ่งที่ต้องการ                    | ฟรี?          | ลิงก์                         |
| ---------------------------- | ------------ | --------------------------- |
| Node.js v22+                 | ✅            | https://nodejs.org          |
| OpenClaw                     | ✅            | https://openclaw.ai         |
| ngrok                        | ✅ (tier ฟรี)  | https://ngrok.com           |
| LINE Developers Account      | ✅            | https://developers.line.biz |
| OpenAI หรือ Anthropic API Key | ❌ (มีค่าใช้จ่าย) | https://platform.openai.com |

---

## 🚀 ขั้นตอนติดตั้ง

### ขั้นที่ 1 — ติดตั้ง Node.js 22+

ดาวน์โหลดและติดตั้งจาก https://nodejs.org (เลือก LTS)

ตรวจสอบ:
```powershell
node --version   # ต้องได้ v22.x.x ขึ้นไป
```

---

### ขั้นที่ 2 — ติดตั้ง OpenClaw

เปิด **PowerShell** แล้วรัน:
```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

ตรวจสอบ:
```powershell
openclaw --version
```

---

### ขั้นที่ 3 — รัน Onboarding Wizard

```powershell
openclaw onboard --install-daemon
```

Wizard จะถามข้อมูล:
1. **Model/Auth** → เลือก OpenAI หรือ Anthropic แล้วใส่ API Key
2. **Workspace** → กด Enter ใช้ default (`~/.openclaw/workspace`)
3. **Gateway port** → กด Enter ใช้ `18789`
4. **Channels** → ข้ามไปก่อน (จะตั้งค่า LINE แยก)
5. **Daemon** → เลือก `Yes` เพื่อ auto-start

---

### ขั้นที่ 4 — ติดตั้ง LINE Plugin

```powershell
openclaw plugins install @openclaw/line
```

---

### ขั้นที่ 5 — สร้าง LINE Messaging API Channel

1. ไปที่ https://developers.line.biz/console/
2. **Create a Provider** (หรือเลือก provider ที่มีอยู่)
3. คลิก **Create a new channel** → เลือก **Messaging API**
4. กรอกข้อมูล:
   - Channel type: `Messaging API`
   - Channel name: `My Crypto Bot` (ตั้งชื่ออะไรก็ได้)
5. หลังสร้างแล้ว ไปที่ **Messaging API** tab:
   - คัดลอก **Channel secret** (อยู่ใน Basic settings)
   - คัดลอก **Channel access token** (คลิก Issue ถ้ายังไม่มี)
6. เปิด **Use webhook** → `Enabled`

---

### ขั้นที่ 6 — ตั้งค่า OpenClaw Config

Copy ไฟล์ config ไปยัง home directory:
```powershell
# คัดลอก config (ถ้า ~/.openclaw/openclaw.json มีอยู่แล้ว ให้ merge แทน)
Copy-Item "C:\Users\A\Documents\work\openclaw-line-agent\openclaw.json" `
          "$env:USERPROFILE\.openclaw\openclaw.json"
```

แล้ว **แก้ไขไฟล์** `%USERPROFILE%\.openclaw\openclaw.json`:
```json
{
  "agents": {
    "defaults": {
      "workspace": "~/.openclaw/workspace",
      "model": "gpt-4o-mini"
    }
  },
  "channels": {
    "line": {
      "enabled": true,
      "channelAccessToken": "วางตรงนี้",
      "channelSecret": "วางตรงนี้",
      "dmPolicy": "pairing"
    }
  }
}
```

---

### ขั้นที่ 7 — Copy Agent Instructions

```powershell
Copy-Item "C:\Users\A\Documents\work\openclaw-line-agent\agent-instructions.md" `
          "$env:USERPROFILE\.openclaw\workspace\AGENT.md"
```

---

### ขั้นที่ 8 — ติดตั้ง ngrok และรัน HTTPS Tunnel

1. สมัคร account ฟรีที่ https://ngrok.com
2. ดาวน์โหลดและติดตั้ง ngrok
3. Authenticate:
   ```powershell
   ngrok config add-authtoken YOUR_NGROK_TOKEN
   ```
4. รัน tunnel:
   ```powershell
   ngrok http 18789
   ```
5. จะได้ URL แบบนี้:
   ```
   Forwarding  https://xxxx-xx-xx-xx-xx.ngrok-free.app -> http://localhost:18789
   ```
   **คัดลอก URL นี้ไว้**

---

### ขั้นที่ 9 — ตั้ง Webhook URL ใน LINE Console

1. กลับไปที่ LINE Developers Console → channel ของคุณ
2. ไปที่ **Messaging API** tab
3. ใต้ **Webhook URL** ใส่:
   ```
   https://YOUR_NGROK_URL/line/webhook
   ```
   ตัวอย่าง:
   ```
   https://abc123.ngrok-free.app/line/webhook
   ```
4. คลิก **Verify** — ควรขึ้น Success
5. เปิด **Use webhook** = `Enabled`

> ⚠️ ทุกครั้งที่รีสตาร์ท ngrok จะได้ URL ใหม่ ต้องอัปเดต LINE console ด้วย

---

### ขั้นที่ 10 — รัน OpenClaw Gateway

เปิด **PowerShell ใหม่**:
```powershell
openclaw gateway --port 18789
```

ตรวจสอบสถานะ (อีก terminal):
```powershell
openclaw gateway status
```

---

### ขั้นที่ 11 — Pair กับ LINE ส่วนตัว

1. เปิด LINE บนมือถือ → เพิ่มเพื่อน → เลือก Messaging API channel ของคุณ
2. ส่งข้อความอะไรก็ได้ใน LINE
3. ใน terminal ดู pairing code:
   ```powershell
   openclaw pairing list line
   ```
4. Approve:
   ```powershell
   openclaw pairing approve line <CODE>
   ```
5. Agent จะตอบกลับแล้ว! 🎉

---

### ขั้นที่ 12 — รัน Scheduler (ส่งราคา+ข่าวอัตโนมัติ)

ก่อนรัน ต้องหา **LINE User ID** ของตัวเอง:
```powershell
openclaw pairing list line
# User ID มีรูปแบบ U + 32 ตัวอักษร เช่น U1234567890abcdef...
```

แก้ไขค่าใน `scheduler.js`:
```javascript
lineAccessToken: "YOUR_LINE_CHANNEL_ACCESS_TOKEN",
lineUserId: "YOUR_LINE_USER_ID",  // U + 32 hex chars
```

หรือใช้ Environment Variables:
```powershell
$env:LINE_ACCESS_TOKEN = "your_token_here"
$env:LINE_USER_ID = "Uxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
node scheduler.js
```

---

## 💬 คำสั่งที่ใช้ใน LINE

| พิมพ์ใน LINE                | ผลลัพธ์             |
| ------------------------- | ----------------- |
| `สวัสดี`                    | AI ตอบทักทาย       |
| `/crypto` หรือ `ราคาคริปโต` | แสดงราคา Top 10   |
| `/news` หรือ `ข่าวคริปโต`    | แสดงข่าวล่าสุด 5 ข่าว |
| `/help`                   | แสดงคำสั่งทั้งหมด      |
| คำถามอื่นๆ                   | AI ตอบตามปกติ      |

---

## 🔧 คำสั่งที่มีประโยชน์

```powershell
# ดู logs
openclaw logs

# ตรวจสอบปัญหา
openclaw doctor

# ทดสอบดึงราคาคริปโต
node C:\Users\A\Documents\work\openclaw-line-agent\crypto_news.js

# เปิด Dashboard (Web UI)
openclaw dashboard
# → เปิด http://127.0.0.1:18789
```

---

## 🗂️ โครงสร้างไฟล์

```
openclaw-line-agent/
├── README.md              ← คู่มือนี้
├── openclaw.json          ← config (copy ไป ~/.openclaw/)
├── agent-instructions.md  ← system prompt (copy ไป ~/.openclaw/workspace/AGENT.md)
├── crypto_news.js         ← ดึงราคา + ข่าว
└── scheduler.js           ← ส่งอัตโนมัติ
```
