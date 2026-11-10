# Graph Protocol

The same method, turned on the orchestration. A task is not a checklist — it is a graph with nodes, edges, and channels, and the delegation you write is the subgraph the worker walks.

Design Thinking answers what flows through the program. Graph Protocol answers what flows through the orchestration. Same three-channel discipline: one channel for the work, one channel for where delegation breaks, one channel for what each agent needs.

```
X → Graph → Delegation<A, E, R>
│              │       │  │  │
│              │       │  │  └─ what each agent needs            (§5)
│              │       │  └──── where the delegation breaks      (§4)
│              │       └─────── what flows through agents        (§2)
│              │
│              └─ nodes = tasks, edges = data dependencies
│
└─ the problem: what you're trying to build

§1  Task Nodes    the nouns: files, modules, domains, workers
§2  A             happy path as execution graph
§3  Cardinality   one worker (SMALL) or many (MEDIUM/LARGE)
§4  E             break points: wrong context, missing input, misinterpretation
§5  R             requirements: subgraph, design method, verification, WHY
§6  Boundary      subgraph in, implemented graph out — structured at edges
§7  Behavior      observe wraps delegation without changing the graph
§8  Scope         worker attention is acquired and must be released
§9  Proof         compare delegated subgraph vs implemented graph
§10 Structure     prompt = subgraph, return = implemented graph
```

Read the problem. Draw the task flow as an execution graph. Delegate work that IS the subgraph. If the implemented graph does not match the delegated subgraph, the delegation is wrong.

## 1. Name the task nodes

What are the units of work? Before drawing an execution graph, define the orchestration language.

- **Nodes** -- the discrete units of work. A service change, a component update, a config edit. Each has a domain and a worker.
- **Domains** -- who owns the node. Each domain maps to a worker with the right expertise. One node, one owner.
- **Edges** -- data dependencies between nodes. Node C needs the output of nodes A and B. No edge means independent.
- **Waves** -- groups of independent nodes that run in parallel. Edges between waves create gates.

These are the nouns. The execution is the verbs. You cannot delegate until you know what depends on what.

## 2. Think A first

Map the successful task as an execution graph before spawning any worker.

```
wave1[A∥B] → gate → wave2[C] → wave3[D]
```

What is the happy path through the task? Which nodes are independent (parallel)? Which depend on prior results (sequential)? This graph IS your delegation plan. Draw it first. The spawning follows.

## 3. One or many?

Is the task one worker or many?

- **One worker** -- a small or trivial task. Single node, no execution graph needed. Inline the task in the prompt.
- **Many workers** -- a medium or large task. Multiple nodes, draw the execution graph. Each worker gets its subgraph.
- **Waves** -- independent nodes in the same wave spawn in parallel. The gate between waves waits for all prior nodes.

Same three channels (A, E, R) in all cases. Different cardinality. Mark it on the graph so the delegation matches.

## 4. Think E second

Mark where the delegation can break. Each break point is one of three things:

- **Wrong context** -- the worker does not understand the problem as deeply as the coordinator. Missing files, missing WHY, missing constraints.
- **Missing input** -- a node in wave 2 needs the output of wave 1, but the coordinator did not pass it. The edge is invisible.
- **Misinterpretation** -- the worker implements the LETTER of the delegation, not the INTENT. The subgraph was ambiguous.

Delegation failures are not worker failures — they are coordinator failures. The coordinator controls the prompt. If the worker misunderstands, the prompt was wrong.

## 5. Think R third

Mark what each worker needs before it can do the work. "The worker cannot do X if it does not have Y."

R is the delegation prompt completeness check. Every worker needs:
- **Subgraph** -- what to implement, in the notation the worker's domain expects
- **Design method** -- which methodology applies to this worker's domain, and which sections govern the work
- **Verification command** -- how the worker proves the work is correct
- **WHY** -- the reason this node exists, not just what to change

If any R is missing from the prompt, the worker will guess. Guessing is the source of misinterpretation (§4).

## 6. Trust at boundary

Where does unstructured data cross the orchestration boundary? The coordinator sends a prompt. The worker sends a result.

Structure at the boundary. The coordinator includes the subgraph in the prompt — not prose, not "fix the thing," but the graph the worker must implement. The worker returns the implemented graph in its result — not a bare signal, but the graph it actually built.

Trust nothing at the boundary. Trust everything inside. The boundary is the only place the graph is transferred. After that, the worker owns its subgraph.

## 7. Layer behavior

What wraps the delegation without changing the graph? Observations, session tracking, phase transitions.

The coordinator records the delegated subgraph BEFORE spawning. The worker records the implemented graph AFTER implementing. These observations wrap the delegation without changing what the worker does. The happy path stays clean — you can read it without wading through session tracking.

## 8. Scope attention

A worker is a resource. It is acquired (spawned) and must be released (completed with structured data).

The coordinator acquires a worker's attention by spawning it. The worker releases attention by completing with the implemented graph. Between acquire and release, the worker owns its subgraph. The coordinator does not interfere — it waits at the gate.

If a worker is spawned without a clear subgraph, its attention is wasted. If a worker completes without reporting its implemented graph, the data is lost. Acquire with structure. Release with data.

## 9. Compare to prove it

The delegated subgraph and the implemented graph must match. If they do not, something is wrong.

After the worker completes, the coordinator reads both records:
- The delegated subgraph (what was asked)
- The implemented graph (what was built)

Same nodes. Same A flowing through. Same E possible. If the implemented graph has nodes the delegated subgraph did not mention, the worker went off-script. If the delegated subgraph has nodes the implemented graph did not cover, the worker missed something. This is the payoff of structuring at the boundary — you prove the delegation correct by comparing graphs.

## 10. Prompt is subgraph, return is implemented graph

The separation of delegation (§6) and return (§7) maps directly to orchestration structure:

- **The prompt** -- carries the subgraph. The graph the worker must implement, in the notation the domain expects, with context and verification.
- **The return** -- carries the implemented graph. The graph the worker actually built, structured so the coordinator can compare it against the delegated subgraph.

This is not a stylistic preference. If the subgraph lives in prose and the return is a bare string, the delegation and verification are tangled — you cannot read what was asked without parsing natural language, and you cannot verify what was built without reading the entire diff. The prompt IS the delegated graph. The return IS the implemented graph.

---

## The Protocol Pipeline

```
TASK
  -> "What are the task nodes?"                       -> define nodes, domains, edges
  -> "What is the happy path?"                        -> draw the execution graph (A)
  -> "One worker or many?"                            -> mark cardinality
  -> "Where can the delegation break?"                -> annotate break points (E)
  -> "What does each worker need?"                    -> annotate requirements (R)
  -> "Where does the graph cross boundaries?"         -> subgraph in, implemented graph out
  -> "What wraps delegation without changing it?"     -> observe before and after
  -> "What resources need release?"                   -> scope worker attention
  -> "Does the implemented graph match?"              -> compare delegated vs implemented
  -> "Does my prompt separate subgraph from prose?"   -> prompt = subgraph, return = graph
  -> DELEGATION                                       -> the delegation IS the subgraph
```

**If the implemented graph does not match the delegated subgraph, the delegation is wrong.**
