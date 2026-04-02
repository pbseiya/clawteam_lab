#!/usr/bin/env bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPT_DIR"
# รีเซ็ตทีมเก่าถ้ามีอยู่ (เพื่อกัน Error Team already exists)
tmux kill-session -t clawteam-qwen-team 2>/dev/null || true
rm -rf ~/.clawteam/teams/qwen-team*
rm -rf ~/.clawteam/tasks/qwen-team*
# สร้าง Symlink หลอก ClawTeam ว่า qwen คือ claude เพื่อให้รองรับ Interactive Tmux
ln -sf $(which qwen) ./claude

# สั่งให้พวกมันสร้างผลงานในโฟลเดอร์ app/ เท่านั้น
mkdir -p app
clawteam team spawn-team qwen-team -d "Qwen Swarm in Tmux (Default Model)"

T1=$(clawteam task create qwen-team "Build API" --owner code-arch -d "Write Flask API at app/api.py" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)
T2=$(clawteam task create qwen-team "Security Review" --owner sec-rev -d "Check for SQL injections in app/api.py" --blocked-by "$T1" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)
T3=$(clawteam task create qwen-team "Logic Review" --owner logic-rev -d "Check edge cases in login logic in app/" --blocked-by "$T1" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)
T4=$(clawteam task create qwen-team "Performance Analysis" --owner perf-anal -d "Analyze speed and overhead in app/" --blocked-by "$T1" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)
T5=$(clawteam task create qwen-team "Code Quality & QA" --owner code-qual -d "Write unit tests inside app/" --blocked-by "$T2,$T3,$T4" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)

# Using tmux backend with the './claude' symlink so it stays perfectly alive, AND appending -y for YOLO mode and -m for Moduls!
clawteam spawn tmux --team qwen-team --agent-name code-arch --task "เขียนโปรแกรม Python สร้าง API Login ที่ app/api.py, เมื่อเสร็จเปิดให้ sec-rev สานต่อ" --no-skip-permissions --no-workspace -- ./claude -y -m qwen3-coder-plus
clawteam spawn tmux --team qwen-team --agent-name sec-rev --task "รอ code-arch เขียน app/api.py เสร็จแล้วตรวจช่องโหว่ความปลอดภัย หากเจอบอกให้แก้" --no-skip-permissions --no-workspace -- ./claude -y -m glm-4.7
clawteam spawn tmux --team qwen-team --agent-name logic-rev --task "รอ code-arch เสร็จแล้วตรวจสอบ logic บั๊ก" --no-skip-permissions --no-workspace -- ./claude -y -m glm-5
clawteam spawn tmux --team qwen-team --agent-name perf-anal --task "รอ code-arch เสร็จแล้ววิเคราะห์ Big O และปรับแต่ง" --no-skip-permissions --no-workspace -- ./claude -y -m qwen3-coder-plus
clawteam spawn tmux --team qwen-team --agent-name code-qual --task "รอทุกคนเสร็จ ทำ QA และ Unit Test ลงที่ app/test_api.py" --no-skip-permissions --no-workspace -- ./claude -y -m qwen3.5-plus

# --- ระบบจัดระเบียบหน้าจอ Tmux อัตโนมัติ ---
# รวมทุก Agent (Window 1-4) เข้ามาที่ Window 0 และจัด Layout แบบ Tiled
sleep 2 # รอให้ tmux session ตั้งตัวเสร็จ
tmux join-pane -s clawteam-qwen-team:1 -t clawteam-qwen-team:0 2>/dev/null
tmux join-pane -s clawteam-qwen-team:2 -t clawteam-qwen-team:0 2>/dev/null
tmux join-pane -s clawteam-qwen-team:3 -t clawteam-qwen-team:0 2>/dev/null
tmux join-pane -s clawteam-qwen-team:4 -t clawteam-qwen-team:0 2>/dev/null
tmux select-layout -t clawteam-qwen-team:0 tiled 2>/dev/null

echo "Done - Check Dashboard 'qwen-team' or run 'clawteam board attach qwen-team'"
