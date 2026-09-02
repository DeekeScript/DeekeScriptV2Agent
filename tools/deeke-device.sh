#!/usr/bin/env bash
# DeekeScript AI device discovery and debug helper (macOS / Linux)
# Usage: bash tools/deeke-device.sh discover
#   chmod +x tools/deeke-device.sh && ./tools/deeke-device.sh discover

set -euo pipefail

COMMAND="${1:-help}"
CONFIG_FILE="${DEEKE_DEVICE_CONFIG:-.deeke-device.local.json}"
TIMEOUT_MS="${DEEKE_TIMEOUT_MS:-60000}"
TYPE="${DEEKE_SNAPSHOT_TYPE:-0}"

BASE_URL=""
SCRIPT=""
SCRIPT_FILE=""

shift || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    -BaseUrl|--base-url) BASE_URL="${2:-}"; shift 2 ;;
    -Script|--script) SCRIPT="${2:-}"; shift 2 ;;
    -ScriptFile|--script-file) SCRIPT_FILE="${2:-}"; shift 2 ;;
    -Timeout|--timeout) TIMEOUT_MS="${2:-60000}"; shift 2 ;;
    -Type|--type) TYPE="${2:-1}"; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

pretty_json() {
  python3 -m json.tool 2>/dev/null || cat
}

config_path() {
  echo "$(pwd)/$CONFIG_FILE"
}

read_base_url() {
  python3 - "$(config_path)" <<'PY'
import json, sys, os
path = sys.argv[1]
if not os.path.isfile(path):
    sys.exit(0)
with open(path, encoding="utf-8") as f:
    data = json.load(f)
url = (data.get("baseUrl") or "").rstrip("/")
if url:
    print(url)
PY
}

save_config() {
  python3 - "${1%/}" "$(config_path)" <<'PY'
import json, sys
url, path = sys.argv[1], sys.argv[2]
with open(path, "w", encoding="utf-8") as f:
    json.dump({"baseUrl": url}, f, ensure_ascii=False, indent=2)
    f.write("\n")
PY
}

resolve_base_url() {
  if [[ -n "$BASE_URL" ]]; then
    echo "${BASE_URL%/}"
    return
  fi
  local saved
  saved="$(read_base_url || true)"
  if [[ -n "$saved" ]]; then
    echo "$saved"
    return
  fi
  echo "No device URL. Run discover or: deeke-device.sh set --base-url http://192.168.x.x:8080" >&2
  exit 1
}

get_local_lan_ip() {
  local ip=""
  if [[ "$(uname -s)" == "Darwin" ]]; then
    for iface in en0 en1 en2 bridge0; do
      ip="$(ipconfig getifaddr "$iface" 2>/dev/null || true)"
      if [[ "$ip" == 192.168.* ]]; then
        echo "$ip"
        return 0
      fi
    done
  fi
  ip="$(ifconfig 2>/dev/null | awk '/inet / {print $2}' | grep '^192\.168\.' | head -n1 || true)"
  if [[ -n "$ip" ]]; then
    echo "$ip"
    return 0
  fi
  ip="$(hostname -I 2>/dev/null | tr ' ' '\n' | grep '^192\.168\.' | head -n1 || true)"
  echo "$ip"
}

test_tcp_port() {
  local ip="$1" port="$2"
  if command -v nc >/dev/null 2>&1; then
    nc -z -G 1 -w 1 "$ip" "$port" >/dev/null 2>&1
    return $?
  fi
  (echo >/dev/tcp/"$ip"/"$port") >/dev/null 2>&1
}

probe_device() {
  local ip="$1"
  if ! test_tcp_port "$ip" 8080; then
    return 0
  fi
  local resp
  resp="$(curl -fsS --max-time 2 "http://${ip}:8080/ai/status" 2>/dev/null || true)"
  [[ -z "$resp" ]] && return 0
  python3 - "$ip" "$resp" <<'PY'
import json, sys
ip, raw = sys.argv[1], sys.argv[2]
try:
    data = json.loads(raw)
    if data.get("code") == 0:
        print(json.dumps({
            "ip": ip,
            "baseUrl": f"http://{ip}:8080",
            "status": data.get("data"),
        }, ensure_ascii=False))
except Exception:
    pass
PY
}

api_request() {
  local method="$1" path="$2" body="${3:-}"
  local base uri timeout_sec
  base="$(resolve_base_url)"
  uri="${base}${path}"
  if [[ "$method" == "GET" ]]; then
    curl -fsS --max-time 30 "$uri"
  else
    timeout_sec=$(( TIMEOUT_MS / 1000 + 10 ))
    if (( timeout_sec < 30 )); then timeout_sec=30; fi
    curl -fsS --max-time "$timeout_sec" -X POST "$uri" \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d "$body"
  fi
}

