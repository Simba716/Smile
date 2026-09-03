#!/bin/bash
# 微笑社区 · 停止后端
# 用法: 进入本目录后执行  bash 停止.sh
PID=$(ps aux | grep "smile-backend-0.1.0.jar" | grep -v grep | awk '{print $2}' | head -1)
if [ -n "$PID" ]; then
  kill "$PID" 2>/dev/null
  echo "[微笑] 已停止后端 (PID $PID)"
else
  echo "[微笑] 后端本来就没在运行"
fi
