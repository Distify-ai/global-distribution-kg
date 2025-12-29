# Global Distribution Schema V2 (Rich Fact-First)

> **Core Philosophy**: We model the **Universal Facts** of the business (what physically or legally happened), not the **Roles** (how we interpret those facts).
> 
> *   **Facts (Immutable)**: "Acme Corp signed a contract." "Robot #123 was shipped."
> *   **Roles (Derived)**: "Acme is a Customer." "Robot #123 is Inventory." (These are queries, not stored data).

---

## 1. Organization & Core Entities

### `Company`
**Definition**: A `Company` node represents any legal or formalized organization that exists independently in the real world. This includes registered corporations, non-profit organizations, government bodies, and clearly defined business units that operate with autonomy. It serves as the single source of truth for an entity's identity, regardless of the multiple roles it may play over time (e.g., a company can simultaneously be a manufacturer, a customer, and a partner).

**Extraction Guide**: Create a `Company` node whenever a named organization is identified as an actor in a business context. Do **not** create separate nodes for different functional roles (e.g., do not create a "Supplier Record" node and a "Customer Record" node for the same entity). If an organization has multiple branches, only model them as separate `Company` nodes if they are legally distinct subsidiaries or require separate financial tracking; otherwise, treat them as the same entity.

*   **Properties**:
    *   `companyId` (UUID) - Unique system identifier.
    *   `legalName` (string) - Formal registered name (e.g., "Acme Corp Ltd.").
    *   `tradeName` (string) - Doing business as (DBA) name (e.g., "Acme Robotics").
    *   `taxId` (string) - Tax identification number if available.
    *   `website` (url) - Primary domain.
    *   `description` (string) - Brief summary of business activities.
    *   `status` (enum) - `Active`, `Inactive` (only if explicitly stated).
    *   `country`, `region`, `city` (string) - Headquarters location.
    *   `stockSymbol` (string) - If public.

### `Person`
**Definition**: A `Person` node represents a specific human individual who interacts with the business ecosystem. This entity captures their professional identity and contact details, anchored to the reality of their existence rather than their temporary influence or sentiment.

**Extraction Guide**: Extract a `Person` node for any named individual mentioned in emails, meetings, contracts, or organizational charts. Do **not** attempt to model subjective attributes like "champion", "decision-maker", or "influencer" as node labels or static properties, as these are fluid assessments (represented by `Intent` or `Events`). A person's `jobTitle` is a universal fact; their strategic value is a derived insight.

*   **Properties**:
    *   `personId` (UUID) - Unique identifier.
    *   `fullName` (string) - First and last name.
    *   `email` (string) - Business email.
    *   `phone` (string) - Contact number.
    *   `jobTitle` (string) - Official title (e.g., "VP of Sales").
    *   `roleCategory` (string) - Generalized role for grouping (e.g., "Executive", "Technical", "Sales").
    *   `timezone` (string) - IANA timezone string.
    *   `linkedinUrl` (url) - Social profile.

### `Site`
**Definition**: A `Site` node represents a distinct, physical location on Earth where business operations, storage, or interactions occur. This includes warehouses, corporate offices, retail stores, data centers, and customer facilities where equipment is installed.

**Extraction Guide**: Differentiate carefully between a `Company` (the legal entity) and a `Site` (the bricks-and-mortar location). A Company *operates* or *owns* a Site. Inventory is stored at a `Site`, not at a `Company`. Even if a company has only one location, model the `Site` separately to allow for future expansion and precise logistics tracking.

*   **Properties**:
    *   `siteId` (UUID) - Unique identifier.
    *   `name` (string) - Descriptive name (e.g., "Northwing Warehouse").
    *   `type` (enum) - `Warehouse`, `Office`, `Retail`, `DataCenter`, `CustomerSite`.
    *   `address` (string) - Full street address.
    *   `city`, `postalCode` (string) - Location details.
    *   `geo` (point) - Latitude/Longitude.
    *   `capacity_sqm` (number) - Usage size if specified.

### `Equipment`
**Definition**: An `Equipment` node represents a specific, tangible physical asset that exists in the real world. unlike a `Product` (which is a conceptual model), `Equipment` is the actual hardware instance that can be touched, shipped, repaired, and tracked by a unique identifier (like a serial number).