cmd_help() {
  pretty_json <<'JSON'
{
  "platform": "macOS/Linux bash",
  "commands": [
    "discover  - scan 192.168.* subnet port 8080",
    "set --base-url [url]  - save device URL",
    "status    - device status and permissions",
    "snapshot  - UI nodes and screenshot",
    "run --script \"...\"  - execute DeekeScript code",
    "run-file --script-file tasks/x.js  - execute project file",
    "stop      - stop running script"
  ]
}
JSON
}

cmd_discover() {
  local local_ip prefix tmp count i ip result
  local_ip="$(get_local_lan_ip || true)"
  if [[ -z "$local_ip" ]]; then
    pretty_json <<'JSON'
{
  "skipScan": true,
  "reason": "Local IP is not 192.168.*, scan skipped",
  "hint": "Ask user for phone URL, e.g. http://192.168.1.113:8080, then: set --base-url [url]",
  "devices": []
}
JSON
    return 0
  fi

  prefix="$(echo "$local_ip" | awk -F. '{print $1"."$2"."$3}')"
  tmp="$(mktemp)"
  count=0
  for i in $(seq 1 254); do
    ip="${prefix}.${i}"
    [[ "$ip" == "$local_ip" ]] && continue
    probe_device "$ip" >>"$tmp" &
    count=$((count + 1))
    if (( count % 48 == 0 )); then
      wait
    fi
  done
  wait

  python3 - "$local_ip" "$prefix" "$tmp" "$(config_path)" <<'PY'
import json, sys, os

local_ip, prefix, tmp_path, config_path = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
devices = []
if os.path.isfile(tmp_path):
    with open(tmp_path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                devices.append(json.loads(line))
            except Exception:
                pass
    os.remove(tmp_path)

result = {
    "skipScan": False,
    "localIp": local_ip,
    "subnet": prefix,
    "devices": devices,
}

if len(devices) == 1:
    url = devices[0]["baseUrl"]
    with open(config_path, "w", encoding="utf-8") as f:
        json.dump({"baseUrl": url}, f, ensure_ascii=False, indent=2)
        f.write("\n")
    result["autoSelected"] = url
    result["configFile"] = config_path
elif len(devices) == 0:
    result["hint"] = "No device found. Enable node viewer on phone, or ask user for URL and run set --base-url"
else:
    result["hint"] = "Multiple devices found. Ask user to pick one, then run set --base-url"

print(json.dumps(result, ensure_ascii=False, indent=2))
PY
}

cmd_set() {
  if [[ -z "$BASE_URL" ]]; then
    echo "Missing --base-url, e.g. http://192.168.1.113:8080" >&2
    exit 1
  fi
  local url resp
  url="${BASE_URL%/}"
  resp="$(curl -fsS --max-time 5 "${url}/ai/status")"
  python3 - "$url" "$resp" "$(config_path)" <<'PY' | pretty_json
import json, sys
url, resp_raw, config_path = sys.argv[1], sys.argv[2], sys.argv[3]
data = json.loads(resp_raw)
if data.get("code") != 0:
    raise SystemExit(f"Cannot connect DeekeScript: {data.get('msg')}")
with open(config_path, "w", encoding="utf-8") as f:
    json.dump({"baseUrl": url}, f, ensure_ascii=False, indent=2)
    f.write("\n")
print(json.dumps({
    "code": 0,
    "baseUrl": url,
    "configFile": config_path,
    "status": data.get("data"),
}, ensure_ascii=False, indent=2))
PY
}

cmd_status() {
  api_request GET "/ai/status" | pretty_json
}

cmd_snapshot() {
  api_request GET "/ai/snapshot?type=${TYPE}&image=1" | pretty_json
}

cmd_run() {
  if [[ -z "$SCRIPT" ]]; then
    echo "Missing --script" >&2
    exit 1
  fi
  local body
  body="$(python3 - "$SCRIPT" "$TIMEOUT_MS" <<'PY'
import json, sys
print(json.dumps({
    "script": sys.argv[1],
    "file": "ai_debug.js",
    "timeout": int(sys.argv[2]),
}))
PY
)"
  api_request POST "/ai/run" "$body" | pretty_json
}

cmd_run_file() {
  if [[ -z "$SCRIPT_FILE" ]]; then
    echo "Missing --script-file" >&2
    exit 1
  fi
  local body
  body="$(python3 - "$SCRIPT_FILE" "$TIMEOUT_MS" <<'PY'
import json, sys
print(json.dumps({
    "file": sys.argv[1],
    "timeout": int(sys.argv[2]),
}))
PY
)"
  api_request POST "/ai/run-file" "$body" | pretty_json
}

cmd_stop() {
  api_request POST "/ai/stop" "{}" | pretty_json
}

case "$COMMAND" in
  help) cmd_help ;;
  discover) cmd_discover ;;
  set) cmd_set ;;
  status) cmd_status ;;
  snapshot) cmd_snapshot ;;
  run) cmd_run ;;
  run-file) cmd_run_file ;;
  stop) cmd_stop ;;
  *)
    echo "Unknown command: $COMMAND" >&2
    cmd_help
    exit 1
    ;;
esac
