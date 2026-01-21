---
name: dev-loop
description: Develop feature, given a ROADMAP file
prompt: You are iterating carefully on tasks in the ROADMAP.md in this repository.
---

# Development Loop

This is the systematic process for implementing phases from a dev roadmap.
Follow this loop exactly for each phase to ensure careful, methodical progress.

---

## Loop Structure

```
┌─────────────────────────────────────────┐
│ 1. READ & UNDERSTAND                    │
│    - Parse phase spec                   │
│    - Identify dependencies              │
│    - Clarify ambiguities                │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│ 2. DESIGN                               │
│    - Module/function signatures         │
│    - Data structures                    │
│    - Integration tests needed           │
│    - Record design decisions            │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│ 3. IMPLEMENT                            │
│    - Write code (minimal comments)      │
│    - Focus on behavior, not perfection  │
│    - Integration tests as you go        │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│ 4. VALIDATE                             │
│    - Run tests from phase spec          │
│    - Manual QA if needed                │
│    - Confirm acceptance criteria        │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│ 5. REFACTOR                             │
│    - Simplify, don't over-engineer      │
│    - Remove duplication                 │
│    - Functional patterns where possible │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│ 6. RECORD & COMMIT                      │
│    - Update ROADMAP file phase status   │
│    - Add new TODOs if discovered        │
│    - Git commit with clear message      │
│    - Push to remote                     │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│ 7. NEXT TICK                            │
│    - Clear context                      │
│    - Move to next phase                 │
│    - Repeat loop                        │
└─────────────────────────────────────────┘
```
---

## Background

A file with roadmap tasks or phases has already been compiled.
It's probably at ./ROADMAP.md but it might live somewhere like TASKS.md or TODO.md, or the user may have given it as part of the prompt.
We'll call it the ROADMAP file.

### Roadmap file

The ROADMAP is built in small chunks that may be called TASKS or PHASES, each of which will have specific todo items, and represents about one git commit worth of work.
Next to the name of the Phase/Task will be a status, which can be one of:
- TODO: Ready to be worked on now
- BLOCKED: Cannot be worked on, skip it and move to the next one
- IN PROGRESS: Currently being worked on -- skip it unless specifically told to continue in-progress tasks
- REVIEW: An AI agent has finished with the task and ready for a human to review/approve/change <-- This is how you will indicate you're done
- DONE: A human has reviewed the task and thinks it's truly complete. <-- You MUST NOT use this status, it's only for humans.

You may also have access to files like SPEC.md ARCHITECTURE.md PLAN.md RESEARCH.md or other informational files that will help give context on what we're building and why.
You DON'T NEED to consult those files if they exist, but you MAY consult them if anything in the ROADMAP file is ambiguous or indeterminate.

---

## Step 1: READ & UNDERSTAND

**Goal:** Fully comprehend what needs to be built before writing any code.

**Actions:**

1. **Read the phase spec from ROADMAP**
   - Parse: scope, line estimate, tasks, test criteria
   - Skipping BLOCKED tasks, find the next relevant TODO task
   - Identify target files/modules

2. **Mark Task as IN PROGRESS**
   - For the task that you will do, change the status from TODO to IN PROGRESS
   - Add the date like (MM/DD/YYYY) to the task heading, next to IN PROGRESS

3. **Check dependencies**
   - Scan previous phases: what do we depend on?
   - Verify those dependencies exist and are correct
   - If missing: stop, implement dependencies first

4. **Read related specs in PRODUCT_SPEC.md**
   - Find BDD scenarios matching this phase
   - Understand expected behavior, edge cases, error handling
   - Note visual states, user interactions, performance targets

5. **Clarify ambiguities**
   - If phase spec is unclear: reference PRODUCT_SPEC, ARCHITECTURE, RESEARCH
   - If still unclear: document the question, make a reasonable decision, record it
   - No guessing—every decision must have a rationale

6. **Check existing codebase**
   - Read files this phase will modify (if any)
   - Understand patterns, naming conventions, module boundaries
   - Identify integration points

**Output:**
- Mental model of what needs to be built
- List of dependencies verified
- List of edge cases to handle
- Questions answered or decisions recorded

**Exit Criteria:**
- You can explain the phase to someone else clearly
- No unresolved ambiguities remain

---

## Step 2: DESIGN

**Goal:** Plan the specific implementation before writing code.

**Actions:**

1. **Define function signatures**
   - List all functions/methods this phase will create
   - Specify parameters, return types (Result<T> where applicable)
   - Map to ROADMAP tasks (each task = 1-3 functions typically)

2. **Design data structures**
   - Node types, tables, schemas
   - In-memory representations
   - Serialization formats (YAML, markdown, SQL)

3. **Plan integration tests**
   - Not full TDD, but key integration tests that verify behavior
   - Map ROADMAP "Test:" criteria to actual test cases
   - Prioritize: interactions between modules > unit tests

