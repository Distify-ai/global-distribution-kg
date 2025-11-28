# Distify.ai Knowledge Graph Schema v2

**Purpose**: To model the entire **robot distribution value chain**—from manufacturers to franchisees to end customers and their robot units. This schema defines what our LLM can extract from unstructured data to build a graph that tracks value flow, not just static records.

**For**: LLM extraction agents, data modelers, and engineers building KG ingestion pipelines.

---

## Part 1: General Principles

### 1.1 What Are Entities?

**Entities** are the stable **nouns** in our business domain that:

-   Represent real-world things that exist and matter across workflows
-   Participate in multiple relationships with other entities
-   Are queried from many angles by different agents
-   Are long-lived (years, not days/weeks)

**Examples**: Companies, People, Robot Units, Sites, Products, Orders

### 1.2 What Are Relationships?

**Relationships** connect entities and represent:

-   Explicit facts about how entities relate to each other
-   Directional connections (though Neo4j can traverse both ways)
-   Context through relationship properties (dates, roles, status, etc.)

**Relationship Design Principles**:

-   Choose ONE direction based on primary query pattern
-   Don't create bidirectional redundant relationships
-   Use relationship properties for temporal/contextual information
-   Only create relationships that are explicitly stated or strongly implied

### 1.3 What Are Properties?

**Properties** are attributes that describe entities or relationships. All listed properties are **suggested** for extraction if present in the source data.

**Node Properties**:

-   Follow standardized formats (ISO dates, ISO currency codes, etc.)
-   Extract as many as possible from the source text
-   Use `null` or omit if not found (do not hallucinate)

**Relationship Properties**:

-   Temporal: `startDate`, `endDate`, `createdAt`
-   Quantitative: `strength`, `weight`, `score`
-   Business-specific: `role`, `percentage`, `amount`, `status`
-   **Meta-properties** (Critical for AI Graph):
    -   `source` (string) - origin of relationship ("manual", "inferred", "imported")
    -   `confidence` (float) - 0.0-1.0 score for inferred relationships

**Property Naming**: Use camelCase (e.g., `companyId`, `startDate`, `totalAmount`)

### 1.4 Labels in Neo4j

**About Labels**:

-   A node can have multiple labels (e.g., `:Company:Customer:Franchise`)
-   Labels are used for querying, indexing, and expressing roles/types
-   One real-world entity = one node with multiple labels as needed

**Identity & Deduplication**:

-   Always check for existing entities before creating new ones
-   Use key identifiers for matching: names, IDs, emails, addresses
-   Same entity with multiple roles = one node with multiple labels
-   ✅ `(:Company:Customer:Franchise)` - one node, multiple labels
-   ❌ Create separate `Customer` and `Franchise` nodes

---

## Part 2: Entity Definitions & Properties

### 2.1 Identity & Organization

#### `Company`

Physical or legal organization entity. Can represent customers, prospects, manufacturers, vendors, franchisees, distributors, partners, or service providers.

**Suggested Properties:**

-   `companyId` (string, UUID) - unique identifier
-   `companyName` (string) - primary name
-   `legalName` (string)
-   `country` (string)
-   `region` (string)
-   `city` (string)
-   `taxId` (string)
-   `website` (string)
-   `status` (string) - Active, Inactive, Prospect
-   `createdAt`, `updatedAt` (timestamp)

#### `Customer`

Company that purchases products/services in the value chain (either directly from Distify HQ or from a Franchisee). Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

#### `DistifyHQ`

The central entity representing our company. Used to anchor internal employees and direct relationships. Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

#### `Prospect`

Potential customer in sales pipeline. Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

#### `Manufacturer`

OEM that produces robots/equipment. Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

#### `Vendor`

Company we purchase from (products, parts, services). Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

#### `Franchisee`

Franchisee operating under Distify brand. Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

#### `Distributor`

Company that distributes products to market. Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

#### `Partner`

