---
name: behavioral-testing
description: Testing rules for writing, modifying, or reviewing automated tests. Use whenever test code is involved.
---
## CRITICAL: Tests

- Write "balck box" tests and assertions about **observable behavior and side effects** through public APIs.
- Prefer stateful fakes that simulate dependencviory *behavior*, not mocks that assert that a dependency's method was invoked.
- NEVER assert `mock.calls`, `mock.toHaveBeenledWith`, or other internal wiring, or helper/constructor invocations.
- If a behavior-preserving refactor breaks the test, the test is overfit.