**Extraction Guide**: Create an `Equipment` node only when referring to a specific physical unit (e.g., "The robot with serial #123 needs service"). Do **not** confuse this with the general concept of the product model. If a customer buys five robots, there are five `Equipment` nodes, all linked to one `Product` model node.

*   **Properties**:
    *   `equipmentId` (UUID) - Unique identifier.
    *   `serialNumber` (string) - The manufacturer's unique mark.
    *   `assetTag` (string) - Internal tracking tag.
    *   `firmwareVersion` (string) - Current software version.
    *   `commissionedAt` (timestamp) - Date put into service.
    *   `status` (enum) - `Active`, `InRepair`, `Retired`, `Inventory`.

---

## 2. Classification Entities

### `Territory`
**Definition**: A `Territory` node defines a meaningful geographic or commercial zone used for operational organization. This can be strictly political (countries, continents) or purely commercial (sales regions like "EMEA" or "North America East").

**Extraction Guide**: Use `Territory` to model the "where" of business responsibilities. Companies operate in Territories; Sales People are assigned to Territories. Do not confuse this with simple address fields; Territories are structural nodes used for grouping and logic.

*   **Properties**:
    *   `territoryId` (UUID).
    *   `name` (string) - E.g., "EMEA", "North America", "France".
    *   `type` (enum) - `Country`, `Region`, `Continent`, `SalesZone`.
    *   `isoCode` (string) - ISO 3166 code if applicable.

### `Industry`
**Definition**: An `Industry` node represents a standard economic classification that describes a company's primary business activity. We use standard taxonomies (like ISIC or NAICS) to ensure objective classification.

**Extraction Guide**: Map companies to `Industry` nodes to describe *what they do* fundamentally (e.g., "Manufacturing", "Retail"), not their relationship to us. Do not use this for ad-hoc grouping like "High Value Targets"; that is a `Goal` or `Opportunity` property.

*   **Properties**:
    *   `industryId` (UUID).
    *   `isicCode` (string).
    *   `title` (string) - E.g., "Manufacturing of Electronics".

---

## 3. Product Entities

### `Product`
**Definition**: A `Product` node represents an abstract model, family, or item defined in a manufacturer's catalog. It is the conceptual "idea" of the item, holding all specifications, marketing descriptions, and manufacturing details that apply to every unit of that type.

**Extraction Guide**: Create a `Product` node for every unique model or item offered. This includes finished goods (robots), major components (batteries), and consumables. Remember: "The T-800" is a `Product`; "Arnold's T-800" is `Equipment`.

*   **Properties**:
    *   `productId` (UUID).
    *   `modelName` (string) - Commercial name (e.g., "T-800", "Battery-Pack-50").
    *   `brand` (string) - Brand name.
    *   `type` (string) - Hint (e.g., "Robot", "Battery", "Sensor").
    *   `description` (string) - Marketing description.

### `SKU`
**Definition**: A `SKU` (Stock Keeping Unit) node represents a specific, purchasable configuration of a `Product`. While the `Product` defines the technical model, the `SKU` defines the commercial package, including specific power cords, color options, bundle contents, and pricing.

**Extraction Guide**: Use `SKU` when specific sales configurations are discussed (e.g., "T-800 with EU Plug"). This allows separating commercial packaging from engineering specifications.

*   **Properties**:
    *   `sku` (string) - Unique string identifier.
    *   `name` (string) - Sales name.
    *   `currency` (string) - Currency code.
    *   `listPrice` (number) - Standard price.

### `ProductCategory`
**Definition**: A `ProductCategory` node represents a taxonomic group used to organize products into broader families (e.g., "Cleaning Robots", "Mowing Robots").

**Extraction Guide**: Use categories for stable, long-term classification. Avoid creating categories for temporary marketing campaigns (e.g., "Summer Sale Items").

*   **Properties**: `categoryId`, `name`, `description`.

---

## 4. Business Commitments (The Ledger)
> **CRITICAL RULE**: These entities exist ONLY if verified by a document (Contract, Order). We do not imply them.

### `CommercialRelationship`
**Definition**: A `CommercialRelationship` node represents a formal, legally binding bond between two business entities. It reifies the abstract concept of "partnership" into a concrete node backed by dates, types, and statuses.