4. **Identify refactoring opportunities**
   - Will this phase expose duplication we can eliminate?
   - Can we extract reusable utilities?
   - Note these for Step 5 (Refactor)

5. **Record design decisions**
   - Why this approach over alternatives?
   - Trade-offs considered
   - Append to ARCHITECTURE.md if architecturally significant

**Output:**
- Function/module skeleton (signatures, no implementation)
- Data structure definitions (types, schemas)
- Integration test plan (what to test, how to verify)
- Design decisions documented

**Exit Criteria:**
- All ROADMAP tasks have corresponding function signatures
- Data flow is clear (input → processing → output)
- Test plan covers all acceptance criteria

---

## Step 3: IMPLEMENT

**Goal:** Write the code to make tests pass.

**Actions:**

1. **Create skeleton files/modules**
   - Match ROADMAP file paths exactly (e.g., `lua/lifemode/util.lua`)
   - Stub out functions from Step 2 (Design)

2. **Implement functions one at a time**
   - Follow ROADMAP task order (top to bottom)
   - Focus: make it work, not make it perfect
   - Use Result<T> for error handling (Ok/Err pattern)
   - Functional patterns: prefer pure functions, avoid mutation where reasonable

3. **Write integration tests as you go**
   - After implementing a chunk of behavior: write test
   - Don't wait until end—tests inform implementation
   - Use `plenary.nvim` test runner format

4. **Handle errors explicitly**
   - Never ignore errors (no silent failures)
   - Return Err() with meaningful messages
   - Follow PRODUCT_SPEC §9 error handling patterns

5. **Minimal comments**
   - Code should be self-explanatory
   - Only comment: invariants, assumptions, non-obvious consequences
   - Explain WHY, not WHAT

**Output:**
- Working implementation of all ROADMAP tasks
- Integration tests written and passing (if applicable)
- Error handling in place
- Code compiles/loads without errors

**Exit Criteria:**
- All functions from Step 2 (Design) are implemented
- No obvious bugs (test manually if no automated tests yet)
- Code follows existing patterns in codebase

---

## Step 4: VALIDATE

**Goal:** Confirm the implementation meets acceptance criteria.

**Actions:**

1. **Run automated tests**
   - Execute integration tests written in Step 3 (Implement)
   - All tests must pass
   - If failures: fix bugs, don't move forward

2. **Manual QA**
   - Follow ROADMAP "Test:" criteria manually
   - Example: "Create Result, chain operations, generate UUIDs"
   - Load plugin in Neovim, execute the workflow
   - Check: behavior matches PRODUCT_SPEC BDD scenarios

3. **Check edge cases**
   - Missing files, permission errors, malformed input
   - Follow PRODUCT_SPEC §9 (Error Handling & Resilience)
   - Ensure error messages are user-friendly

4. **Verify performance targets**
   - If ROADMAP or PRODUCT_SPEC specifies performance (e.g., "<100ms")
   - Benchmark critical operations
   - If too slow: optimize before moving on

5. **Cross-check dependencies**
   - Does this phase break anything from previous phases?
   - Run earlier tests if they exist
   - Ensure backward compatibility

**Output:**
- All tests passing
- Manual QA complete (checklist verified)
- Edge cases handled gracefully
- Performance within targets (if specified)

**Exit Criteria:**
- ROADMAP "Test:" criteria satisfied
- BDD scenarios pass (if applicable)
- No regressions in previous phases

---

## Step 5: REFACTOR

**Goal:** Simplify and improve code quality without changing behavior.

**Actions:**

1. **Identify duplication**
   - Look for repeated logic across functions/modules
   - Extract to shared utilities if used 3+ times
   - Don't abstract prematurely (resist "just in case" code)

2. **Simplify complex functions**
   - If function > 50 lines: consider splitting
   - Extract sub-functions with clear names
   - Prefer composition over nesting

3. **Apply functional patterns**
   - Pure functions where possible (no side effects)
   - Immutable data structures (deep copy Node objects)
   - Higher-order functions (map, filter, reduce) over loops

4. **Remove dead code**
   - Delete commented-out code
   - Remove unused functions, variables
   - No "just in case" code—YAGNI principle

5. **Check naming**
   - Variables/functions: clear, precise, unambiguous
   - Follow Lua conventions (snake_case for functions)
   - No abbreviations unless standard (uuid, sql, fts)

6. **Re-run tests**
   - After every refactor: confirm tests still pass
   - Refactoring should NOT change behavior

**Output:**
- Cleaner, simpler code
- No duplication (unless genuinely different logic)
- Tests still passing
- No behavioral changes

**Exit Criteria:**
- Code is as simple as possible (no simpler)
- No obvious duplication remains
- Naming is clear and consistent

---

## Step 6: RECORD & COMMIT

**Goal:** Document progress and commit the phase atomically.

