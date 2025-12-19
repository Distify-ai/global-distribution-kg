# Distify.ai Enterprise Graph Schema v1

This document captures the **current canonical enterprise graph schema** for Distify.ai, along with design principles and guidelines for evolving it. It is meant for product managers, engineers, data modelers, and AI-agent developers.

---

## 2. Core Node Types

This section lists the core node labels that make up the Distify enterprise graph.

### 2.1 Identity & Organization

#### `Company` (base)
Represents any legal organization.

**Labels:**
- Base: `Company`
- Role labels:
  - `Customer`
  - `Prospect`
  - `Manufacturer`
  - `Vendor`
  - `Franchise`
  - `Distributor`
  - `Partner`
  - `LogisticsProvider`
  - `ServiceProvider`
  - `Distify` (for our own entity, usually a single node)

**Key properties:**
- `companyId` (string, UUID or master ID)
- `companyName`
- `legalName`
- `country`
- `region`
- `city`
- `taxId`
- `website`
- `status` (Active, Inactive, Prospect, Blacklisted)
- `createdAt`, `updatedAt`

---

#### `Person`
Represents an individual.

**Labels:**
- Base: `Person`
- Possible role labels:
  - `Employee` (Distify employee)
  - `FranchiseEmployee`
  - `Contact` (generic external contact)
  - `ProcurementContact`
  - `TechnicalContact`
  - `FinanceContact`
  - `Executive`

**Key properties:**
- `personId`
- `fullName`
- `email`
- `phone`
- `jobTitle`
- `timezone`
- `createdAt`, `updatedAt`

---

#### `Territory`
Geographical or commercial territory.

**Properties:**
- `territoryId`
- `name` (e.g. "Canada", "East Australia")
- `type` (Country, Region, City, CustomZone)
- `isoCode` (optional)

---

#### `Site`
Physical location (customer site, warehouse, hub, etc.).

**Properties:**
- `siteId`
- `name`
- `addressLine1`
- `addressLine2`
- `city`
- `region`
- `country`
- `postalCode`
- `siteType` (CustomerSite, FranchiseHub, Warehouse, OEMHQ, RepairCenter)
- `sqmSize` (optional)
- `lat`, `lon` (optional)

---

#### `Industry` (dimension)
High‑level industry classification.

**Properties:**
- `industryId`
- `name` (e.g. "Cleaning Services", "Education", "Sports Facilities")

---

#### `Segment` (dimension)
Market/ICP segment.

**Properties:**
- `segmentId`
- `name` (e.g. "Commercial Mowers", "Indoor Cleaning – Offices")
- `description`

---

### 2.2 Products & Assets

#### `Product`
Product model / family (e.g. "Titan 810 Scrubber").

**Properties:**
- `productId`
- `name`
- `brand`
- `modelNumber`
- `category` (CleaningRobot, MowingRobot, NavigationKit, etc.)
- `description`
- `lifecycleStage` (Alpha, Beta, GA, EOL)

---

#### `SKU` (optional v1.1)
Sellable SKU variant.

**Properties:**
- `skuId`
- `skuCode`
- `name`
- `description`
- `currency`
- `listPrice`
- `costPrice`

---

#### `RobotUnit`
A specific physical robot in the field.

**Properties:**
- `robotId`
- `serialNumber`
- `commissionedAt`
- `status` (Active, PendingInstall, InRepair, Retired)
- `firmwareVersion`

---

#### `SparePart` (optional)
Replaceable component.

**Properties:**
- `partId`
- `partNumber`
- `name`
- `description`

---

### 2.3 Commercial Lifecycle

#### `Opportunity`
Represents a sales opportunity or deal.

**Properties:**
- `opportunityId`
- `name`
- `stage` (Prospect, Qualified, Proposal, Pilot, Won, Lost)
- `amount`
- `currency`
- `expectedCloseDate`
- `createdAt`
- `closedAt`
- `reasonLost` (if applicable)

---

#### `Order`
A confirmed sales order.

**Properties:**
- `orderId`
- `status` (Draft, Confirmed, Shipped, Completed, Cancelled)
- `orderDate`
- `currency`
- `totalNet`
- `totalTax`
- `totalGross`

