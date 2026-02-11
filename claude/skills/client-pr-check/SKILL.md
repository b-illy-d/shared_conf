---
name: client-pr-check
description: "Review a potential merge in the client repo for best practices and no-nos"
allowed-tools: Read, Grep, Glob
---

# Client Merge review patterns

## Overview

- CRITICAL: Everything in this instruction should be understood as pertaining ONLY to changes between the current local branch and origin/master.
- IMPORTANT: The goal is to identify and FLAG some issues, and to FIX others. Pay attention to the per-section instructions.

## Quick Review Checklist (Reference Pattern)

- [ ] All react components use @tw/ui-components and not raw jsx (e.g. use <Box>, not <div>) (FIX)
- [ ] Avoid `style={{ ... }}` prop wherever possible, pass Mantine-native props (FIX)
- [ ] Avoid `useRef` and other anti-patterns, use normal immutable React patterns where possible (FLAG)
- [ ] IF there is an exception to the above, NOTE WHY in a code comment, tell me so I can decide whether to correct or remove

## All react components use @tw/ui-components and not raw jsx (e.g. use <Box>, not <div>) (FIX)
- There is a ui-component for almost any use case, we should NEVER use native tags for any reason
- The library extends Mantine, so you can look to Mantine docs if you're confused about how something works

## Avoid `style={{ ... }}` prop wherever possible, pass Mantine-native props (FIX)
- Most @tw/ui-components accept props, like `color='blue.1'` avoid a `style={{}}` prop at all costs

## Avoid `useRef` and other anti-patterns, use normal immutable React patterns where possible (FLAG)
- Do not overuse `useMemo` or `useCallback`.
- Make re-renders cheap and then do not fear the re-render.

## IF there is an exception to the above, NOTE WHY in a code comment, tell me so I can decide whether to correct or remove

## Final Output

When you're finished, give me a summary of what you found/did. Include:
- 1. Fixes made and WHY for each
- 2. Recommended fixes to make and WHY -- for issues that were FLAGGED