**Extraction Guide**: **Trap Alert**: Do NOT create this node for "Prospects", "Leads", or casual "Partners". Those are `Intent` states. Identify a `CommercialRelationship` ONLY when there is evidence of a signed agreement establishing a long-term status, such as "Authorized Distributor", "Franchisee", or "Contracted Vendor".

*   **Properties**:
    *   `relationshipId` (UUID).
    *   `type` (enum) - `Franchise`, `Partnership`, `ServiceAgreement`, `Distributorship`.
    *   `status` (enum) - `Active`, `Expired`, `Terminated`.
    *   `startDate` (date).
    *   `endDate` (date).

### `Contract`
**Definition**: A `Contract` node represents the actual physical or digital legal document that codifies a business agreement. It serves as the immutable "proof of truth" for any `CommercialRelationship` or major transaction.

**Extraction Guide**: Create this node when a specific contract document is referenced (e.g., "Refer to the 2024 Master Service Agreement"). Every `CommercialRelationship` should ideally be `DEFINED_BY` a `Contract`.

*   **Properties**:
    *   `contractId` (UUID).
    *   `referenceNumber` (string).
    *   `type` (enum) - `Distribution`, `Franchise`, `Service`, `NDA`.
    *   `status` (enum).

### `Order`
**Definition**: An `Order` node represents a confirmed, financial obligation to exchange goods or services for money. It is a transactional fact that cannot be undone, only updated via status changes.

**Extraction Guide**: **Trap Alert**: Quotes, Estimates, and Pro-Forma Invoices are **not** Orders; they are `Opportunities` or `Events`. Only create an `Order` node when a purchase is confirmed (e.g., PO received, payment verified).

*   **Properties**:
    *   `orderId` (UUID).
    *   `orderNumber` (string).
    *   `status` (enum) - `Confirmed`, `Shipped`, `Paid`, `Cancelled`.
    *   `totalAmount` (number).
    *   `currency` (string).

### `OrderLine`
**Definition**: An `OrderLine` node represents a distinct line item within a parent `Order`. It captures the specific quantity and price of a single SKU being purchased.

*   **Properties**: `quantity`, `unitPrice`, `total`.

---

## 5. Business Intent (The Pipeline)
> **CRITICAL RULE**: These represent *Internal Beliefs* or *Plans*, not external reality.

### `Opportunity`
**Definition**: An `Opportunity` node represents an internal belief that a business transaction might occur in the future. It acts as a container for all sales activities, notes, and probability assessments related to a potential deal.

**Extraction Guide**: Use this for anything that is "possible" but not "done". Sales leads, unqualified prospects, open negotiations, and sent proposals all live here. If a Company is a "Prospect", that means there is an active `Opportunity` related to them; it does NOT mean the Company node itself changes type.

*   **Properties**:
    *   `opportunityId` (UUID).
    *   `name` (string) - Deal name.
    *   `stage` (enum) - `Prospect`, `Qualified`, `Proposal`, `Negotiation`, `ClosedWon`, `ClosedLost`.
    *   `amount` (number).
    *   `confidence` (float).
    *   `expectedCloseDate` (date).

### `Goal`
**Definition**: A `Goal` node represents a declared strategic objective or quantitative target set by the organization. It allows linking daily activities and opportunities to broader corporate ambitions.

**Extraction Guide**: Extract statements of intent (e.g., "We aim to sell 500 units in Q4") as `Goal` nodes. This allows the system to measure progress ('Facts') against desires ('Goals').

*   **Properties**: `name`, `targetValue`, `metric`, `timeScope`.

---

## 6. Events (The Timeline)
> **CRITICAL RULE**: If it happened at a specific time, it is an Event.

### `Event`
**Definition**: An `Event` node represents a single, immutable point-in-time occurrence that is critical to the business history. It is the atomic unit of truth in the knowledge graph. This broad category encompasses **two key types offered**:
1.  **Interactions**: External happenings like a webinar, a meeting, or an email.
2.  **Critical State Changes**: Internal milestones like "Series B Fund Raised", "Budget Confirmed", "Deal Qualified", or "System Error Logged".
If it happened at a specific timestamp and alters the state of the business, it is an `Event`.

