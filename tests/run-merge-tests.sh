#!/bin/bash
# JARVIS-OS v1.3 Phase 1 — merge-settings.py 회귀 테스트 러너
# 4개 픽스처 케이스를 머지하고 핵심 어설션으로 검증.

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MERGE="$ROOT_DIR/core/scripts/merge-settings.py"
TEMPLATE="$ROOT_DIR/settings.template.json"

PASS=0
FAIL=0

run_case() {
    local case_dir="$1"
    local name=$(basename "$case_dir")
    local existing="$case_dir/existing.json"
    local actual="$case_dir/actual.json"
    local stderr_log="$case_dir/stderr.log"

    echo ""
    echo "═══════════════════════════════════════════"
    echo "[$name]"
    echo "═══════════════════════════════════════════"

    python3 "$MERGE" \
        --existing "$existing" \
        --template "$TEMPLATE" \
        --output "$actual" \
        2> "$stderr_log"

    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        echo "❌ merge-settings.py exit=$exit_code"
        echo "   stderr:"
        sed 's/^/     /' "$stderr_log"
        FAIL=$((FAIL+1))
        return
    fi

    # stderr 내용 미리보기
    if [[ -s "$stderr_log" ]]; then
        echo "[stderr (경고/info)]"
        sed 's/^/  /' "$stderr_log"
    fi

    # case별 어설션
    case "$name" in
        case1-empty)
            assert_case1 "$actual"
            ;;
        case2-user-additions)
            assert_case2 "$actual" "$stderr_log"
            ;;
        case3-plugin-false)
            assert_case3 "$actual" "$stderr_log"
            ;;
        case4-marketplace-conflict)
            assert_case4 "$actual" "$stderr_log"
            ;;
    esac
}

assert() {
    local desc="$1"
    local actual="$2"
    local expected="$3"
    if [[ "$actual" == "$expected" ]]; then
        echo "  ✅ $desc — $actual"
        PASS=$((PASS+1))
    else
        echo "  ❌ $desc — expected=$expected, actual=$actual"
        FAIL=$((FAIL+1))
    fi
}

assert_contains_stderr() {
    local desc="$1"
    local stderr_log="$2"
    local pattern="$3"
    if grep -q "$pattern" "$stderr_log"; then
        echo "  ✅ $desc"
        PASS=$((PASS+1))
    else
        echo "  ❌ $desc — pattern not in stderr: $pattern"
        FAIL=$((FAIL+1))
    fi
}

py_query() {
    local file="$1"
    local expr="$2"
    python3 -c "import json; d=json.load(open('$file')); print($expr)"
}

# ─── case1: 빈 settings (신규 설치) ───
assert_case1() {
    local f="$1"
    echo "[어설션]"
    assert "enabledPlugins 키 26개" "$(py_query "$f" 'len(d["enabledPlugins"])')" "26"
    assert "permissions.allow 비어있지 않음" \
        "$(py_query "$f" 'len(d["permissions"]["allow"]) > 0')" "True"
    assert "hooks.PreToolUse 존재" \
        "$(py_query "$f" '"PreToolUse" in d["hooks"]')" "True"
    assert "hooks.SessionStart 존재" \
        "$(py_query "$f" '"SessionStart" in d["hooks"]')" "True"
    assert "extraKnownMarketplaces 5개" \
        "$(py_query "$f" 'len(d["extraKnownMarketplaces"])')" "5"
    assert "alwaysThinkingEnabled=true" \
        "$(py_query "$f" 'd["alwaysThinkingEnabled"]')" "True"
    assert "theme=dark-daltonized" \
        "$(py_query "$f" 'd["theme"]')" "dark-daltonized"
}

