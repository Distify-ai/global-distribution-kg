# Global Distribution Schema V3 (The Wisdom Graph)

> **Core Philosophy**: We model the **Universal Facts** (what happened) and the **Causal Wisdom** (why it changed).

---

## 1. Organization & Core Entities

### `Company`
- **Description**: 
    - **Trigger**: **Extract** explicit legal or commercial organization names (e.g., "Acme Corp", "DHL") when they act in a business context.
    - **Constraint**: **Discard** functional role labels (e.g., "Supplier", "Customer"); **Map** these to relationships. **Ignore** generic terms (e.g., "The Client").
    - **Ambiguity**: 
        1. **Merge** multiple branches/offices into the parent Company node unless distinct legal/financial separation exists.
        2. **Apply GHOST RULE**: **Generate** a node with `isUnidentified: true` if a company is discussed but unnamed (e.g., "The distributor Alan knows"); **Assign** a descriptive placeholder name.
- **Properties**:
    - `companyId` (UUID)
    - `legalName` (string)
    - `tradeName` (string)
    - `taxId` (string)
    - `website` (url)
    - `description` (string)
    - `status` (enum: Active, Inactive)
    - `country` (string)
    - `region` (string)
    - `city` (string)
    - `stockSymbol` (string)
    - `isUnidentified` (boolean)
    - `contextKey` (string)

### `Person`
- **Description**:
    - **Trigger**: **Extract** named individuals (e.g., "John Doe") with associated contact info or business interaction.
    - **Constraint**: **Discard** temporary role labels (e.g., "Champion", "Influencer") as Person properties. **Ignore** group names (e.g., "Sales Team").
    - **Ambiguity**: **Infer** `roleCategory` from context if job title is missing; **Leave Null** if unknown.
- **Properties**:
    - `personId` (UUID)
    - `fullName` (string)
    - `email` (string)
    - `phone` (string)
    - `jobTitle` (string)
    - `roleCategory` (string)
    - `timezone` (string)
    - `linkedinUrl` (url)

### `Site`
- **Description**:
    - **Trigger**: **Extract** specific physical locations or facility names (e.g., "Warehouse B", "123 Main St").
    - **Constraint**: **Do Not Label** legal entities (Company) as Sites. **Do Not Label** broad regions (e.g., "Europe") as Sites.
    - **Ambiguity**: **Default** to `Office` type if unclear; **Select** `Warehouse` only if storage context exists.
- **Properties**:
    - `siteId` (UUID)
    - `name` (string)
    - `type` (enum: Warehouse, Office, Retail, DataCenter, CustomerSite)
    - `address` (string)
    - `city` (string)
    - `postalCode` (string)
    - `geo` (point)
    - `capacity_sqm` (number)

### `Equipment`
- **Description**:
    - **Trigger**: **Identify** unique physical assets via Serial Number or distinctive Asset Tag (e.g., "Robot #99").
    - **Constraint**: **Do Not Label** abstract models (Product) as Equipment. **Do Not Label** aggregate quantity counts as Equipment.
    - **Ambiguity**: **Generate** a placeholder UUID if serial number is missing but unit distinctness is confirmed.
- **Properties**:
    - `equipmentId` (UUID)
    - `serialNumber` (string)
    - `assetTag` (string)
    - `firmwareVersion` (string)
    - `commissionedAt` (timestamp)
    - `status` (enum: Active, InRepair, Retired, Inventory)

---

## 2. Classification Entities

### `Territory`
- **Description**:
    - **Trigger**: **Extract** named geographic or commercial zones (e.g., "EMEA", "East Coast Sales").
    - **Constraint**: **Do Not Label** specific physical addresses as Territory.
    - **Ambiguity**: **Map** to ISO 3166 codes where possible.
- **Properties**:
    - `territoryId` (UUID)
    - `name` (string)
    - `type` (enum: Country, Region, Continent, SalesZone)
    - `isoCode` (string)

### `Industry`
- **Description**:
    - **Trigger**: **Extract** standard economic activity codes or names (e.g., "Manufacturing", "SaaS").
    - **Constraint**: **Do Not Label** ad-hoc marketing segments (e.g., "Hot Leads") as Industry.
    - **Ambiguity**: **Normalize** to ISIC/NAICS standards if exact industry name varies.
- **Properties**:
    - `industryId` (UUID)
    - `isicCode` (string)
    - `title` (string)

---

## 3. Product Entities

### `Product`
- **Description**:
    - **Trigger**: **Extract** valid selling products (catalog models) traded in the network OR key competitor products explicitly compared against them.
    - **Constraint**: **Do Not Label** individual physical units as Product (use `Equipment`).
    - **Ambiguity**: 
        1. **Map** variations to the base model name (e.g., "The FJD Mower" -> "RM21").
        2. **Significance Threshold**: **Discard** vague mentions (e.g., "a device") UNLESS they are highly recurrent or critical to a deal analysis.