Strategic partner (channel, integration, referral). Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

#### `ServiceProvider`

Company providing services (logistics, maintenance). Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

#### `Competitor`

Company that competes in the ecosystem. Can be:

1.  **Direct Competitor**: Another distributor competing with Distify.
2.  **Manufacturer Competitor**: An OEM competing with our partner OEMs.
    _Shares all properties with `Company`._

#### `Person`

Individual human. Can represent employees, franchise employees, external contacts, or executives.

**Suggested Properties:**

-   `personId` (string, UUID)
-   `fullName` (string)
-   `email` (string)
-   `phone` (string)
-   `jobTitle` (string)
-   `timezone` (string)
-   `createdAt`, `updatedAt` (timestamp)

**System User Properties** (for persons with platform access):

-   `isSystemUser` (boolean)
-   `systemRole` (string) - "hq_admin", "franchisee_admin", "franchisee_user"
-   `lastLoginAt` (timestamp)

#### `Employee`

Distify HQ employee. Used as additional label on `Person` nodes.
_Shares all properties with `Person`._

#### `Contact`

External contact (at customer, partner, or franchise). Used as additional label on `Person` nodes.
_Shares all properties with `Person`._

#### `Site`

Physical location such as customer site, franchise hub, warehouse, or repair center.

**Suggested Properties:**

-   `siteId` (string, UUID)
-   `name` (string)
-   `siteType` (string) - CustomerSite, FranchiseHub, Warehouse, RepairCenter
-   `addressLine1`, `addressLine2` (string)
-   `city`, `region`, `country`, `postalCode` (string)
-   `location` (point) - lat/lon for proximity queries
-   `sqmSize` (number)

#### `Territory`

Geographical or commercial territory (country, region, city, or custom zone).

**Suggested Properties:**

-   `territoryId` (string, UUID)
-   `name` (string) - e.g., "Canada", "East Australia"
-   `type` (string) - Country, Region, City, CustomZone
-   `isoCode` (string) - e.g., "AU-NSW"

**Spatial properties** (for GIS integration):

-   `location` (Neo4j point type) - center point of territory for distance calculations
-   `boundingBox` (JSON) - {north, south, east, west} lat/lon bounds
-   `geojson` (string/JSON) - full GeoJSON representation for complex boundaries
-   `gisId` (string) - external GIS system ID (Google Maps, ArcGIS, etc.)
-   `gisProvider` (string) - "GoogleMaps", "ArcGIS", "OpenStreetMap"

#### `Industry`

Vertical industry classification using ISIC Rev 5 standard. Industries are organized in a hierarchy:

-   **Section**: 1 letter (e.g., "A - Agriculture, forestry and fishing")
-   **Division**: 2 digits (e.g., "01 - Crop and animal production...")
-   **Group**: 3 digits (e.g., "011 - Growing of non-perennial crops")
-   **Class**: 4 digits (e.g., "0111 - Growing of cereals...")

**Reference**: See `02_Product/Resources/ISIC_Rev_5_english_structure.csv`

**Suggested Properties:**

-   `industryId` (string, UUID)
-   `isicCode` (string) - Section (letter), Division (2-digit), Group (3-digit), or Class (4-digit) code
-   `isicTitle` (string) - official ISIC title
-   `level` (string) - hierarchy level: "Section", "Division", "Group", "Class"
-   `customName` (string) - optional local/market name
-   `aliases` (array) - alternative names

---

### 2.2 Products & Assets

#### `ProductCategory`

Product taxonomy category for organizing products in hierarchies.

**Suggested Properties:**

-   `categoryId` (string, UUID)
-   `name` (string)
-   `level` (integer) - hierarchy level (1, 2, 3...)
-   `description` (string)

#### `Product`

Product model or family (e.g., "S100 Pro M Scrubber").

**Suggested Properties:**