**Extraction Guide**: Model EVERYTHING that happens in time as an `Event`.
*   **Do not just update properties**: Instead of just changing a Company's status to "Active", create a `StatusChange` event so we know *when* and *why* it happened.
*   **Capture Milestones**: If a text says "Customer confirmed budget on Tuesday", create a `BudgetConfirmed` event linked to the Opportunity.
*   **Granularity**: Only model events that have business significance. do not model every mouse click, but DO model every stage change in a sales pipeline.

*   **Properties**:
    *   `eventId` (UUID).
    *   `eventCategory` (enum) - `Interaction`, `Activity`, `StateChange`, `SystemLog`.
    *   `eventType` (string) - `Call`, `Meeting`, `Email`, `OrderPlaced`, `FundRaised`, `BudgetConfirmed`, `StageChange`.
    *   `occurredAt` (timestamp).
    *   `summary` (string).
    *   `source` (string).

---

## 7. Provenance (Evidence)

### `Source`
Provenance Container (Infrastructure, not Knowledge).
*   **LLM Rule**: The file, URL, or document where facts were extracted from.
*   **Properties**:
    *   `sourceId` (UUID) - Unique identifier.
    *   `sourceType` (enum) - `PDF`, `Email`, `Chat`, `NewsArticle`, `WebPage`.
    *   `uri` (string) - Location or Path.
    *   `ingestedAt` (timestamp) - Processing time.
    *   `title` (string) - Document title.

### `Chunk`
Evidence fragment supporting facts.
*   **LLM Rule**: The specific paragraph or sentence used for extraction.
*   **Properties**:
    *   `chunkId` (UUID) - Unique identifier.
    *   `text` (string) - The content.
    *   `confidence` (float) - Extraction confidence.

---

## 8. Universal Fact Relationships (The Verbs)

### Organization Structure

#### `(:Company)-[:SUBSIDIARY_OF]->(:Company)`
*   **Definition**: Represents legal ownership where one company owns another.
*   **Usage**: Company A owns Company B.

#### `(:Site)-[:LOCATED_IN]->(:Territory)`
*   **Definition**: Geographic binding of a physical site.
*   **Usage**: The warehouse is physically located in a specific territory (e.g., France).

#### `(:Company)-[:HAS_SITE]->(:Site)`
*   **Definition**: Operational possession of a facility.
*   **Usage**: Company A operates or leases this facility.

#### `(:Person)-[:WORKS_FOR]->(:Company)`
*   **Definition**: Primary Employment / Professional Home.
*   **Usage**: Person A is employed by Company B (Payroll/Contract). 
*   **Correction**: Do **NOT** use this for external partners working on a project. If a Partner works with us, they `WORKS_FOR` their own Company, and that Company `HAS_RELATIONSHIP` with us.

#### `(:Company)-[:OPERATES_IN]->(:Territory)`
*   **Definition**: General commercial presence in a region.
*   **Usage**: Company A does business in Region B (e.g., Sales presence).

### Commercial Links (The Bridge)

#### `(:Company)-[:HAS_RELATIONSHIP]->(:CommercialRelationship)`
*   **Definition**: Structural link to a formal relationship node.
*   **Usage**: Connects a company to the node storing relationship details (dates, type).

#### `(:CommercialRelationship)-[:DEFINED_BY]->(:Contract)`
*   **Definition**: Evidentiary link to the contract.
*   **Usage**: This relationship is valid and defined by this specific Contract.

#### `(:CommercialRelationship)-[:RELATIONSHIP_CHANGED]->(:Event)`
*   **Definition**: Audit trail of relationship status changes.
*   **Usage**: The relationship was renewed, terminated, or changed at this specific time.

### Transactions (The Trade)

#### `(:Company)-[:PLACED_ORDER]->(:Order)`
*   **Definition**: The purchasing act. (Buyer -> Order)
*   **Usage**: Entity paying for the goods.

#### `(:Order)-[:SOLD_BY]->(:Company)`
*   **Definition**: The selling act. (Order -> Seller)
*   **Usage**: Entity receiving the money and fulfilling the order.

