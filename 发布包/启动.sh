#!/bin/bash
# ============================================================
# 微笑社区 · 一键启动(服务器通用版)
# 用法: 进入本目录后执行  bash 启动.sh
#   - 需要已安装 Java 21(可用 JAVA_HOME 指定)
#   - 数据与图片存本目录的 data/ 与 uploads/(首次启动自动建库)
#   - 默认监听 8080,浏览器访问 http://服务器IP:8080
# ============================================================
cd "$(dirname "$0")" || exit 1

# 找 Java(优先用 JAVA_HOME,否则用 PATH 里的 java)
if [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
  JAVA="$JAVA_HOME/bin/java"
else
  JAVA="$(command -v java)"
fi
if [ -z "$JAVA" ]; then
  echo "[错误] 找不到 Java 21。请先安装,或用 JAVA_HOME 指定路径。"
  exit 1
fi
echo "[微笑] 使用 Java: $($JAVA -version 2>&1 | head -1)"

JAR="smile-backend-0.1.0.jar"
if [ ! -f "$JAR" ]; then
  echo "[错误] 缺少 $JAR,请把它和本脚本放在同一目录。"
  exit 1
fi

nohup "$JAVA" -jar "$JAR" > smile.log 2>&1 &
echo "[微笑] 后端已启动 (PID $!) → 日志: smile.log"
echo "[微笑] 等待就绪…"
for i in $(seq 1 40); do
  sleep 2
  if curl -s -o /dev/null --max-time 2 https://simbasmile.pages.dev/api/members 2>/dev/null; then
    echo "[微笑] ✅ 已就绪: http://localhost:8080"
    break
  fi
  if [ "$i" -eq 40 ]; then
    echo "[微笑] ❌ 启动超时,请看 smile.log"
  fi
done
