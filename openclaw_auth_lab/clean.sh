#!/usr/bin/env bash
# -----------------------------------------------------------------
# clean.sh – รีเซ็ตระบบกลับเป็นสภาพเริ่มต้นก่อนรัน Agent
# -----------------------------------------------------------------

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPT_DIR" || exit 1

echo "🧹 [1/3] กำลังลบโฟลเดอร์ผลงานและพื้นที่ Sandbox..."
rm -rf app
rm -rf agent_sandbox
rm -rf app_old

echo "🛑 [2/3] กำลังบังคับปิด Tmux Session ของรอบก่อนหน้า (ถ้ามี)..."
tmux kill-session -t clawteam-openclaw-team 2>/dev/null || true

echo "🗑️  [3/3] กำลังเคลียร์แคชประวัติทีมงานจาก ClawTeam..."
rm -rf ~/.clawteam/teams/openclaw-team*
rm -rf ~/.clawteam/tasks/openclaw-team*

echo "======================================================"
echo "✨ ระบบคลีน 100% แล้วครับ พร้อมทำการรัน ./launch.sh รอบใหม่!"
echo "======================================================"
