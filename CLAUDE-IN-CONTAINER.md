# Claude In Container

This is the shortest path for a Claude-driven agent running inside a Linux x86_64 container on RHEL 9 or a compatible base image.

## Assumptions

- container is `linux/x86_64`
- `node >= 20` is installed
- `git`, `tar`, and `shasum` are available
- you can clone this repo from inside the container

## Bootstrap

```bash
git clone https://github.com/TarunKurella/ai-agent-toolkit.git
cd ai-agent-toolkit/artifacts
cat ai-agent-toolkit-rhel9-x64.tar.gz.part-* > ai-agent-toolkit-rhel9-x64.tar.gz
shasum -a 256 ai-agent-toolkit-rhel9-x64.tar.gz
tar -xzf ai-agent-toolkit-rhel9-x64.tar.gz
cd ai-agent-toolkit-rhel9-x64
./install.sh --prefix /workspace/.ai-agent-toolkit
export PATH="/workspace/.ai-agent-toolkit/bin:$PATH"
gt version
bd version
paperclipai --version
```

Expected SHA-256:

```text
3176acc7eeeed1cdd08e6390eab67b731c0775d0680a536c16ca0f788e6f6648
```

## Recommended Layout

Use a writable project volume, for example:

```bash
mkdir -p /workspace/.ai-agent-toolkit
mkdir -p /workspace/project
```

Keep the toolkit outside the repo you are editing so agents can update codebases without touching the installed runtime.

## Suggested Environment

```bash
export PATH="/workspace/.ai-agent-toolkit/bin:$PATH"
export NODE_ENV=production
```

If the container is ephemeral, persist `/workspace/.ai-agent-toolkit` on a mounted volume so the tools do not need to be reinstalled each time.

## Notes For Claude

- `gt` and `bd` are native Linux x64 binaries in this bundle.
- `paperclipai` is shipped as a staged runtime tree and does not need registry access after extraction.
- if `paperclipai` fails, check `node --version` first
- if the container is `arm64`, do not use this bundle
