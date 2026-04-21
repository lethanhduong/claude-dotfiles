---
name: commit-msg
description: Generate a conventional commit message from staged changes. Use when the user asks for a commit message, wants to commit, or says "generate commit message".
argument-hint: [optional: scope or context hint]
allowed-tools: Bash, Read
model: haiku
---

Generate a git commit message for the staged changes.

Steps:
1. Run `git diff --cached` to see what is staged.
2. Run `git log --oneline -5` to understand the project's commit style.
3. Produce a commit message following the project's style. If no clear style, use:
   - Subject: imperative mood, under 72 characters, no period.
   - Body (if needed): explain WHY, not WHAT. Wrap at 72 chars.
4. Output ONLY the commit message — no explanation, no markdown fences.

If nothing is staged, say "Nothing staged. Run `git add <files>` first."

## Message Style Examples
"type" must be one of the following:
feat: new feature for the user, not a new feature for a build script
fix: bug fix for the user, not a fix to a build script
docs: changes to the documentation
style: formatting, missing semi-colons, etc; no production code change
refactor: refactoring production code, eg. renaming a variable
test: adding missing tests, refactoring tests; no production code change
chore: regular code maintenance and updating grunt tasks etc; no production code change (eg: change to .gitignore file or .prettierrc file)
build: build-related changes, for updating build configuration, development tools or other changes irrelevant to the user (eg: npm related/ adding external dependencies/ podspec related)
perf: code change that improves performance