- **Properties**:
    - `productId` (UUID)
    - `modelName` (string)
    - `brand` (string)
    - `nature` (enum: FinishedGood, Component, Kit)
    - `description` (string)

### `SKU`
- **Description**:
    - **Trigger**: **Extract** valid purchasable configuration IDs (e.g., "T-800-EU-PLUG").
    - **Constraint**: **Do Not Label** Engineering Models (Product) or Transaction Lines as SKU.
    - **Ambiguity**: **Keep Static** even if price varies; handle variance in PriceList.
- **Properties**:
    - `sku` (string)
    - `name` (string)
    - `currency` (string)
    - `listPrice` (number)

### `ProductCategory`
- **Description**:
    - **Trigger**: **Extract** taxonomic families (e.g., "Cleaning Robots").
    - **Constraint**: **Do Not Label** temporary sales campaigns as Category.
- **Properties**:
    - `categoryId` (UUID)
    - `name` (string)
    - `description` (string)

---

## 4. Business Commitments (The Ledger)

### `CommercialRelationship`
- **Description**:
    - **Trigger**: **Create** node upon detecting signed agreement docs or explicit status statements (e.g., "We are an Authorized Distributor").
    - **Constraint**: **Do Not Label** tentative opportunities (Prospects) as CommercialRelationship.
    - **Ambiguity**: **Check** `endDate` to determine status if not explicitly stated.
- **Properties**:
    - `relationshipId` (UUID)
    - `type` (enum: Franchise, Partnership, ServiceAgreement, Distributorship)
    - `status` (enum: Active, Expired, Terminated)
    - `startDate` (date)
    - `endDate` (date)

### `Contract`
- **Description**:
    - **Trigger**: **Extract** references to specific legal documents (e.g., "MSA-2024.pdf").
    - **Constraint**: **Do Not Label** verbal agreements as Contract.
- **Properties**:
    - `contractId` (UUID)
    - `referenceNumber` (string)
    - `type` (enum: Distribution, Franchise, Service, NDA)
    - `status` (enum)

### `PriceList`
- **Description**:
    - **Trigger**: **Extract** named pricing policies (e.g., "2025 Tier 1 Pricing").
    - **Constraint**: **Do Not Label** single transaction prices as PriceList.
- **Properties**:
    - `pricelistId` (UUID)
    - `name` (string)
    - `currency` (string)
    - `validFrom` (date)
    - `validTo` (date)

### `Order`
- **Description**:
    - **Trigger**: **Instantiate** when a confirmed PO number or financial commitment is found.
    - **Constraint**: **Do Not Label** unconfirmed Quotes or Estimates as Order.
    - **Ambiguity**: **Set** `status: Confirmed` if explicit status is missing.
- **Properties**:
    - `orderId` (UUID)
    - `orderNumber` (string)
    - `status` (enum: Confirmed, Shipped, Paid, Cancelled)
    - `totalAmount` (number)
    - `currency` (string)

### `OrderLine`
- **Description**:
    - **Trigger**: **Extract** individual line items within an Order context.
    - **Constraint**: **Do Not Label** aggregate totals as OrderLine.
- **Properties**:
    - `quantity` (number)
    - `unitPrice` (number)
    - `total` (number)

---

## 5. Logistics (The Physics)

