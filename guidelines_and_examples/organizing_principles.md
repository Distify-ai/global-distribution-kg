# Knowledge Graph Design Decisions & Open Challenges

**(Global Distribution · LLM-Driven · Fact-First Graph)**

This document summarizes the **key design challenges** we face when modeling complex global distribution business data in a graph database, and the **explicit decisions** we have made so far.
Its purpose is to align internal understanding and to validate our approach with Neo4j’s experience.

---

## 1. Challenge: How to Store Complex Business Reality Without Over-Modeling

### Problem

Business reality contains:

* Companies, products, people, sites
* Transactions, partnerships, operations
* Planning, beliefs, intentions, and expectations

Naively modeling everything as entities or relationships leads to:

* Premature role assignment
* Schema rigidity
* High LLM reasoning cost
* Loss of factual correctness

### Decision

**We store only universal, observable facts in the graph.**

* Facts are verb-based and explicitly stated
* Business “roles” are never first-class schema concepts
* Insights are derived later through queries or agents

### Result

* Graph remains stable and reusable
* LLM extraction becomes simpler and cheaper
* Inference stays reversible and explainable

---

## 2. Challenge: Facts vs. Insights (Inference Leakage)

### Problem

Many useful concepts (e.g. *customer*, *manufacturer*, *distributor*) are not facts — they are conclusions drawn from multiple facts.

Storing them directly causes:

* Hard-coded business logic
* Conflicting interpretations
* Schema churn

### Decision

**Roles are never stored. They are derived from relationships.**

* We store:

  * `Company → PRODUCES → Product`
  * `Company → SELLS_TO → Company`
* We do NOT store:

  * `Company.isManufacturer = true`
  * `Company.isCustomer = true`

### Result

* Same data supports multiple interpretations
* Different agents can apply different rules
* No irreversible schema commitments

---

## 3. Challenge: Handling Uncertainty, Planning, and “Things That Might Happen”

### Problem

Sales, partnerships, and operations involve:

* Opportunities that may never close
* Plans that may change
* Targets that may be missed

These are important, but **not facts about the external world**.

### Decision

We distinguish **three layers of truth**:

1. **Facts** — what actually happened
2. **Intent** — what we plan or believe may happen
3. **Commitments** — what has been formally agreed

Intent is allowed in the graph, but **never encoded as fact**.

### How This Is Modeled

* `Opportunity` and `Goal` exist as **Intent objects**
* They never create Company–Company commitments
* They must always be supported by Events

### Result

* We can query pipeline and planning
* Without corrupting factual truth
* And without guessing outcomes

---

## 4. Challenge: How to Track Progress Without Storing Mutable State

### Problem

Business systems often store:

* “Opportunity stage”
* “Deal status”
* “Progress percentage”

This leads to:

* Overwrites
* Loss of history
* Ambiguous meaning

### Decision

**We do NOT store progress. We store events.**

* There is a single `Event` concept
* All changes, decisions, and interactions are Events
* Progress is computed by ordering and interpreting Events

### Key Rule

> If it happened at a specific time → it is an Event
> If it summarizes history → it is a query result

### Result

* Append-only history
* Full auditability
* No conflicting states

---

## 5. Challenge: When to Create Relationships Between Companies

### Problem

In sales and partnerships, companies interact long before any deal exists.

Creating Company–Company relationships too early causes:

* False claims
* Role confusion
* Data that becomes wrong later

### Decision

**Companies are connected only by commitments, never by intention.**

* Company–Company relationships exist only if:

  * A Contract exists
  * An Order exists
* Prospects and leads are derived from Events, not relationships

### Result

* Company graph represents reality, not hope
* Intent remains contextual and explainable
* Historical accuracy is preserved

---

## 6. Challenge: Products, Parts, SKUs, and Physical Assets

### Problem

Products can be:

* Abstract models
* Variants (SKUs)
* Physical instances (equipment)
* Reusable across models (e.g. batteries)

### Decision

We separate **conceptual layers**:

* `Product` = abstract model or family
* `SKU` = commercial variant
* `Equipment` = physical instance

Key rule:

> **Equipment is an instance of a Product, not the Product itself.**

### Result

* Clear separation of commerce vs reality
* Supports asset tracking, service, and lifecycle
* Avoids product/asset confusion

---

## 7. Challenge: Classification Without Semantic Overload

### Problem

Categories like:

* Industry
* Product category
* Territory

are useful but dangerous if misused as roles.

### Decision

Classifications are:

* Separate nodes
* Purely descriptive
* Never behavior-implying

Example:

* Product belongs to category “Cleaning Robot”
* This does NOT imply capability, usage, or market position

### Result

* Clean taxonomy
* No role leakage
* Safe for LLM extraction

---

## 8. Open Questions for Validation with Neo4j

We believe this approach is sound, but want to validate:

* Does this scale well for high-event-volume graphs?
* Are there known anti-patterns with Event-heavy models?
* How do others balance intent vs fact in practice?
* Are there Neo4j features (temporal, constraints, patterns) we should leverage more?

---

## Summary Position

* Facts describe the world
* Intent describes belief and planning
* Events describe change over time
* Relationships represent commitments
* Everything else is derived

We believe this maximizes correctness, flexibility, and long-term value —
and we want to pressure-test this with real Neo4j experience.