-   `productId` (string, UUID)
-   `name` (string)
-   `brand` (string)
-   `modelNumber` (string)
-   `description` (string)
-   `lifecycleStage` (string) - Alpha, Beta, GA, EOL

#### `RobotUnit`

Specific physical robot instance with unique serial number.

**Suggested Properties:**

-   `robotId` (string, UUID)
-   `serialNumber` (string)
-   `commissionedAt` (timestamp)
-   `status` (string) - Active, PendingInstall, InRepair, Retired
-   `firmwareVersion` (string)

#### `Part`

Parts, components, consumables, or accessories. Categorized by `partType` property.

**Suggested Properties:**

-   `partId` (string, UUID)
-   `partNumber` (string)
-   `name` (string)
-   `partType` (string) - component, spare, consumable, accessory
-   `description` (string)
-   `category` (string) - infrastructure, mechanical, electrical, chemical

---

### 2.3 Commercial Lifecycle

#### `Opportunity`

Sales opportunity or deal in pipeline.

**Suggested Properties:**

-   `opportunityId` (string, UUID)
-   `name` (string)
-   `stage` (string) - Prospect, Qualified, Proposal, Pilot, Won, Lost
-   `amount` (number)
-   `currency` (string)
-   `expectedCloseDate` (date)
-   `createdAt`, `closedAt` (timestamp)
-   `reasonLost` (string)

#### `Order`

Confirmed sales order.

**Suggested Properties:**

-   `orderId` (string, UUID)
-   `orderDate` (date)
-   `status` (string) - Draft, Confirmed, Shipped, Completed, Cancelled
-   `currency` (string)
-   `totalNet`, `totalTax`, `totalGross` (number)

#### `OrderLine`

Line item within an order.

**Suggested Properties:**

-   `orderLineId` (string, UUID)
-   `quantity` (number)
-   `unitPrice` (number)
-   `discount` (number)
-   `lineTotal` (number)
-   `lineType` (string) - Product, Service, Subscription

#### `Contract`

Legal agreement (Franchise, OEM, Service, Subscription).

**Suggested Properties:**

-   `contractId` (string, UUID)
-   `type` (string) - Franchise, OEM, Service, Subscription
-   `startDate`, `endDate` (date)
-   `autoRenew` (boolean)
-   `status` (string) - Active, Expired, Terminated
-   `slaLevel` (string) - 1-Day, 4-Hours, NBD

---

### 2.4 Generic Reusable Types

#### `Document`

Logical document (PDF, webpage, email, manual, playbook, online article, etc.).

**Suggested Properties:**

-   `documentId` (string, UUID)
-   `sourceType` (string) - OEM_Manual, Franchise_Playbook, Email, Support_Article, CompanyNews, PressRelease, BlogPost, SocialMedia, WebPage, ResearchReport, VideoTranscript
-   `title` (string)
-   `uri` (string) - GDrive, S3, Notion link, or web URL
-   `mimeType` (string)
-   `createdAt` (timestamp) - when document was ingested/discovered
-   `publishedDate` (date) - when content was originally published (for online resources)
-   `author` (string) - author or publisher name
-   `sentiment` (string) - Positive, Negative, Neutral (for news/social content)
-   `relevanceScore` (float) - how relevant to our business, 0.0-1.0

#### `Chunk`

Text chunk extracted from document for RAG retrieval.

**Suggested Properties:**

-   `chunkId` (string, UUID)
-   `text` (string)
-   `embedding` (vector)
-   `position` (integer) - page/paragraph index

#### `Tag`

Flexible label for concepts, topics, or potential entities that are not yet strictly defined in the schema. Acts as a bridge between unstructured data and the structured graph.

**Suggested Properties:**

-   `tagId` (string, UUID)
-   `name` (string) - The concept or topic name (normalized snake_case preferred)
-   `category` (string) - Optional grouping (e.g., "technology", "pain_point", "competitor_feature")

**Constraints:**