---

#### `OrderLine`
Line item within an order.

**Properties:**
- `orderLineId`
- `quantity`
- `unitPrice`
- `discount`
- `lineTotal`
- `lineType` (Product, Service, Subscription)

---

#### `Contract`
Longer‑term agreement (Franchise, OEM Master, Support, Subscription).

**Properties:**
- `contractId`
- `type` (Franchise, OEM, Service, Subscription)
- `startDate`
- `endDate`
- `autoRenew` (boolean)
- `status` (Active, Expired, Terminated)
- `slaLevel` (e.g. 1-Day, 4-Hours, NBD)

---

### 2.4 Operations & Service

#### `ServiceTicket`
Core service/support ticket.

**Properties:**
- `ticketId`
- `status` (New, InProgress, WaitingCustomer, Resolved, Closed)
- `priority` (Low, Medium, High, Critical)
- `category` (Hardware, Software, Training, Logistics)
- `description`
- `createdAt`
- `resolvedAt`

---

#### `MaintenanceTask`
Specific work unit, often attached to a ticket.

**Properties:**
- `taskId`
- `type` (Preventive, Corrective, Install, Inspection)
- `status` (Planned, Assigned, InProgress, Completed, Cancelled)
- `scheduledFor`
- `completedAt`
- `durationMinutes`

---

#### `Visit`
Onsite visit or remote session.

**Properties:**
- `visitId`
- `type` (Onsite, Remote)
- `visitDate`
- `durationMinutes`
- `notes`

---

#### `SLA`
Service Level Agreement definition.

**Properties:**
- `slaId`
- `name`
- `responseTimeUnit` (hours/days)
- `responseTimeValue`
- `resolutionTimeUnit`
- `resolutionTimeValue`

---

#### `Warranty`
Warranty coverage for an asset.

**Properties:**
- `warrantyId`
- `startDate`
- `endDate`
- `coverageDescription`

---

### 2.5 Supply Chain & Logistics (minimal v1)

#### `Shipment`

**Properties:**
- `shipmentId`
- `status` (Created, InTransit, Delivered, Delayed)
- `shipDate`
- `deliveryDate`
- `trackingNumber`
- `carrier`

---

### 2.6 Knowledge & RAG

#### `Document`
Logical document (PDF, HTML page, email thread, etc.).

**Properties:**
- `documentId`
- `sourceType` (OEM_Manual, Franchise_Playbook, Email, Support_Article, etc.)
- `title`
- `uri` (GDrive, S3, Notion, etc.)
- `mimeType`
- `createdAt`

---

#### `Chunk`
Atomic text chunk for retrieval.

**Properties:**
- `chunkId`
- `text`
- `embedding` (vector reference or inline)
- `position` (page/paragraph index)

---

### 2.7 Agents & Execution Trace

#### `Agent`
Represents an AI agent.

**Properties:**
- `agentId`
- `name` (e.g. "RoutingAgent", "SalesPrepAgent")
- `purpose`
- `model` (e.g. "gpt-5.1", "vertex-ai")

---

#### `AgentRun`
One execution of an agent.

**Properties:**
- `runId`
- `startedAt`
- `finishedAt`
- `status` (Success, Error)
- `inputSummary`
- `outputSummary`

---

### 2.8 Generic Reusable Types

#### `Interaction`
Generic engagement record: email, meeting, call, note, etc.

**Properties:**
- `interactionId`
- `type` (email, meeting, call, note)
- `channel` (Gmail, Zoom, WhatsApp, Manual)
- `timestamp`
- `subject` (optional)
- `summary`
- `rawRefId` (external system ID)

**Usage:**
- Covers engagement history for sales prep (Scenario 1).
- Avoids separate node labels for each channel.

---

#### `Playbook`
High-level sales or operations playbook.

**Properties:**
- `playbookId`
- `name`
- `description`

---

