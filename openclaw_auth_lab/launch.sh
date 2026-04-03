#!/usr/bin/env bash
export OPENCLAW_PROFILE=auth-lab
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPT_DIR"
# เริ่มต้น Tmux Server และทำความสะอาดข้อมูลเก่า
tmux start-server
tmux kill-session -t clawteam-openclaw-team 2>/dev/null || true
rm -rf ~/.clawteam/teams/openclaw-team*
rm -rf ~/.clawteam/tasks/openclaw-team*

# สั่งให้พวกมันสร้างผลงานในโฟลเดอร์ app/ เท่านั้น
mkdir -p app
openclaw setup --workspace "$SCRIPT_DIR/app"
source "${SCRIPT_DIR}/setup_workspace_meta.sh"

# ผูกตัวตนเอเจนต์ (Identity Persistence) พร้อมระบุ Model ตามหน้าที่
echo "Setting up 10-Agent SDLC Swarm with specific models..."
openclaw agents add sys-planner --workspace "$SCRIPT_DIR/app" --model "bailian/glm-5" --non-interactive
openclaw agents add ui-designer --workspace "$SCRIPT_DIR/app" --model "bailian/kimi-k2.5" --non-interactive
openclaw agents add db-admin    --workspace "$SCRIPT_DIR/app" --model "bailian/qwen3.5-plus" --non-interactive
openclaw agents add code-arch   --workspace "$SCRIPT_DIR/app" --model "bailian/qwen3-coder-plus" --non-interactive
openclaw agents add sec-rev     --workspace "$SCRIPT_DIR/app" --model "bailian/glm-4.7" --non-interactive
openclaw agents add logic-rev   --workspace "$SCRIPT_DIR/app" --model "bailian/glm-5" --non-interactive
openclaw agents add perf-anal   --workspace "$SCRIPT_DIR/app" --model "bailian/qwen3-coder-plus" --non-interactive
openclaw agents add code-qual   --workspace "$SCRIPT_DIR/app" --model "bailian/qwen3.5-plus" --non-interactive
openclaw agents add devops-eng  --workspace "$SCRIPT_DIR/app" --model "bailian/qwen3-coder-plus" --non-interactive
openclaw agents add ada-pm      --workspace "$SCRIPT_DIR/app" --model "bailian/qwen3-max-2026-01-23" --non-interactive

clawteam team spawn-team openclaw-team -d "Full SDLC 10-Agent Swarm"

# The DAG Task Flow
echo "Creating tasks..."
T0=$(clawteam task create openclaw-team "System Planning" --owner sys-planner -d "Write implementation_plan.md and API specs in app/" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)
T1=$(clawteam task create openclaw-team "UI/UX Design" --owner ui-designer -d "Design UI mockups in HTML/CSS at app/" --blocked-by "$T0" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)
T2=$(clawteam task create openclaw-team "DB Architecture" --owner db-admin -d "Design and setup SQLite/PostgreSQL schema at app/db.py" --blocked-by "$T0" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)
T3=$(clawteam task create openclaw-team "Build API" --owner code-arch -d "Write Flask API at app/api.py linking DB and UI" --blocked-by "$T1,$T2" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)

# QA Reviewers
T4=$(clawteam task create openclaw-team "Security Review" --owner sec-rev -d "Check for vulnerabilities in app/api.py. Inbox send if error." --blocked-by "$T3" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)
T5=$(clawteam task create openclaw-team "Logic Review" --owner logic-rev -d "Check logic/edge cases in app/. Inbox send if error." --blocked-by "$T3" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)
T6=$(clawteam task create openclaw-team "Performance Analysis" --owner perf-anal -d "Analyze speed and overhead in app/. Inbox send if error." --blocked-by "$T3" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)

# Final QA & DevOps
T7=$(clawteam task create openclaw-team "Code Quality & QA" --owner code-qual -d "Run unit tests. Inbox send if error." --blocked-by "$T4,$T5,$T6" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)
T8=$(clawteam task create openclaw-team "DevOps & Deployment" --owner devops-eng -d "Write Dockerfile and docker-compose.yml" --blocked-by "$T7" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)
T9=$(clawteam task create openclaw-team "Project Management" --owner ada-pm -d "Final review and write PROJECT_REPORT.md" --blocked-by "$T8" | grep -o 'id: [a-f0-9]*' | cut -d' ' -f2)

echo "Spawning agents in tmux..."
clawteam spawn tmux openclaw --team openclaw-team --agent-name sys-planner --task "รอทำงาน T0" --no-skip-permissions --no-workspace
clawteam spawn tmux openclaw --team openclaw-team --agent-name ui-designer --task "รอทำงาน T1" --no-skip-permissions --no-workspace
clawteam spawn tmux openclaw --team openclaw-team --agent-name db-admin --task "รอทำงาน T2" --no-skip-permissions --no-workspace
clawteam spawn tmux openclaw --team openclaw-team --agent-name code-arch --task "รอทำงาน T3" --no-skip-permissions --no-workspace

clawteam spawn tmux openclaw --team openclaw-team --agent-name sec-rev --task "รอทำงาน T4" --no-skip-permissions --no-workspace
clawteam spawn tmux openclaw --team openclaw-team --agent-name logic-rev --task "รอทำงาน T5" --no-skip-permissions --no-workspace
clawteam spawn tmux openclaw --team openclaw-team --agent-name perf-anal --task "รอทำงาน T6" --no-skip-permissions --no-workspace
clawteam spawn tmux openclaw --team openclaw-team --agent-name code-qual --task "รอทำงาน T7" --no-skip-permissions --no-workspace

clawteam spawn tmux openclaw --team openclaw-team --agent-name devops-eng --task "รอทำงาน T8" --no-skip-permissions --no-workspace
clawteam spawn tmux openclaw --team openclaw-team --agent-name ada-pm --task "รอทำงาน T9" --no-skip-permissions --no-workspace

# --- ระบบจัดระเบียบหน้าจอ Tmux อัตโนมัติ ---
sleep 3 # รอให้ tmux session ตั้งตัวเสร็จ
for i in {1..9}; do
  tmux join-pane -s "clawteam-openclaw-team:$i" -t "clawteam-openclaw-team:0" 2>/dev/null
done
tmux select-layout -t clawteam-openclaw-team:0 tiled 2>/dev/null

# --- เปิด Dashboard อัตโนมัติ (เพื่อให้เข้าถึงผ่าน Tailscale ได้) ---
sleep 3 # รอเพื่อความชัวร์ก่อนสร้าง Window ใหม่
tmux new-window -t clawteam-openclaw-team -n "dashboard" "clawteam board serve --port 8081 --host 0.0.0.0"

echo "========================================================================="
echo "Done - Check Dashboard at http://localhost:8081/"
echo "Remote access (if configured): http://<your-remote-ip>:8081/"
echo "Or run 'clawteam board attach openclaw-team' to see agents"
echo "========================================================================="