-   **Use for potential future entities**: Capture concepts that seem important but don't have a schema definition yet.
-   **Link to source**: Always link tags to the Document or Chunk where they were found.
-   **Avoid high cardinality**: Do NOT tag unique values like specific dates, IDs, or sentence fragments.
-   **Not unlimited**: Only create tags for concepts that appear to have reusability or analytical value.

---

### 2.5 Cadence & Engagement

#### `Interaction`

Record of any discrete event or activity (communication, visit, research, demo). Tracks the "pulse" of the business.

**Suggested Properties:**

-   `interactionId` (string, UUID)
-   `type` (string) - Email, Meeting, Call, SiteVisit, Research, Demo, Note, Installation
-   `timestamp` (timestamp)
-   `channel` (string) - Gmail, Zoom, WhatsApp, InPerson, Web
-   `subject` (string)
-   `summary` (string)
-   `outcome` (string) - Positive, Negative, Neutral, FollowUpNeeded
-   `durationMinutes` (integer)
-   `rawRefId` (string) - external system ID

#### `Task`

Actionable work item that needs to be completed.

**Suggested Properties:**

-   `taskId` (string, UUID)
-   `title` (string)
-   `description` (string)
-   `status` (string) - Pending, InProgress, Completed, Cancelled
-   `priority` (string) - Low, Medium, High, Urgent
-   `dueDate` (date)
-   `completedAt` (timestamp)
-   `createdAt`, `updatedAt` (timestamp)

#### `Goal`

Business objective to track progress against.

**Suggested Properties:**

-   `goalId` (string, UUID)
-   `name` (string) - e.g., "Close 10 deals in Q1"
-   `type` (string) - Sales, Onboarding, Revenue, Expansion
-   `targetValue` (number)
-   `currentValue` (number)
-   `startDate`, `endDate` (date)
-   `status` (string) - Active, Achieved, Missed, Cancelled

---

## Part 3: Relationships

### 3.1 Identity & Organization Relationships

**Company:**

-   `(Company)-[:HAS_SITE]->(Site)`
-   `(Company)-[:IN_INDUSTRY]->(Industry)`
-   `(Company)-[:HAS_CONTRACT]->(Contract)`
-   `(Company)-[:PLACED_ORDER]->(Order)`
-   `(Company)-[:HAS_OPPORTUNITY]->(Opportunity)`
-   `(Company)-[:HAS_INTERACTION]->(Interaction)`
-   `(Company)-[:TAGGED_WITH]->(Tag)`

**Company-to-Company Relationships:**

-   `(Company)-[:SELLS_TO {products, since}]->(Company)` - Generic sales relationship (Manufacturer→Distributor, Distributor→Franchisee, etc.)
-   `(Company)-[:SUPPLIES {materialType, since}]->(Company)` - Vendor/Supplier relationship
-   `(Company)-[:PARTNERS_WITH {type, since}]->(Company)` - Strategic partnership (symmetric)
-   `(Company)-[:FRANCHISES {territory, contractId}]->(Company)` - Franchisor (DistifyHQ) → Franchisee
-   `(Company)-[:SERVICES {serviceType}]->(Company)` - ServiceProvider → Customer/Company
-   `(Company)-[:PARENT_COMPANY_OF]->(Company)` - Corporate hierarchy
-   `(Company)-[:SUBSIDIARY_OF]->(Company)` - Corporate hierarchy
-   `(Company)-[:COMPETES_WITH {strength, market}]->(Company)` - Competitor relationship

**Company with specific labels:**

-   `(Company:Manufacturer)-[:MANUFACTURES {since}]->(Product)`
-   `(Company:Distributor)-[:DISTRIBUTES {territory, since}]->(Product)`
-   `(Company:Franchisee)-[:SELLS {authorizedDate, status}]->(Product)`
-   `(Company:Franchisee)-[:COVERS {startDate, endDate, exclusivityLevel}]->(Territory)`
-   `(Company:Customer)-[:OWNS {purchaseDate, purchasePrice, warrantyEndDate}]->(RobotUnit)`
-   `(Company:Competitor)-[:COMPETES_ON {status, strength, notes}]->(Opportunity)` - Head-to-head on specific deal

