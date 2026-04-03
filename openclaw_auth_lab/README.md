# Lab: OpenClaw Swarm Authentication API 🔐🚀

Lab นี้เป็นการทดลองสร้างระบบ Login API ที่มีความปลอดภัยสูง โดยใช้พลังการทำงานร่วมกันของเอเจนต์ 5 สายพันธุ์ ผ่านเฟรมเวิร์ก ClawTeam และใช้ OpenClaw เป็นเครื่องยนต์หลัก

> [!NOTE]
> คำสั่ง **`oh`** ที่พบในเอกสารทางการของ ClawTeam เป็นเพียงชื่อย่อ (Alias) ของคำสั่ง `clawteam` หรือ `openclaw` ในแล็บนี้เราจะใช้คำสั่งเต็มเพื่อความชัดเจนครับ

## 🎯 วัตถุประสงค์ (Objectives)
- สร้าง Flask API สำหรับระบบ Login และ Registration ที่ได้มาตรฐาน
- ตรวจสอบและอุดช่องโหว่ความปลอดภัย (Security Hardening) โดยอัตโนมัติ
- ตรวจสอบหา Logic Bugs ที่อาจเกิดขึ้นในระบบยืนยันตัวตน
- สร้าง Unit Test ครอบคลุมทุก Edge Case เพื่อความเสถียรของระบบ

## 👥 รายชื่อทีมเอเจนต์ใน Lab นี้
1. **code-arch:** ผู้ออกแบบและวางสถาปัตยกรรมโค้ด API หลัก
2. **sec-rev:** ผู้เชี่ยวชาญด้านความปลอดภัย คอยตรวจช่องโหว่และอุดรูรั่ว
3. **logic-rev:** ผู้ตรวจสอบตรรกะ ป้องกันบั๊กในระบบยืนยันตัวตน
4. **perf-anal:** ผู้วิเคราะห์ประสิทธิภาพและปรับแต่งความเร็ว
5. **code-qual:** ผู้ทำ QA และเขียน Unit Test ชุดสุดท้าย

## 🕵️‍♂️ การเฝ้าติดตามผล (Monitoring)

คุณสามารถ "แอบดู" การทำงานของเอเจนต์ในขณะที่เป็น Swarm ได้ผ่านทาง Tmux ครับ:

### 1. วิธีดูแบบจัดรวมหน้าจอ (Dashboard Mode)
ใช้คำสั่งนี้เพื่อสลับเข้าไปดูเอเจนต์ทุกตัวในหน้าจอเดียว (Tiled Layout):
```bash
clawteam board attach openclaw-team
```

### 2. วิธีดูแบบแยกหน้าต่าง (Native Mode)
หากต้องการสลับดูแบบทีละคน (Full Window) ด้วยตัวเอง:
```bash
tmux a -t clawteam-openclaw-team
```

### ⌨️ คีย์ลัด Tmux ที่ควรรู้:
- **`Ctrl + b` แล้วกด `0`**: สลับไปดูหน้าจอรวม (ที่เห็นทุกคน)
- **`Ctrl + b` แล้วกด `1`-`5`**: สลับไปดูเอเจนต์แต่ละตัวแบบเต็มจอ
- **`Ctrl + b` แล้วกด `d`**: เพื่อ **Detach (ออกจากหน้าจอ)** โดยที่เอเจนต์ยังทำงานต่ออยู่เบื้องหลัง

---

## 🚀 วิธีการเริ่ม Lab (How to Run)

เพื่อให้ไฟล์งานถูกเก็บแยกเป็นสัดส่วน **ต้องรันสคริปต์จากภายในโฟลเดอร์นี้เท่านั้น:**

```bash
cd openclaw_auth_lab
./launch.sh
```

## 📂 ผลลัพธ์จากการรัน (Output Structure)
หลังรันเสร็จ ไฟล์ผลงานจะถูกสร้างขึ้นในโฟลเดอร์ย่อย ดังนี้:
- `app/api.py`: ไฟล์โค้ด API หลักที่ผ่านการตรวจสอบแล้ว
- `app/test_api.py`: ไฟล์ Unit Test ทั้งหมด
- `.secret_key`: กุญแจลับ JWT ที่ถูกสร้างขึ้นมาใช้งานถาวรเฉพาะ Lab นี้
- `requirements.txt`: รายชื่อไลบรารีที่จำเป็นสำหรับ API นี้

---

## 📂 โครงสร้างโฟลเดอร์ (Clean View)

```
.
├─ .gitignore
├─ README.md
├─ launch.sh
├─ openclaw_ws_setup.md
├─ setup_workspace_meta.sh
└─ workspace_meta/
    ├─ AGENTS.md   -> symlink from app/
    ├─ SOUL.md     -> symlink from app/
    └─ IDENTITY.md -> symlink from app/
```

> **หมายเหตุ**: โฟลเดอร์ `workspace_meta/` จะถูกสร้างอัตโนมัติเมื่อรัน `./launch.sh` ครั้งแรก; ไฟล์ markdown ภายในเป็น symlink ที่ชี้ไปยัง `app/` เพื่อให้เอเจนต์อ่านได้ตามเดิม

## 📊 การติดตามสถานะ
- **Web Dashboard:** [http://localhost:8081/](http://localhost:8081/)
- **Tmux ส่องจอ:** `clawteam board attach openclaw-team`