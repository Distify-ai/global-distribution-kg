# LLM Extraction Rules

# Organizing Principles for LLM Extraction

> **Goal**: To build a self-updating, deep-context knowledge graph that minimizes "middle management" gaps and powers intelligent distribution agents.

## 1. The Core Philosophy: "Spine, Flesh, and Nervous System"

To make the graph useful for distribution, we organize data into three layers:

### 1.1 The Spine (Value Chain Structure)

**The rigid backbone of the market.**

-   **Goal**: Establish the "Source of Truth" for entities.
-   **Flow**: `Manufacturer` → `GlobalDistributor` → `Franchisee` → `Customer` → `Equipment`.
-   **Rule**: Every extracted entity must anchor to this spine. A loose `Equipment` node is useless; an `Equipment` node owned by a `Customer` in a `Territory` is valuable.

### 1.2 The Flesh (Contextual Layer)

**The dynamic pulse of business.**

-   **Goal**: Replace "middle management" coordination by capturing context.
-   **Components**: `Interaction`, `Document`, `Opportunity`.
-   **Why it matters**: This layer captures the "who, what, when, and WHY" of business. It fills the gaps that usually require human explanation (e.g., "Why did we lose that deal?").

### 1.3 The Nervous System (Active Signaling)

**The actionable triggers.**

-   **Goal**: Drive action from data.
-   **Components**: `Task`, `Goal`, `Alert` (via Tags).
-   **Function**: When the "Flesh" detects a pattern (e.g., 3 failed repairs), the "Nervous System" triggers a `Task` for a `Technician`.

---

## 2. Entity Resolution: "Identity First" Strategy

One of the biggest risks in KG construction is duplicate entities (e.g., "Acme Corp" vs. "Acme Inc."). We use a **"Search before Create"** strategy.

### 2.1 The Resolution Hierarchy

LLMs should follow this logic to match entities:

1.  **Tier 1: Hard Identifiers (100% Confidence)**

    -   Match on: `email`, `serialNumber`, `taxId`, `companyId`.
    -   _Action_: Merge immediately.

2.  **Tier 2: Soft Identifiers (High Confidence)**

    -   Match on: `companyName` + `country`, `address` + `postalCode`.
    -   _Action_: Merge if similarity > 90%.

3.  **Tier 3: Semantic Verification (LLM-Assisted)**
    -   Match on: Contextual clues (e.g., "The Acme in Chicago that buys scrubbers").
    -   _Action_: Ask LLM: _"Are 'Acme Cleaning Services' and 'Acme Svcs Chicago' the same entity based on this context?"_

### 2.2 Provenance & Trust

Every extraction must include metadata to build trust:

-   `source`: Where did this come from? (e.g., "Email: Re: Order 123")
-   `confidence`: 0.0 - 1.0 score.
-   `extractedAt`: Timestamp.

---

## 3. Minimizing Gaps: The Graph as Manager

The graph serves as the institutional memory to minimize data transfer gaps.

### 3.1 Person-Centric Context

-   **Goal**: Enable "Personalized Networking".
-   **Query Pattern**: "Show me everything relevant to _User X_."
-   **Implementation**:
    -   Track **Relationship Lineage**: `(Person)-[:REFERRED_BY]->(Person)`.
    -   Track **Interaction History**: `(Person)-[:PARTICIPATED_IN]->(Interaction)`.

### 3.2 Eliminating "Boring Middle Management"

-   **Problem**: Middle managers often just route information.
-   **Solution**: The graph routes information automatically.
    -   _Scenario_: A `Technician` completes a repair (`Interaction`).
    -   _Graph Action_: Automatically links `Interaction` to `Equipment` and `Customer`.
    -   _Result_: The `AccountManager` sees the update instantly without a status meeting.

---

## 4. Extraction Rules by Type

### 4.1 Entities (Nouns)

-   **Extract**: Companies, People, Equipment, Sites.
-   **Normalize**: Convert "USA", "U.S.", "United States" -> "US".
-   **Deduplicate**: Apply "Identity First" strategy.

### 4.2 Relationships (Verbs)

-   **Extract**: Explicit connections (`WORKS_FOR`, `SOLD_TO`).
-   **Infer**: Implied connections with lower confidence (e.g., "User X mentioned Project Y" -> `INTERESTED_IN`).

### 4.3 Properties (Adjectives)

-   **Extract**: Facts (Dates, Amounts, Status).
-   **Do Not Hallucinate**: If a property is missing, leave it `null`.

---

## 5. Data Quality Checks

1.  **Orphans**: No entity should exist without a relationship to the Spine.
2.  **Timestamps**: Every `Interaction` and `Task` must have a timestamp.
3.  **Validation**: Check against `validation_rules.md` (e.g., `Equipment` must have `serialNumber`).
    r", "some robots")