**Actions:**

1. **Update ROADMAP.md**
   - Mark current phase as complete
   - Syntax: Add `✅` or `[DONE]` at phase heading
   - If new TODOs discovered: append to appropriate phase or create new phase
   - If phase split into sub-phases: document the split

2. **Document design decisions**
   - If architecturally significant: append to ARCHITECTURE.md
   - If pattern will be reused: note in relevant section
   - If trade-off made: record rationale

3. **Git commit**
   - Stage all changed files: `git add <files>`
   - Write clear commit message:
     - Format: `<action>: <summary>` (e.g., "feat: Result type & UUID generator")
     - Body: reference ROADMAP phase number, key behaviors added
     - Footer: `Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>`
   - Review diff before committing
   - Commit: `git commit -m "..."`

4. **Push to remote**
   - Push branch: `git push origin main` (or current branch)
   - Confirm push succeeded

5. **Verify commit**
   - Check git log: commit message clear?
   - Check remote: commit visible?
   - If mistakes: amend commit before moving to next phase

**Output:**
- ROADMAP.md updated (phase marked complete)
- Git commit created (clean, atomic)
- Changes pushed to remote
- Documentation updated (if needed)

**Exit Criteria:**
- ROADMAP.md reflects current state accurately
- Git history has one commit for this phase
- Commit message is clear and references phase

---

## Step 7: NEXT TICK

**Goal:** Transition to the next phase seamlessly.

**Actions:**

1. **Identify next phase**
   - Read ROADMAP.md: find next unmarked phase
   - Confirm it's the correct next step (dependencies met)

2. **Assess readiness**
   - Are previous phases stable?
   - Any bugs discovered that need fixing first?
   - If blockers exist: resolve before starting next phase

3. **Clear context**
   - Briefly review what was just completed
   - Note any patterns/learnings for next phase
   - Reset focus: next phase is a brand new problem

4. **Start Step 1 (Read & Understand) for next task**
   - Loop back to top
   - Repeat process

**Output:**
- Ready to start next phase
- No loose ends from current phase
- Mental clarity for next problem

**Exit Criteria:**
- Next phase identified
- Blockers resolved
- Loop ready to restart

---

## Quality Principles

Throughout all phases, maintain these principles:

### 1. Simplicity First
- No over-engineering
- No "just in case" features
- Solve the current problem, not hypothetical future problems

### 2. Functional Where Possible
- Pure functions (no side effects)
- Immutable data structures
- Composition over inheritance

### 3. Error Handling Always
- Every operation that can fail returns Result<T>
- User-facing errors are clear and actionable
- No silent failures, ever

### 4. Test Integration Points
- Not full TDD, but test interactions between modules
- Unit tests for complex logic only
- Manual QA for UX flows

### 5. Minimal Comments
- Code should be self-documenting
- Comment only: invariants, assumptions, non-obvious consequences
- Never repeat what the code says

### 6. Incremental Progress
- Each phase is atomic (one commit)
- Commit when phase is complete, not before
- Push frequently to avoid losing work

### 7. Respect Layer Boundaries
- Domain layer: no I/O, no Neovim API, pure logic
- Infrastructure layer: file I/O, SQL, extmarks
- Application layer: orchestration, workflows
- UI layer: commands, keymaps, notifications
- Never import "up" the stack

---

## Running the Loop Autonomously

When running on bypass permissions mode:

1. **Start with first READY task of ROADMAP file**
2. **Execute each step in the dec loop sequentially (1 → 2 → 3 → 4 → 5 → 6 → 7)**
3. **Do not skip phases**
4. **Do not rush**
5. **Record decisions** as you go (in comments, DECISIONS.md, or commit messages)
6. **If blocked:** stop, document blocker, seek clarification (don't guess)
7. **If phase takes longer than expected:** split into sub-phases, update ROADMAP
8. **After each commit:** confirm tests pass, no regressions

---

## Checklist for Each Loop Iteration

Before moving to next phase, confirm:

- [ ] ROADMAP phase marked as ready for review ("REVIEW")
- [ ] All acceptance criteria met
- [ ] Tests passing (automated + manual)
- [ ] Code follows quality principles
- [ ] Git commit created and pushed
- [ ] No regressions in previous phases
- [ ] Documentation updated (if needed)
- [ ] Next phase dependencies verified

---

## Notes on Bypass Mode

When running autonomously:

- **Trust the loop.** Don't skip steps because they seem unnecessary.
- **Record decisions.** Future you (or a human) needs to understand why choices were made.
- **If stuck:** document the blocker clearly, don't forge ahead with guesses.
- **Commit frequently.** One phase = one commit. No batching.
- **Validate ruthlessly.** If tests fail, stop and fix. Don't rationalize failures.

This loop is designed to produce **careful, methodical, high-quality results** when followed exactly. No shortcuts.

