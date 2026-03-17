# ai-agent-toolkit

Offline install artifacts for a Linux x86_64 / RHEL 9 environment.

Included tools:

- `gt` `0.12.0`
- `bd` `0.61.0`
- `paperclipai` `0.3.1`

Target:

- `Linux x86_64`
- intended for `RHEL 9` or a compatible glibc-based container/host

Contents:

- `artifacts/ai-agent-toolkit-rhel9-x64.tar.gz.part-*`
- `artifacts/ai-agent-toolkit-rhel9-x64.tar.gz.sha256`
- `CLAUDE-IN-CONTAINER.md`

Install on the target machine:

```bash
cd artifacts
cat ai-agent-toolkit-rhel9-x64.tar.gz.part-* > ai-agent-toolkit-rhel9-x64.tar.gz
shasum -a 256 ai-agent-toolkit-rhel9-x64.tar.gz
tar -xzf ai-agent-toolkit-rhel9-x64.tar.gz
cd ai-agent-toolkit-rhel9-x64
./install.sh --prefix "$HOME/.local/ai-agent-toolkit"
export PATH="$HOME/.local/ai-agent-toolkit/bin:$PATH"
gt version
bd version
paperclipai --version
```

Notes:

- `paperclipai` requires `node >= 20` on the target.
- This bundle was assembled on `2026-03-18`.
- The Linux binaries were fetched specifically for Linux x64. They were not executed locally on macOS.