**Person:**

-   `(Person)-[:WORKS_FOR {startDate, endDate, role, department}]->(Company)`
-   `(Person)-[:REPRESENTS {isPrimary, role}]->(Company)` - for external contacts. role: Decision Maker, Point of Contact, Billing
-   `(Person)-[:HAS_ROLE_IN {role}]->(Opportunity)` - role: Decision Maker, Champion, Influencer, Blocker
-   `(Person)-[:PARTICIPATED_IN {role}]->(Interaction)` - role: organizer, attendee, presenter

**Territory:**

-   `(Territory)-[:PART_OF]->(Territory)` - for hierarchy (Sydney → NSW → Australia)

---

### 3.3 Product & Asset Relationships

**ProductCategory:**

-   `(ProductCategory)-[:SUBCATEGORY_OF]->(ProductCategory)` - for hierarchy

**Product:**

-   `(Product)-[:IN_CATEGORY]->(ProductCategory)`
-   `(Product)-[:REQUIRES_COMPONENT]->(Part)` - essential components
-   `(Product)-[:COMPATIBLE_WITH {source, confidence}]->(Part)` - optional accessories
-   `(Product)-[:USES_CONSUMABLE {replacementFrequency}]->(Part)` - regular consumables
-   `(Product)-[:HAS_SPARE]->(Part)` - replacement parts
-   `(Product)-[:COMPETES_WITH]->(Product)` - Product-level competition

**RobotUnit:**

-   `(RobotUnit)-[:OF_MODEL]->(Product)`
-   `(RobotUnit)-[:INSTALLED_AT {installDate, commissionedBy}]->(Site)`
-   `(RobotUnit)-[:OWNED_BY {purchaseDate, purchasePrice, warrantyEndDate}]->(Company)`

---

### 3.4 Commercial Lifecycle Relationships

**Order:**

-   `(Order)-[:HAS_LINE]->(OrderLine)`
-   `(Order)-[:SOLD_BY]->(Company)`

**OrderLine:**

-   `(OrderLine)-[:OF_PRODUCT]->(Product)`

**Contract:**

-   `(Contract)-[:WITH]->(Company)`

---

### 3.5 Knowledge & Document Relationships

**Document:**

-   `(Document)-[:ABOUT_PRODUCT]->(Product)`
-   `(Document)-[:ABOUT_COMPANY]->(Company)`
-   `(Document)-[:DISCOVERED_BY]->(Person)` - who found/uploaded this resource
-   `(Document)-[:TAGGED_WITH]->(Tag)` - for general topics/concepts

**Chunk:**

-   `(Chunk)-[:PART_OF]->(Document)`
-   `(Chunk)-[:MENTIONS_COMPANY]->(Company)`
-   `(Chunk)-[:MENTIONS_PRODUCT]->(Product)`
-   `(Chunk)-[:MENTIONS_ROBOT]->(RobotUnit)`
-   `(Chunk)-[:TAGGED_WITH]->(Tag)` - for specific concepts in this text chunk

---

### 3.6 Cadence & Engagement Relationships

**Interaction:**

-   `(Interaction)-[:RELATED_TO]->(Opportunity)`
-   `(Interaction)-[:HAPPENED_AT]->(Site)` - for SiteVisits, Demos
-   `(Interaction)-[:CONCERNS]->(Company)` - for Research, Notes about a company
-   `(Interaction)-[:CONCERNS]->(Product)` - for Demos, Feedback
-   `(Interaction)-[:CREATED_BY]->(Person)` - the actor who performed the interaction

**Task:**

