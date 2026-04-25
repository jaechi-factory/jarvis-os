#!/usr/bin/env bash
# PostToolUse audit logger.
# Records ALL tool invocations to a daily JSONL file for trace/verification.
#
# Goal: prove that what L1 *claims* in the 5-block report (Echo + 지시 체인 + 실행)
#       actually happened. If Echo says "called code-reviewer" but no Agent
#       invocation appears in audit log → Echo가 거짓.
#
# Storage: ~/.claude/audit/YYYY-MM-DD.jsonl
# One JSONL line per tool call. Append-only.
# Compatible with /trace slash command.

input=$(cat)
audit_dir="$HOME/.claude/audit"
mkdir -p "$audit_dir"

date_today=$(date +%Y-%m-%d)
log_file="${audit_dir}/${date_today}.jsonl"

# Pass via env var (heredoc-safe — stdin is taken by python script body)
export CLAUDE_AUDIT_INPUT="$input"
export CLAUDE_AUDIT_LOG="$log_file"

python3 <<'PY' 2>/dev/null
import os, json, datetime, sys

raw = os.environ.get('CLAUDE_AUDIT_INPUT', '')
log_path = os.environ.get('CLAUDE_AUDIT_LOG', '')
if not raw or not log_path:
    sys.exit(0)

try:
    data = json.loads(raw)
except Exception:
    sys.exit(0)

tool = data.get('tool_name', '')
session = data.get('session_id', '')
ts = datetime.datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
tin = data.get('tool_input', {}) or {}
tres = data.get('tool_response', {}) or {}

record = {'ts': ts, 'session': session, 'tool': tool}

if tool in ('Agent', 'Task'):
    record['agent'] = tin.get('subagent_type') or 'general-purpose'
    record['desc'] = (tin.get('description') or '')[:120]
    if tin.get('model'):
        record['model'] = tin['model']
elif tool == 'Skill':
    record['skill'] = tin.get('skill', '')
    if tin.get('args'):
        record['args'] = str(tin['args'])[:80]
elif tool == 'Bash':
    record['cmd'] = (tin.get('command') or '')[:200]
    if isinstance(tres, dict):
        record['exit'] = tres.get('exit_code', 0)
    record['bg'] = bool(tin.get('run_in_background'))
elif tool in ('Edit', 'Write', 'MultiEdit'):
    record['path'] = tin.get('file_path', '')
elif tool == 'Read':
    record['path'] = tin.get('file_path', '')
elif tool == 'mcp__codex-cli__codex':
    record['codex_prompt_head'] = (tin.get('prompt') or '')[:120]
elif tool.startswith('mcp__'):
    record['mcp'] = tool
elif tool == 'WebFetch':
    record['url'] = tin.get('url', '')
elif tool == 'WebSearch':
    record['query'] = (tin.get('query') or '')[:120]

try:
    with open(log_path, 'a', encoding='utf-8') as f:
        f.write(json.dumps(record, ensure_ascii=False) + '\n')
except Exception:
    pass

# Rule/memory file change markers (for Stop hook auto-actions)
# Triggers C-8 (auto /check-rules) and C-9 (memory index check)
if tool in ('Write', 'Edit', 'MultiEdit'):
    path = tin.get('file_path', '')
    home = os.path.expanduser('~')
    is_rule = False
    is_memory = False
    rule_paths = [
        f'{home}/.claude/CLAUDE.md', f'{home}/.claude/RULES.md',
        f'{home}/.claude/AGENTS_SYSTEM.md', f'{home}/.claude/AGENTS_REFERENCE.md',
        f'{home}/.claude/FLAGS.md',
    ]
    if path in rule_paths or path.startswith(f'{home}/.claude/modes/') or \
       path.startswith(f'{home}/.claude/rules/common/'):
        is_rule = True
    if path.startswith(f'{home}/.claude/projects/{home.replace(chr(47), chr(45))}/memory/'):
        is_memory = True
        # Memory is also a "rule-like" change → trigger /check-rules too
        is_rule = True
    if session and is_rule:
        try:
            open(f'{home}/.claude/audit/.rule-changed-{session}', 'a').write(path + '\n')
        except Exception: pass
    if session and is_memory and tool == 'Write':
        # Write to memory dir = potentially new file → check indexing
        try:
            open(f'{home}/.claude/audit/.memory-new-{session}', 'a').write(path + '\n')
        except Exception: pass
PY

exit 0