#### `(:Order)-[:CONTAINS_LINE]->(:OrderLine)`
*   **Definition**: Granular breakdown of an order.
*   **Usage**: Links the parent order to its specific line items.

#### `(:OrderLine)-[:REFERENCES_SKU]->(:SKU)`
*   **Definition**: Item specification.
*   **Usage**: Specifies exactly what product configuration was purchased.

#### `(:Contract)-[:BINDS_COMPANY]->(:Company)`
*   **Definition**: Legal signatory.
*   **Usage**: Identifies the parties who signed the legal document.

#### `(:Company)-[:OWNS_ASSET]->(:Equipment)`
*   **Definition**: Asset ownership.
*   **Usage**: Legal title holder of the machine.

### Supply Chain & Product

#### `(:Company)-[:MANUFACTURES]->(:Product)`
*   **Definition**: Product origin.
*   **Usage**: Entity that designs and builds the product model.

#### `(:Company)-[:DISTRIBUTES]->(:Product)`
*   **Definition**: Commercial rights.
*   **Usage**: Entity authorized to sell this specific model (Explicit rights).

#### `(:Site)-[:STORES]->(:Product)`
*   **Definition**: Physical inventory holding.
*   **Usage**: Goods are physically located at this site.

#### `(:Equipment)-[:INSTANCE_OF]->(:Product)`
*   **Definition**: Model instantiation.
*   **Usage**: "This specific unit (Equipment) is a T-800 (Product)."

#### `(:Equipment)-[:INSTALLED_AT]->(:Site)`
*   **Definition**: Active location.
*   **Usage**: The machine is currently installed and running at this site.

### Intent & Planning

#### `(:Person)-[:OWNS_OPPORTUNITY]->(:Opportunity)`
*   **Definition**: Sales responsibility.
*   **Usage**: The person actively working the deal.

#### `(:Opportunity)-[:RELATED_TO_COMPANY]->(:Company)`
*   **Definition**: Prospect association.
*   **Usage**: The potential customer for this opportunity.

#### `(:Opportunity)-[:INVOLVES_PRODUCT]->(:Product)`
*   **Definition**: Customer interest.
*   **Usage**: What the customer is interested in buying.

#### `(:Opportunity)-[:CONTRIBUTES_TO]->(:Goal)`
*   **Definition**: Strategic alignment.
*   **Usage**: This deal helps achieve this specific corporate goal.

### Interaction History

#### `(:Person)-[:PARTICIPATED_IN]->(:Event)`
*   **Definition**: Event attendance.
*   **Usage**: Who attended the meeting or webinar?

#### `(:Company)-[:ORGANIZED]->(:Event)`
*   **Definition**: Event hosting.
*   **Usage**: Who hosted or ran the event?

#### `(:Event)-[:DISCUSSED]->(:Product)`
*   **Definition**: Topic focus.
*   **Usage**: What products were discussed?

#### `(:Event)-[:GENERATED]->(:Opportunity)`
*   **Definition**: Pipeline attribution.
*   **Usage**: This interaction directly led to the creation of this deal.

---

## 9. Role Derivation Matrix (The Interpreter)
> **How to translate common business terms into Schema Facts**

| If you see this Business Role... | Look for this Fact Pattern in the Graph |
| :--- | :--- |
| **Customer** | `(Company)-[:PLACED_ORDER]->(Order)` OR `(Company)-[:HAS_RELATIONSHIP]->(:CommercialRelationship {type: 'Service'})` |
| **Prospect** | `(Opportunity)-[:RELATED_TO_COMPANY]->(Company)` (Where Opp is NOT ClosedWon) |
| **Manufacturer** | `(Company)-[:MANUFACTURES]->(Product)` |
| **Distributor** | `(Company)-[:HAS_RELATIONSHIP]->(:CommercialRelationship {type: 'Distributorship'})` |
| **Supplier** | `(Order)-[:SOLD_BY]->(Company)` (Where WE are the buyer) |
| **Inventory** | `(Site)-[:STORES]->(Product)` OR `(:Equipment {status: 'Inventory'})` |
| **Active Franchise** | `(Company)-[:HAS_RELATIONSHIP]->(:CommercialRelationship {type: 'Franchise', status: 'Active'})` |

---