-   `(Task)-[:ASSIGNED_TO]->(Person)`
-   `(Task)-[:RELATED_TO_OPPORTUNITY]->(Opportunity)`
-   `(Task)-[:RELATED_TO_COMPANY]->(Company)`
-   `(Task)-[:PART_OF_GOAL]->(Goal)`

**Goal:**

-   `(Goal)-[:OWNED_BY]->(Person)` - individual goal owner
-   `(Goal)-[:OWNED_BY]->(Company)` - company/franchisee goal owner
-   `(Opportunity)-[:CONTRIBUTES_TO]->(Goal)`
-   `(Order)-[:CONTRIBUTES_TO]->(Goal)`

---

## Part 4: LLM Extraction Organizing Principles

These principles guide LLMs to extract data correctly following the schema defined in Parts 2-3.

### 4.1 Organizing for Distribution Value Chain

**The "Spine" & "Flesh" Strategy**:

To make the graph useful for distribution, we organize data into two layers:

1.  **The Spine (Value Chain Structure)**:

    -   **Goal**: Establish the rigid backbone of the market.
    -   **Flow**: `Manufacturer` → `Distributor` → `Franchisee` → `Customer` → `RobotUnit`.
    -   **Key Relationships**: `SELLS_TO`, `FRANCHISES`, `OWNS`, `INSTALLED_AT`.
    -   **Rule**: Every extracted entity should try to anchor itself to this spine. A loose `RobotUnit` is useless; a `RobotUnit` owned by a `Customer` in a `Territory` is valuable.

2.  **The Flesh (Cadence & Context)**:
    -   **Goal**: Capture the dynamic pulse of business on top of the spine.
    -   **Components**: `Interaction`, `Task`, `Document`, `Opportunity`.
    -   **Key Relationships**: `HAPPENED_AT` (Site), `CONCERNS` (Company/Product), `RELATED_TO` (Opportunity).
    -   **Rule**: Interactions must link to the "Spine" (Who did it? Where? About whom?).

### 4.2 Extraction Philosophy

**Goal**: Extract clean, useful instance data (facts) that builds a knowledge graph grounded in reality.

**Core Principles**:

1. **Follow the schema strictly** - Only create entities and relationships defined in Parts 2-3
2. **One entity, one node** - Deduplicate aggressively using identity rules
3. **Facts over opinions** - Extract what IS, not what MIGHT BE
4. **Explicit over inferred** - Only create relationships explicitly stated or strongly implied

### 4.3 Entity Extraction Rules

**When to create a node:**

-   Entity is mentioned with specific identifying information (name, ID, serial number, date)
-   Entity participates in relationships with 2+ other entities
-   Entity will be queried across multiple documents

**When to skip:**

-   Generic mentions without identifying details ("a customer", "some robots")
-   One-off facts that are better as properties
-   Opinions, hypotheticals, or unconfirmed information

**Examples:**

-   ✅ "Acme Corp signed a $500k deal" → Create `Company`, `Order` nodes
-   ✅ "Robot S/N 12345 installed at Sydney office" → Create `RobotUnit`, `Site` nodes
-   ❌ "We might expand to healthcare sector" → Don't create `Industry` node (hypothetical)
-   ❌ "The customer was happy" → Don't create node (opinion/sentiment)

### 4.4 Label Assignment Rules

**How to assign labels:**

-   Start with base entity type (`Company`, `Person`, `Product`, etc.)
-   Add role/type labels based on context (`:Customer`, `:Manufacturer`, `:Employee`, etc.)
-   One node can have multiple labels

**Examples:**

-   "Acme Corp is a customer" → `(:Company:Customer)`
-   "Acme Corp manufactures robots and is also our customer" → `(:Company:Customer:Manufacturer)`
-   "John Smith is CTO at Acme" → `(:Person:Contact:Executive)`

### 4.5 Deduplication Strategy

**Before creating any node, search for existing:**