### `Shipment`
- **Description**:
    - **Trigger**: **Create** when proofs of physical movement (Tracking #, BOL) are detected.
    - **Constraint**: **Do Not Label** financial records (Order) as Shipment.
    - **Ambiguity**: **Set** `status: InTransit` if delivery date is in the future.
- **Properties**:
    - `shipmentId` (UUID)
    - `trackingNumber` (string)
    - `carrier` (string)
    - `status` (enum: Ready, InTransit, CustomsHold, Delivered, Exception)
    - `shippedAt` (timestamp)
    - `estimatedDelivery` (timestamp)
    - `weight_kg` (number)

---

## 6. Business Intent (The Pipeline)

### `Opportunity`
- **Description**:
    - **Trigger**: **Create** for potential deals, leads, or ongoing negotiations.
    - **Constraint**: **Move** to `Order` or `CommercialRelationship` if finding is fully signed/finalized.
    - **Ambiguity**: **Infer** probability from Stage name if `confidence` is missing.
- **Properties**:
    - `opportunityId` (UUID)
    - `name` (string)
    - `stage` (enum: Prospect, Qualified, Proposal, Negotiation, ClosedWon, ClosedLost)
    - `amount` (number)
    - `confidence` (float)
    - `expectedCloseDate` (date)

### `Goal`
- **Description**:
    - **Trigger**: **Extract** strategic target statements (e.g., "Aim to sell 1M in Q4").
    - **Constraint**: **Do Not Label** historical performance numbers as Goal.
- **Properties**:
    - `name` (string)
    - `targetValue` (number)
    - `metric` (string)
    - `timeScope` (string)

### `TimeFrame`
- **Description**:
    - **Trigger**: **Extract** specific operational periods (e.g., "Week 42", "Q4 2025").
    - **Constraint**: **Ignore** vague temporal references (e.g., "Future").
- **Properties**:
    - `name` (string)
    - `startDate` (date)
    - `endDate` (date)

---

## 7. Events (The Wisdom Engine)

### `Event`
- **Description**:
    - **Trigger**: **Record** any point-in-time occurrence (Email, Meeting, Status Change).
    - **Constraint**: **Do Not Label** static node attributes as Events. **Avoid** double-counting if a Transaction node already captures the timestamp.
    - **Ambiguity**: **Always Extract** `triggerReason` if causal context ("Wisdom") is present.
- **Properties**:
    - `eventId` (UUID)
    - `eventCategory` (enum: Interaction, Activity, StateChange, SystemLog)
    - `eventType` (string)
    - `occurredAt` (timestamp)
    - `summary` (string)
    - `source` (string)
    - `resultedInStatusChange` (boolean)
    - `newStatusValue` (string)
    - `triggerReason` (string)

---

## 8. Provenance (Evidence)

### `Source`
- **Description**:
    - **Trigger**: **Identify** the origin document or URI.
    - **Constraint**: **Create Only One** source node per file/URL.
- **Properties**:
    - `sourceId` (UUID)
    - `sourceType` (enum: PDF, Email, Chat, NewsArticle, WebPage)
    - `uri` (string)
    - `ingestedAt` (timestamp)
    - `title` (string)

### `Chunk`
- **Description**:
    - **Trigger**: **Link** specific text block used for extraction.
- **Properties**:
    - `chunkId` (UUID)
    - `text` (string)
    - `confidence` (float)

---

## 9. Universal Fact Relationships (The Verbs)

### Organization & Classification
- `(:Company)-[:SUBSIDIARY_OF]->(:Company)`
    - **Description**: **Connect** a child company to its parent legal entity (strictly for ownership, not partnerships).
- `(:Company)-[:BELONGS_TO_INDUSTRY]->(:Industry)`
    - **Description**: **Link** a company to its primary economic activity classification (e.g., Manufacturing).
- `(:Company)-[:HAS_SITE]->(:Site)`
    - **Description**: **Connect** a company to a physical facility it owns, leases, or operates from.
- `(:Site)-[:LOCATED_IN]->(:Territory)`
    - **Description**: **Map** a physical site address to its broader geographic region or sales territory.
- `(:Company)-[:OPERATES_IN]->(:Territory)`
    - **Description**: **Link** a company to a region where it has a sales presence but no physical site.
- `(:Person)-[:WORKS_FOR]->(:Company)`
    - **Description**: **Link** a person to their payroll employer (distinguishing them from the suppliers they might represent).

### Commercial Structure (The Bridge)
- `(:Company)-[:HAS_RELATIONSHIP]->(:CommercialRelationship)`
    - **Description**: **Connect** a company to the intermediate node that stores the dates and status of a formal partnership.
- `(:CommercialRelationship)-[:DEFINED_BY]->(:Contract)`
    - **Description**: **Link** a partnership node to the specific legal document that governs it.
- `(:CommercialRelationship)-[:RELATIONSHIP_CHANGED]->(:Event)`
    - **Description**: **Connect** a relationship to a timestamped event that altered its status (e.g., Renewal, Termination).

### Transactions (The Money)
- `(:Company)-[:PLACED_ORDER]->(:Order)`
    - **Description**: **Link** the buying entity identified on the Purchase Order to the Order node.
- `(:Order)-[:SOLD_BY]->(:Company)`
    - **Description**: **Link** the Order node to the selling entity receiving the payment.
- `(:Order)-[:CONTAINS_LINE]->(:OrderLine)`
    - **Description**: **Connect** the parent Order to its individual line item breakdown.
- `(:OrderLine)-[:REFERENCES_SKU]->(:SKU)`
    - **Description**: **Link** a transaction line item to the specific commercial SKU code being purchased.
- `(:Contract)-[:BINDS_COMPANY]->(:Company)`
    - **Description**: **Link** a contract document to the parties who signed it.
- `(:Company)-[:OWNS_ASSET]->(:Equipment)`
    - **Description**: **Link** a company to the specific physical equipment unit they hold legal title to.

### Supply Chain & Product Logic
- `(:Company)-[:MANUFACTURES]->(:Product)`
    - **Description**: **Link** a company to the product models they design or build (OEM role).
- `(:Company)-[:DISTRIBUTES]->(:Product)`
    - **Description**: **Link** a company to the product models they are authorized to sell.
- `(:Product)-[:CATEGORIZED_AS]->(:ProductCategory)`
    - **Description**: **Connect** a product model to its taxonomic family (e.g., Cleaning Robots).
- `(:SKU)-[:VARIANT_OF]->(:Product)`
    - **Description**: **Link** a specific purchasable SKU to the abstract engineering Product model it represents.
- `(:Product)-[:COMPOSED_OF]->(:Product)`
    - **Description**: **Connect** a parent product to the child components/parts required to build or repair it (Bill of Materials).
- `(:Product)-[:COMPATIBLE_WITH]->(:Product)`
    - **Description**: **Link** a spare part or accessory to the main product model it fits or works with.

### Physical Inventory & Logistics
- `(:Site)-[:STORES]->(:Product)`
    - **Description**: **Link** a physical location to the product models currently held in inventory there.
- `(:Equipment)-[:INSTANCE_OF]->(:Product)`
    - **Description**: **Connect** a specific serial-numbered unit to its abstract Product model definition.
- `(:Equipment)-[:INSTALLED_AT]->(:Site)`
    - **Description**: **Link** a physical asset to the site where it is currently operating.
- `(:Order)-[:FULFILLED_BY]->(:Shipment)`
    - **Description**: **Connect** a financial Order to the physical Shipment(s) moving the goods.
- `(:Shipment)-[:ORIGINATED_FROM]->(:Site)`
    - **Description**: **Link** a shipment to the warehouse or facility where it started.
- `(:Shipment)-[:DESTINED_FOR]->(:Site)`
    - **Description**: **Link** a shipment to its intended final destination address.
- `(:Shipment)-[:CURRENTLY_LOCATED_AT]->(:Site)`
    - **Description**: **Link** an active shipment to the last facility where it was scanned (for in-transit tracking).
- `(:Shipment)-[:CONTAINS_ASSET]->(:Equipment)`
    - **Description**: **Link** a shipment to the specific serial-numbered units listed on the manifest.
- `(:Shipment)-[:CONTAINS_STOCK]->(:SKU)`
    - **Description**: **Link** a shipment to the quantity of non-serialized SKUs being transported.

### Pricing Logic
- `(:Company)-[:ELIGIBLE_FOR]->(:PriceList)`
    - **Description**: **Link** a company to the specific pricing tier or policy they are assigned to.
- `(:PriceList)-[:PRICES_SKU {amount: Number}]->(:SKU)`
    - **Description**: **Define** the specific price for a SKU within the context of a Price List.

### Intent & Planning
- `(:Person)-[:OWNS_OPPORTUNITY]->(:Opportunity)`
    - **Description**: **Link** a salesperson to the specific deal they are responsible for managing.
- `(:Opportunity)-[:RELATED_TO_COMPANY]->(:Company)`
    - **Description**: **Connect** a potential deal to the prospective customer company.
- `(:Opportunity)-[:INVOLVES_PRODUCT]->(:Product)`
    - **Description**: **Link** an opportunity to the product models the customer is interested in buying.
- `(:Opportunity)-[:CONTRIBUTES_TO]->(:Goal)`
    - **Description**: **Connect** a specific deal to the broader strategic goal it helps achieve.
- `(:TimeFrame)-[:HAS_GOAL]->(:Goal)`
    - **Description**: **Link** a specific time period (e.g., Week 42) to the targets defined for it.
- `(:Goal)-[:ASSIGNED_TO]->(:Person)`
    - **Description**: **Link** a goal to the specific person accountable for hitting the target.

### Interaction History & Wisdom
- `(:Person)-[:PARTICIPATED_IN]->(:Event)`
    - **Description**: **Link** an individual to a meeting, call, or interaction they attended.
- `(:Company)-[:ORGANIZED]->(:Event)`
    - **Description**: **Link** a company to an event they hosted or organized.
- `(:Event)-[:DISCUSSED]->(:Product)`
    - **Description**: **Link** an interaction to the product model that was a topic of conversation.
- `(:Event)-[:DISCUSSED]->(:Company)`
    - **Description**: **Link** an interaction to a company discussed during the event (crucial for linking Ghost Nodes).
- `(:Event)-[:GENERATED]->(:Opportunity)`
    - **Description**: **Link** an interaction to the new deal or lead that resulted from it.
- `(:Event)-[:CHANGED_STATUS_OF]->(:Entity)`
    - **Description**: **Connect** a causal event (the Trigger) to the entity (Order, Shipment, Opportunity) whose status changed because of it.

### Provenance (Evidence)
- `(:AnyNode)-[:EVIDENCED_BY]->(:Source)`
    - **Description**: **Link** every extracted node or fact back to the original document or URI for auditability.