-   One-off facts that are better as properties
-   Opinions, hypotheticals, or unconfirmed information

## 4.4 Label Assignment Rules

-   Start with base entity type (`Company`, `Person`, `Product`, etc.)
-   Add role/type labels based on context (`:Customer`, `:Manufacturer`, `:Employee`, etc.)
-   One node can have multiple labels

## 4.5 Deduplication Strategy

**Before creating any node, search for existing:**

| Entity Type | Search By                              |
| ----------- | -------------------------------------- |
| Company     | `companyName`, `legalName`, `taxId`    |
| Person      | `email`, or (`fullName` + `companyId`) |
| Product     | `modelNumber`, or (`brand` + `name`)   |
| Site        | Full address components                |
| Equipment   | `serialNumber`                         |
| Part        | `partNumber`                           |

## 4.6 Relationship Extraction Rules

**Only create relationships that are:**

1. **Explicitly stated** in source material ("John Smith works for Acme Corp")
2. **Strongly implied** by context ("Acme's CTO John Smith" → `WORKS_FOR` relationship)

**Don't create relationships that are:**

-   Hypothetical ("Acme might partner with XYZ")
-   Uncertain ("We're discussing with potential customer ABC")
-   Inferred through complex logic chains

## 4.7 Property Extraction & Normalization

**Suggested properties:**

-   Extract as many listed properties as possible from the source
-   Use `null` or omit if not found (do not hallucinate)

**Standardized formats:**

-   **Dates**: ISO 8601 (YYYY-MM-DD)
-   **Timestamps**: ISO 8601 with timezone (2024-01-15T10:30:00+08:00)
-   **Currency**: ISO codes (USD, EUR, AUD)
-   **UUIDs**: Generate v4 UUID for new entities
-   **Countries**: ISO country codes (AU, US, CA)

**Property types:**

-   **String**: text, names, codes
-   **Number**: amounts, quantities (no currency symbols)
-   **Boolean**: true/false only (not "yes"/"no")
-   **Array**: lists of values (e.g., `aliases`)
-   **JSON**: complex structured data (e.g., `boundingBox`)

**Normalization rules:**

-   **Company names**: Remove "Inc.", "Pty Ltd", "LLC" suffixes for matching (keep in `legalName`)
-   **Status values**: Use schema-defined enums exactly (Active, Inactive, Prospect)
-   **Names**: Trim whitespace, normalize to title case where appropriate

## 4.8 Tagging Rules

**Goal**: Capture "unknown unknowns" and potential new entities without polluting the graph.

1.  **Catch-all for undefined entities**: If an important concept appears (e.g., "Lidar Navigation") and has no Entity type, create a Tag.
2.  **Normalize names**: Convert to lowercase, snake_case (e.g., "Lidar Navigation" → `lidar_navigation`).
3.  **Link to Evidence**: Tags are most valuable when linked to `Chunk` or `Document`.
4.  **Monitor for promotion**: If a Tag is used frequently, promote it to a first-class Entity.

## 4.9 Data Quality Checks

**Mandatory validations before finalizing extraction:**

1. **No orphan nodes**: Every node must have ≥1 relationship (except root entities like HQ Company)
2. **No duplicates**: Run deduplication check before creating nodes
3. **Relationship validation**: Both endpoints of relationship must exist
4. **Type consistency**: Ensure properties match expected types (number vs string)

**Confidence scoring:**

Tag extracted entities/relationships with confidence level:

| Confidence | Range   | Criteria                                 |
| ---------- | ------- | ---------------------------------------- |
| High       | 0.9-1.0 | Explicitly stated with identifiers       |
| Medium     | 0.6-0.8 | Implied or inferred from clear context   |
| Low        | < 0.6   | Ambiguous or uncertain - flag for review |

## 4.10 Extraction Scope (MVP)

**What to extract:**

-   ✅ Companies, People, Geography (Territory, Site)
-   ✅ Industry
-   ✅ Products, Equipment, Parts
-   ✅ Opportunities, Orders, Contracts
-   ✅ Documents, Chunks, Interactions
-   ✅ Tags

**What NOT to extract (out of scope for MVP):**

1. **Business context layer**:

    - `Playbook`, `PlaybookStage`, `PlaybookStep` nodes
    - `Pattern` nodes (wisdom/tactics)
    - Agent execution traces

2. **Operations entities** (future):

    - `ServiceTicket`, `MaintenanceTask`, `Visit` nodes
    - `SLA`, `Warranty` nodes
    - `Shipment` nodes

3. **Derived/computed data**:
    - Aggregations, calculations, analytics