| Entity Type | Search By                              |
| ----------- | -------------------------------------- |
| Company     | `companyName`, `legalName`, `taxId`    |
| Person      | `email`, or (`fullName` + `companyId`) |
| Product     | `modelNumber`, or (`brand` + `name`)   |
| Site        | Full address components                |
| RobotUnit   | `serialNumber`                         |
| Part        | `partNumber`                           |

**Handling uncertainty:**

-   If confidence < 80% that two entities are the same, create separate nodes
-   Use fuzzy matching for name variations (case-insensitive, remove punctuation)
-   Flag low-confidence matches for human review

**Multiple labels on same node:**

-   Same entity with multiple roles = add multiple labels to ONE node
-   ✅ `(:Company:Customer:Manufacturer {companyName: "Acme Corp"})`
-   ❌ Create separate `Customer` and `Manufacturer` nodes for same company

### 4.6 Relationship Extraction Rules

**Only create relationships that are:**

1. **Explicitly stated** in source material ("John Smith works for Acme Corp")
2. **Strongly implied** by context ("Acme's CTO John Smith" → `WORKS_FOR` relationship)

**Don't create relationships that are:**

-   Hypothetical ("Acme might partner with XYZ")
-   Uncertain ("We're discussing with potential customer ABC")
-   Inferred through complex logic chains

**Relationship properties:**

-   Extract temporal information: `startDate`, `endDate`
-   Extract role information: `role`, `status`
-   Extract quantitative information: `amount`, `percentage`

**Example:**

```cypher
// Good: explicit relationship with properties
(john:Person)-[:WORKS_FOR {role: "CTO", startDate: "2024-01-15"}]->(acme:Company)

// Good: strongly implied relationship
(acme:Company)-[:IN_INDUSTRY]->(healthcare:Industry)

// Good: B2B sales relationship
(mfg:Company:Manufacturer)-[:SELLS_TO {since: "2023"}]->(dist:Company:Distributor)

// Bad: uncertain relationship
// "Acme might partner with XYZ" → Don't create PARTNERS_WITH
```

### 4.7 Property Extraction & Normalization

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

### 4.8 Tagging Rules

**Goal**: Capture "unknown unknowns" and potential new entities without polluting the graph.

1.  **Catch-all for undefined entities**: If an important concept appears (e.g., "Lidar Navigation", "ISO 9001 Certification") and has no Entity type, create a Tag.
2.  **Normalize names**: Convert to lowercase, snake_case (e.g., "Lidar Navigation" → `lidar_navigation`).
3.  **Link to Evidence**: Tags are most valuable when linked to `Chunk` or `Document` to show where the concept emerged.
4.  **Monitor for promotion**: If a Tag is used frequently (e.g., >50 times) OR participates in relationships with 2+ other entity types, it should be promoted to a first-class Entity in the next schema version.
5.  **Restraint**: Do not tag every noun. Only tag concepts that seem to have business significance or filtering value.

### 4.9 Data Quality Checks

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

**Example:**

```cypher
(:Company {companyName: "Acme Corp"})
  -[:EXTRACTED_FROM {
      confidence: 0.95,
      source: "doc123",
      extractedAt: timestamp()
    }]->
  (:Document {documentId: "doc123"})
```

### 4.10 Extraction Scope (MVP)

**What to extract:**

-   ✅ Companies, People, Geography (Territory, Site)
-   ✅ Industry
-   ✅ Products, RobotUnits, Parts
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
    - Inferred missing data (unless explicitly instructed)

### 4.11 Extraction Workflow

**Step-by-step process:**

1. **Parse document**

    - Identify document type, structure, key sections
    - Extract metadata (title, source, date)

2. **Entity extraction**

    - Extract all entities with identifying information
    - Generate UUIDs for new entities
    - Match against existing graph to deduplicate
    - Assign appropriate labels (base + role labels)

3. **Relationship extraction**

    - Identify explicit relationships
    - Extract relationship properties (dates, roles, amounts)
    - Validate both endpoints exist

