---
description: Summarize conversations over a time period and propose work arcs. Use when the user asks for a summary of what they worked on (e.g. "summarize yesterday", "what did I do last week", "recap the last N days").
argument-hint: [time period: yesterday, last N days, last week]
allowed-tools: Bash(~/.claude/summary-helper.sh*)
---

Time period: $ARGUMENTS (default: last day)

## Conversation History

!`~/.claude/summary-helper.sh "$ARGUMENTS"`

## Your Task

Analyze the conversation history above and provide:

### 📋 Activity Summary
Summarize what I worked on during this time period. Group by project and identify:
- Main tasks and features worked on
- Problems solved or investigated
- Questions asked and topics explored
- Tools/configs/workflows modified

### ✅ Completed Arcs
List work threads that were finished during this period. Keep it brief - just PR number/title with link if available, or a short description of what was accomplished.

### 🌱 Potential New Arcs
Ideas or tasks mentioned but not acted on, opportunities identified.

### 🎯 Recommendations
Based on the patterns you see:
- What should I prioritize continuing?
- What might benefit from a fresh start or different approach?
- Any recurring blockers worth addressing?

Keep the summary concise but actionable. Focus on helping me pick up where I left off efficiently.
