#!/usr/bin/env python3
"""
JARVIS-OS settings.json 자동 병합 도구 (v1.3 Phase 1).

기존 사용자 settings.json + JARVIS settings.template.json → 머지된 출력 JSON.

머지 정책:
  - permissions.allow / deny / additionalDirectories : 합집합 + 중복 제거
  - permissions.defaultMode, theme, alwaysThinkingEnabled : 사용자 우선
  - hooks                                              : JARVIS 먼저 + 사용자 나중, command 중복 제거
  - enabledPlugins                                     : 합집합. 사용자 false 명시 → false 유지 + 경고
  - extraKnownMarketplaces                             : 합집합. source 충돌 시 사용자 우선 + 경고
                                                        (fork·mirror·사내 source 보호)
  - 알 수 없는 최상위 키                                 : 사용자 값 그대로 보존 (passthrough)

사용법:
  python3 merge-settings.py --existing <path> --template <path> --output <path>

종료 코드:
  0 : 성공
  1 : 입력 파일 누락
  2 : JSON 파싱 실패
"""

import argparse
import json
import os
import sys
from pathlib import Path


def warn(msg: str) -> None:
    print(f"⚠️  {msg}", file=sys.stderr)


def info(msg: str) -> None:
    print(f"ℹ️  {msg}", file=sys.stderr)


def merge_array_unique(existing, template):
    """배열 합집합 + 중복 제거. 순서: 사용자 먼저 → 템플릿 추가."""
    seen = set()
    result = []
    for item in (existing or []):
        if item not in seen:
            result.append(item)
            seen.add(item)
    for item in (template or []):
        if item not in seen:
            result.append(item)
            seen.add(item)
    return result


def normalize_path(p: str) -> str:
    """경로 정규화 (additionalDirectories 중복 판정용)."""
    return os.path.realpath(os.path.expanduser(p))


def merge_dirs_unique(existing, template):
    """경로 정규화 후 중복 제거."""
    seen_norm = set()
    result = []
    for item in (existing or []):
        norm = normalize_path(item)
        if norm not in seen_norm:
            seen_norm.add(norm)
            result.append(item)
    for item in (template or []):
        norm = normalize_path(item)
        if norm not in seen_norm:
            seen_norm.add(norm)
            result.append(item)
    return result


def merge_permissions(existing_perm, template_perm):
    existing_perm = existing_perm or {}
    template_perm = template_perm or {}

    merged = {
        "allow": merge_array_unique(
            existing_perm.get("allow", []),
            template_perm.get("allow", []),
        ),
        "deny": merge_array_unique(
            existing_perm.get("deny", []),
            template_perm.get("deny", []),
        ),
        "additionalDirectories": merge_dirs_unique(
            existing_perm.get("additionalDirectories", []),
            template_perm.get("additionalDirectories", []),
        ),
    }
    # defaultMode: 사용자 우선
    if "defaultMode" in existing_perm:
        merged["defaultMode"] = existing_perm["defaultMode"]
    elif "defaultMode" in template_perm:
        merged["defaultMode"] = template_perm["defaultMode"]
    return merged


def hook_command(hook_obj) -> str:
    return hook_obj.get("command", "")


def merge_hook_entries(existing_entries, template_entries):
    """
    같은 phase 안의 HookEntry 배열을 matcher별로 그룹화 후 머지.
    - 같은 matcher: JARVIS hooks 먼저 + 사용자 hooks 나중. command 중복 제거.
    - 다른 matcher: 둘 다 유지 (등장 순서 보존)
    """
    existing_entries = existing_entries or []
    template_entries = template_entries or []

    by_matcher = {}
    matcher_order = []

    for entry in template_entries:
        matcher = entry.get("matcher", "")
        if matcher not in by_matcher:
            by_matcher[matcher] = {"template": [], "existing": []}
            matcher_order.append(matcher)
        by_matcher[matcher]["template"].extend(entry.get("hooks", []))

    for entry in existing_entries:
        matcher = entry.get("matcher", "")
        if matcher not in by_matcher:
            by_matcher[matcher] = {"template": [], "existing": []}
            matcher_order.append(matcher)
        by_matcher[matcher]["existing"].extend(entry.get("hooks", []))

    result = []
    for matcher in matcher_order:
        bucket = by_matcher[matcher]
        merged_hooks = []
        seen_cmds = set()

        # JARVIS 먼저
        for h in bucket["template"]:
            cmd = hook_command(h)
            if cmd and cmd not in seen_cmds:
                merged_hooks.append(h)
                seen_cmds.add(cmd)

        # 사용자 나중
        for h in bucket["existing"]:
            cmd = hook_command(h)
            if cmd and cmd not in seen_cmds:
                merged_hooks.append(h)
                seen_cmds.add(cmd)
            elif cmd in seen_cmds:
                short = cmd if len(cmd) <= 80 else cmd[:77] + "..."
                info(f"hooks: 중복 command 1회만 등록 (matcher='{matcher}'): {short}")

        if merged_hooks:
            result.append({
                "matcher": matcher,
                "hooks": merged_hooks,
            })
    return result


def merge_hooks(existing_hooks, template_hooks):
    existing_hooks = existing_hooks or {}
    template_hooks = template_hooks or {}

    all_phases = list(template_hooks.keys()) + [
        p for p in existing_hooks.keys() if p not in template_hooks
    ]
    result = {}
    for phase in all_phases:
        merged = merge_hook_entries(
            existing_hooks.get(phase, []),
            template_hooks.get(phase, []),
        )
        if merged:
            result[phase] = merged
    return result