4. **Validation**

    - Run data quality checks (no orphans, no duplicates, type consistency)
    - Verify relationship directionality matches schema

5. **Confidence scoring**

    - Tag entities/relationships with confidence scores
    - Flag low-confidence extractions for human review

6. **Output generation**
    - Generate Cypher statements (MERGE for deduplication)
    - Include ON CREATE and ON MATCH clauses
    - Add extraction metadata relationships

**Example output:**

```cypher
// Create or merge Company with multiple labels
MERGE (c:Company {companyId: "uuid-123"})
  ON CREATE SET
    c.companyName = "Acme Corp",
    c.country = "Australia",
    c.createdAt = timestamp()
  ON MATCH SET
    c.updatedAt = timestamp()
SET c:Customer:Manufacturer

// Create or merge Person
MERGE (p:Person {email: "john@acme.com"})
  ON CREATE SET
    p.personId = "uuid-456",
    p.fullName = "John Smith",
    p.createdAt = timestamp()
SET p:Contact:Executive

// Create relationship with properties
MERGE (p)-[:WORKS_FOR {
  role: "CTO",
  startDate: "2024-01-15"
}]->(c)

// Tag extraction source
CREATE (c)-[:EXTRACTED_FROM {
  confidence: 0.95,
  extractedAt: timestamp()
}]->(:Document {documentId: $docId})
```

---

## Part 5: Schema Governance

### 5.1 Naming Conventions

-   **Node labels**: PascalCase (Company, RobotUnit, ProductCategory)
-   **Relationship types**: UPPER_SNAKE_CASE (HAS_SITE, PLACED_ORDER, WORKS_FOR)
-   **Properties**: camelCase (companyId, createdAt, siteType)

### 5.2 When to Add New Entity Types

Before adding a new label, verify ALL of the following:

1. ✅ Multiple workflows/queries will use it
2. ✅ It connects to 2+ existing entity types
3. ✅ It's long-lived and reusable (years, not weeks)
4. ✅ We need graph analytics on it

**If NO to any above, use instead:**

-   Property on existing node
-   Tag node for simple categorization
-   Store in Document/Chunk for unstructured content

### 5.3 Schema Evolution

-   This document is the **source of truth**
-   Changes must be backwards-compatible where possible
-   Deprecate old labels rather than delete
-   Version schema updates clearly (v2.0, v2.1, v2.2, etc.)
-   Review impact on existing data and extraction agents before changes

---

## Part 6: Reference

### 6.1 Example Cypher Queries

**Find all customers in a territory:**

```cypher
MATCH (c:Company:Customer)-[:OPERATES_IN]->(t:Territory {name: "East Australia"})
RETURN c.companyName, c.status
```

**Get engagement history for a company:**

```cypher
MATCH (c:Company {companyId: $companyId})-[:HAS_INTERACTION]->(i:Interaction)
MATCH (p:Person)-[:PARTICIPATED_IN]->(i)
RETURN i.timestamp, i.type, i.subject, collect(p.fullName) as participants
ORDER BY i.timestamp DESC
```

**Find robots at a customer site:**

```cypher
MATCH (c:Company {companyId: $companyId})-[:HAS_SITE]->(s:Site)
MATCH (r:RobotUnit)-[:INSTALLED_AT]->(s)
MATCH (r)-[:OF_MODEL]->(p:Product)
RETURN s.name, r.serialNumber, p.name, r.status
```

**Get products sold by franchisee in a segment:**

```cypher
MATCH (f:Company:Franchisee {companyId: $franchiseId})-[:SELLS]->(p:Product)
MATCH (p)-[:IN_CATEGORY]->(cat:ProductCategory)
MATCH (c:Company:Customer)-[:IN_INDUSTRY]->(ind:Industry)
RETURN p.name, cat.name, count(DISTINCT c) as potentialCustomers
``

---

**End of KG Schema v2**
```