#### `PlaybookStage`
Stage within a playbook (e.g. Meeting #1 / #2 / #3).

**Properties:**
- `stageId`
- `name`
- `order`
- `content` (structured or markdown; can embed steps/goals)

---

#### `PlaybookStep` (optional)
Fine-grained step within a stage.

**Properties:**
- `stepId`
- `title`
- `text`
- `category` (goal, question, talk_track)

---

#### `Pattern`
Reusable tactic or pattern (e.g. sales tactic, common objection pattern).

**Properties:**
- `patternId`
- `kind` (deal_case, tactic, objection)
- `title`
- `description`
- `outcome` (won, lost, neutral)
- `strengthScore`

---

#### `Tag`
Generic tagging for pains, use-cases, etc.

**Properties:**
- `tagId`
- `kind` (pain_point, use_case, feature_flag, etc.)
- `value`

---

## 3. Relationships

This section lists key relationship types. Directions are chosen for typical query patterns; Neo4j can traverse both ways.

### 3.1 Identity & Roles

- `(p:Person)-[:WORKS_FOR]->(c:Company)`
- `(p:Person:Contact)-[:REPRESENTS]->(c:Company)`
- `(c1:Company)-[:PARTNERS_WITH]->(c2:Company)`
- `(c:Company:Franchise)-[:COVERS]->(t:Territory)`
- `(c:Company)-[:OPERATES_IN]->(t:Territory)`
- `(c:Company:Customer)-[:IN_INDUSTRY]->(ind:Industry)`
- `(c:Company:Customer)-[:IN_SEGMENT]->(seg:Segment)`
- `(c:Company)-[:HAS_SITE]->(s:Site)`
- `(s:Site)-[:BELONGS_TO]->(c:Company)`

### 3.2 Products & Assets

- `(m:Company:Manufacturer)-[:MANUFACTURES]->(p:Product)`
- `(d:Company:Distributor)-[:DISTRIBUTES]->(p:Product)`
- `(f:Company:Franchise)-[:SELLS]->(p:Product)`
- `(p:Product)-[:HAS_SKU]->(sku:SKU)`
- `(p:Product)-[:USES_PART]->(sp:SparePart)`

- `(r:RobotUnit)-[:OF_MODEL]->(p:Product)`
- `(r:RobotUnit)-[:INSTALLED_AT]->(s:Site)`
- `(r:RobotUnit)-[:OWNED_BY]->(c:Company)`

### 3.3 Commercial Lifecycle

- `(c:Company:Customer)-[:HAS_OPPORTUNITY]->(o:Opportunity)`
- `(o:Opportunity)-[:OWNED_BY]->(owner:Person:Employee)`

- `(c:Company:Customer)-[:PLACED_ORDER]->(ord:Order)`
- `(ord:Order)-[:SOLD_BY]->(seller:Company)`
- `(ord:Order)-[:HAS_LINE]->(ol:OrderLine)`
- `(ol:OrderLine)-[:OF_PRODUCT]->(p:Product)`
- `(ord:Order)-[:FULFILLED_BY]->(sh:Shipment)`

- `(c1:Company)-[:HAS_CONTRACT]->(ct:Contract)-[:WITH]->(c2:Company)`

### 3.4 Operations & Service

- `(st:ServiceTicket)-[:RAISED_BY]->(c:Company)`
- `(st:ServiceTicket)-[:CONTACT_PERSON]->(p:Person)`
- `(st:ServiceTicket)-[:FOR_ASSET]->(r:RobotUnit)`
- `(st:ServiceTicket)-[:HANDLED_BY]->(handler:Company)`

- `(st:ServiceTicket)-[:HAS_TASK]->(mt:MaintenanceTask)`
- `(mt:MaintenanceTask)-[:ASSIGNED_TO]->(p:Person:Employee)`
- `(mt:MaintenanceTask)-[:PERFORMED_DURING]->(v:Visit)`
- `(v:Visit)-[:AT_SITE]->(s:Site)`

- `(r:RobotUnit)-[:COVERED_BY]->(w:Warranty)`
- `(w:Warranty)-[:HAS_SLA]->(sla:SLA)`

### 3.5 Supply Chain & Logistics

- `(sh:Shipment)-[:DISPATCHED_FROM]->(sFrom:Site)`
- `(sh:Shipment)-[:DELIVERED_TO]->(sTo:Site)`

### 3.6 Knowledge & RAG

- `(doc:Document)-[:ABOUT_PRODUCT]->(p:Product)`
- `(doc:Document)-[:ABOUT_COMPANY]->(c:Company)`
- `(doc:Document)-[:ABOUT_SEGMENT]->(seg:Segment)`
- `(chunk:Chunk)-[:PART_OF]->(doc:Document)`
- `(chunk:Chunk)-[:MENTIONS_COMPANY]->(c:Company)`
- `(chunk:Chunk)-[:MENTIONS_PRODUCT]->(p:Product)`
- `(chunk:Chunk)-[:MENTIONS_ROBOT]->(r:RobotUnit)`

### 3.7 Interactions (Engagement History)

- `(c:Company)-[:HAS_INTERACTION]->(i:Interaction)`
- `(p:Person)-[:PARTICIPATED_IN]->(i:Interaction)`
- `(o:Opportunity)-[:RELATED_TO]->(i:Interaction)`

This pattern supports Scenario 1 (sales meeting prep) without separate `Meeting`, `Email`, etc. types.

### 3.8 Playbooks & Patterns

- `(pb:Playbook)-[:FOR_SEGMENT]->(seg:Segment)`
- `(pb:Playbook)-[:HAS_STAGE]->(stage:PlaybookStage)`
- `(stage:PlaybookStage)-[:HAS_STEP]->(step:PlaybookStep)`

- `(fr:Company:Franchise)-[:OBSERVED_PATTERN]->(p:Pattern)`
- `(seg:Segment)-[:RELEVANT_PATTERN]->(p:Pattern)`
- `(prod:Product)-[:RELEVANT_PATTERN]->(p:Pattern)`

### 3.9 Tags

- `(node)-[:TAGGED_WITH]->(tag:Tag)`

`node` can be `Company`, `Product`, `Pattern`, etc. Use tags for pain points, use cases, features, etc.

### 3.10 Agents & Execution Trace

- `(a:Agent)-[:RAN]->(run:AgentRun)`
- `(run:AgentRun)-[:TARGET_ENTITY]->(e)`  // e.g. Company, Order, Ticket
- `(run:AgentRun)-[:USED_CHUNK]->(chunk:Chunk)`
- `(run:AgentRun)-[:CREATED]->(st:ServiceTicket)`
- `(run:AgentRun)-[:UPDATED]->(ord:Order)`

---

## 4. Schema Usage Guidelines

### 4.1 Do NOT design per-agent schemas

- The schema should represent **Distify's reality**, not each agent task.
- Agents define **views** over the same enterprise graph.
- If a new agent appears, first try to answer its questions using existing nodes/relationships.

### 4.2 Use generic types where possible

- Use `Interaction` for all engagement channels (email, meeting, call, note).
- Use `Pattern` for reusable tactics or cross-franchise wisdom.
- Use `Tag` for pain points, use-cases, or other light taxonomy elements.

This avoids explosion of one-off node labels.

### 4.3 Promotion checklist (again)

Before adding a new node label, ask:

1. Will multiple agents or workflows query this thing directly?
2. Does it connect to 2+ other entity types via relationships?
3. Will it exist and be useful for years, not weeks?
4. Do we want graph analytics on it?

If **no**, implement as:
- Property
- Tag
- Part of unstructured content in `Document`/`Chunk`

### 4.4 Naming conventions

- Node labels: `PascalCase` (e.g. `Company`, `RobotUnit`, `ServiceTicket`)
- Relationship types: `UPPER_SNAKE_CASE` (e.g. `HAS_SITE`, `PLACED_ORDER`, `HAS_INTERACTION`)
- Properties: `camelCase` (e.g. `companyId`, `createdAt`)

### 4.5 Versioning & evolution

- Treat this document as the **source of truth** for the schema.
- Changes should:
  - Be reviewed for impact on existing data and agents.
  - Be backwards compatible where feasible (e.g. deprecate rather than delete labels).
- Consider adding a `SchemaVersion` node only if/when automated migrations are needed.

---

This is Distify.ai Enterprise Graph Schema v1. Future edits should refine properties and relationships based on real usage patterns and agent requirements, without violating the core principles described in Section 1.