# ─── case2: 사용자 hook + allow + 사용자 우선 단일값 ───
assert_case2() {
    local f="$1"
    local s="$2"
    echo "[어설션]"
    assert "사용자 allow 'Bash(custom-tool:*)' 포함" \
        "$(py_query "$f" '"Bash(custom-tool:*)" in d["permissions"]["allow"]')" "True"
    assert "JARVIS allow 'Bash(*)' 포함 (사용자도 같은 값 → 1회만)" \
        "$(py_query "$f" 'd["permissions"]["allow"].count("Bash(*)")')" "1"
    assert "사용자 deny 'Bash(*curl*example-evil.com*)' 포함" \
        "$(py_query "$f" '"Bash(*curl*example-evil.com*)" in d["permissions"]["deny"]')" "True"
    assert "defaultMode 사용자 우선 (ask)" \
        "$(py_query "$f" 'd["permissions"]["defaultMode"]')" "ask"
    assert "additionalDirectories에 사용자 /Users/me/work 포함" \
        "$(py_query "$f" '"/Users/me/work" in d["permissions"]["additionalDirectories"]')" "True"
    assert "additionalDirectories에 JARVIS /tmp 포함" \
        "$(py_query "$f" '"/tmp" in d["permissions"]["additionalDirectories"]')" "True"

    # hooks 순서 검증 — PreToolUse Bash matcher에서 JARVIS hook이 먼저
    assert "PreToolUse Bash matcher 첫 hook이 JARVIS rm 차단 hook" \
        "$(python3 -c "
import json
d = json.load(open('$f'))
for entry in d['hooks']['PreToolUse']:
    if entry['matcher'] == 'Bash':
        first_cmd = entry['hooks'][0]['command']
        print('rm -rf' in first_cmd)
        break
")" "True"
    assert "PreToolUse Bash matcher 마지막 hook이 사용자 my-custom-pre-bash-hook" \
        "$(python3 -c "
import json
d = json.load(open('$f'))
for entry in d['hooks']['PreToolUse']:
    if entry['matcher'] == 'Bash':
        last_cmd = entry['hooks'][-1]['command']
        print('my-custom-pre-bash-hook' in last_cmd)
        break
")" "True"

    # Stop matcher 비어있는 사용자 hook도 추가
    assert "Stop matcher='' 에 사용자 my-custom-stop-hook 포함" \
        "$(python3 -c "
import json
d = json.load(open('$f'))
found = False
for entry in d['hooks']['Stop']:
    for h in entry['hooks']:
        if 'my-custom-stop-hook' in h.get('command', ''):
            found = True
print(found)
")" "True"

    assert "alwaysThinkingEnabled 사용자 우선 (false)" \
        "$(py_query "$f" 'd["alwaysThinkingEnabled"]')" "False"
    assert "theme 사용자 우선 (light)" \
        "$(py_query "$f" 'd["theme"]')" "light"
    assert "알 수 없는 키 customField passthrough" \
        "$(py_query "$f" 'd.get("customField", {}).get("myProjectId")')" "abc-123"
    assert_contains_stderr "passthrough 알림 stderr 출력" "$s" "customField"
}

# ─── case3: enabledPlugins false 명시 ───
assert_case3() {
    local f="$1"
    local s="$2"
    echo "[어설션]"
    assert "claude-mem 사용자 false 유지" \
        "$(py_query "$f" 'd["enabledPlugins"]["claude-mem@thedotmack"]')" "False"
    assert "compound-engineering 사용자 true 유지" \
        "$(py_query "$f" 'd["enabledPlugins"]["compound-engineering@compound-engineering-plugin"]')" "True"
    assert "my-private-plugin 사용자 추가 보존" \
        "$(py_query "$f" 'd["enabledPlugins"]["my-private-plugin@my-marketplace"]')" "True"
    # JARVIS 신규 추가
    assert "JARVIS superpowers 추가됨" \
        "$(py_query "$f" '"superpowers@claude-plugins-official" in d["enabledPlugins"]')" "True"
    assert_contains_stderr "claude-mem false 충돌 경고 stderr 출력" \
        "$s" "claude-mem@thedotmack.*false"
}

# ─── case4: extraKnownMarketplaces 충돌 (사용자 우선 정책) ───
assert_case4() {
    local f="$1"
    local s="$2"
    echo "[어설션]"
    # pm-skills: source 다름 → 사용자 fork 유지
    assert "pm-skills source 사용자 fork 유지" \
        "$(py_query "$f" 'd["extraKnownMarketplaces"]["pm-skills"]["source"]["repo"]')" \
        "my-org/pm-skills-fork"
    # compound-engineering: source 동일 → 그대로
    assert "compound-engineering-plugin source 동일 (EveryInc)" \
        "$(py_query "$f" 'd["extraKnownMarketplaces"]["compound-engineering-plugin"]["source"]["repo"]')" \
        "EveryInc/compound-engineering-plugin"
    # 사용자 전용 마켓플레이스 보존
    assert "my-private-marketplace 사용자 전용 보존" \
        "$(py_query "$f" 'd["extraKnownMarketplaces"]["my-private-marketplace"]["source"]["repo"]')" \
        "my-org/private-marketplace"
    # JARVIS 다른 마켓플레이스 추가 (사용자 settings엔 없는 JARVIS 기본 키)
    assert "ui-ux-pro-max-skill JARVIS 마켓플레이스 추가" \
        "$(py_query "$f" '"ui-ux-pro-max-skill" in d["extraKnownMarketplaces"]')" "True"
    assert "designer-skills JARVIS 마켓플레이스 추가" \
        "$(py_query "$f" '"designer-skills" in d["extraKnownMarketplaces"]')" "True"
    assert_contains_stderr "pm-skills source 충돌 경고 stderr 출력" \
        "$s" "pm-skills.*source 다름"
}

# ─── 실행 ───
echo "JARVIS-OS v1.3 Phase 1 — merge-settings.py 회귀 테스트"
echo "Template: $TEMPLATE"
echo "Merge script: $MERGE"

for case_dir in "$ROOT_DIR"/tests/fixtures/case*/; do
    [[ -d "$case_dir" ]] && run_case "$case_dir"
done

echo ""
echo "═══════════════════════════════════════════"
echo "결과: PASS=$PASS · FAIL=$FAIL"
echo "═══════════════════════════════════════════"

[[ "$FAIL" -eq 0 ]] && exit 0 || exit 1