def merge_enabled_plugins(existing_plugins, template_plugins):
    """
    enabledPlugins 머지.
    - 사용자 false 명시 + JARVIS true → false 유지 + 경고
    - 그 외엔 사용자 값 우선, JARVIS 신규는 추가
    """
    existing_plugins = existing_plugins or {}
    template_plugins = template_plugins or {}

    result = dict(existing_plugins)

    for key, jarvis_val in template_plugins.items():
        if key in existing_plugins:
            user_val = existing_plugins[key]
            if user_val is False and jarvis_val is True:
                plugin_name = key.split("@")[0] if "@" in key else key
                warn(
                    f"enabledPlugins 충돌: '{key}' 사용자 false. JARVIS 권장(true) 무시. "
                    f"활성화하려면: claude plugin enable {plugin_name}"
                )
                # 사용자 false 유지
        else:
            result[key] = jarvis_val
    return result


def merge_extra_marketplaces(existing_mkt, template_mkt):
    """
    extraKnownMarketplaces 머지.
    - 같은 key, source 다름 → 사용자 우선 + 경고 (fork/mirror/사내 source 보호)
    - 같은 key, source 동일 → 사용자 그대로
    - JARVIS만 있는 키 → 추가
    """
    existing_mkt = existing_mkt or {}
    template_mkt = template_mkt or {}

    result = dict(existing_mkt)

    for key, jarvis_def in template_mkt.items():
        if key in existing_mkt:
            user_def = existing_mkt[key]
            user_source = user_def.get("source") if isinstance(user_def, dict) else None
            jarvis_source = jarvis_def.get("source") if isinstance(jarvis_def, dict) else None
            if user_source != jarvis_source:
                warn(
                    f"extraKnownMarketplaces 충돌: '{key}' source 다름. 사용자 값 유지.\n"
                    f"     사용자: {user_source}\n"
                    f"     JARVIS: {jarvis_source}\n"
                    f"     (fork/mirror/사내 source 보호 정책. 의도와 다르면 settings.json 직접 편집)"
                )
            # 사용자 값 유지 (이미 result[key] = user_def)
        else:
            result[key] = jarvis_def
    return result


def merge_settings(existing, template):
    """최상위 머지."""
    existing = existing or {}
    template = template or {}

    known_keys = {
        "permissions",
        "hooks",
        "enabledPlugins",
        "extraKnownMarketplaces",
        "alwaysThinkingEnabled",
        "theme",
    }

    result = {}

    # 1. permissions
    if "permissions" in existing or "permissions" in template:
        result["permissions"] = merge_permissions(
            existing.get("permissions"),
            template.get("permissions"),
        )

    # 2. hooks
    if "hooks" in existing or "hooks" in template:
        merged = merge_hooks(
            existing.get("hooks"),
            template.get("hooks"),
        )
        if merged:
            result["hooks"] = merged

    # 3. enabledPlugins
    if "enabledPlugins" in existing or "enabledPlugins" in template:
        result["enabledPlugins"] = merge_enabled_plugins(
            existing.get("enabledPlugins"),
            template.get("enabledPlugins"),
        )

    # 4. extraKnownMarketplaces
    if "extraKnownMarketplaces" in existing or "extraKnownMarketplaces" in template:
        result["extraKnownMarketplaces"] = merge_extra_marketplaces(
            existing.get("extraKnownMarketplaces"),
            template.get("extraKnownMarketplaces"),
        )

    # 5. 사용자 우선 단일값
    if "alwaysThinkingEnabled" in existing:
        result["alwaysThinkingEnabled"] = existing["alwaysThinkingEnabled"]
    elif "alwaysThinkingEnabled" in template:
        result["alwaysThinkingEnabled"] = template["alwaysThinkingEnabled"]

    if "theme" in existing:
        result["theme"] = existing["theme"]
    elif "theme" in template:
        result["theme"] = template["theme"]

    # 6. 알 수 없는 최상위 키 passthrough (사용자 우선)
    for key in existing:
        if key not in known_keys and key not in result:
            info(f"알 수 없는 최상위 키 passthrough: '{key}' (사용자 값 유지)")
            result[key] = existing[key]
    for key in template:
        if key not in known_keys and key not in result:
            info(f"알 수 없는 최상위 키 passthrough: '{key}' (JARVIS 값 추가)")
            result[key] = template[key]

    return result


def main() -> int:
    parser = argparse.ArgumentParser(
        description="JARVIS-OS settings.json 자동 병합 도구"
    )
    parser.add_argument("--existing", required=True, help="기존 사용자 settings.json 경로")
    parser.add_argument("--template", required=True, help="JARVIS settings.template.json 경로")
    parser.add_argument("--output", required=True, help="머지된 출력 경로")
    args = parser.parse_args()

    existing_path = Path(args.existing)
    template_path = Path(args.template)
    output_path = Path(args.output)

    if not template_path.exists():
        print(f"❌ template 파일 없음: {template_path}", file=sys.stderr)
        return 1

    try:
        template = json.loads(template_path.read_text())
    except json.JSONDecodeError as e:
        print(f"❌ template JSON 파싱 실패: {e}", file=sys.stderr)
        return 2

    if existing_path.exists():
        try:
            existing = json.loads(existing_path.read_text())
        except json.JSONDecodeError as e:
            print(f"❌ 사용자 settings JSON 파싱 실패: {e}", file=sys.stderr)
            return 2
    else:
        info(f"기존 settings.json 없음 → 신규 설치 모드 (템플릿 통째 복사 효과)")
        existing = {}

    merged = merge_settings(existing, template)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(
        json.dumps(merged, indent=2, ensure_ascii=False) + "\n"
    )

    print(f"✅ 머지 완료: {output_path}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
