---
description: Interview the user in depth about a plan file using AskUserQuestion, then write the resulting spec back to the file. Use when the user wants to refine, stress-test, or expand a plan or spec.
argument-hint: [plan-file]
disable-model-invocation: true
model: opus
---

Read this plan file $ARGUMENTS and interview me in detail using the AskUserQuestion tool about
literally anything: technical implementation, UI & UX, concerns, tradeoffs, etc.
but make sure the questions are not obvious.

Be very in-depth and continue interviewing me continually until it's complete, then write the spec to the file.
