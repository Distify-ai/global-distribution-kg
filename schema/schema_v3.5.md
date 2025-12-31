# Global Distribution Schema V3.5 (Strategy & Hubs)

> **Core Philosophy**: The Graph is divided into **Layer 1: Universal Facts** (The immutable reality of "What Exists") and **Layer 2: Organizing Principles** (The strategic interpretation of "Why it matters").

---

# PART I: UNIVERSAL FACTS (Instance Data)
*Entities that exist physically, legally, or financially, independent of our opinion.*

## 1. Organization (The Players)

### `Company`
- **Description**: Represents explicit legal or commercial organizations acting in a business context.
- **Properties**: `companyId` (UUID), `legalName`, `tradeName`, `taxId`, `website`, `status` (Active, Inactive), `country`, `isUnidentified`, `contextKey`.

### `Person`
- **Description**: Represents named individuals with associated contact information.
- **Properties**: `personId` (UUID), `fullName`, `email`, `phone`, `jobTitle`, `roleCategory`, `linkedinUrl`.

### `Site`
- **Description**: Represents specific physical locations, facilities, or addresses.
- **Properties**: `siteId` (UUID), `name`, `type` (Warehouse, Office, Retail), `address`, `city`, `geo` (point), `capacity_sqm`.

### `Equipment`
- **Description**: Represents unique, serialized physical assets or machines.
- **Properties**: `equipmentId` (UUID), `serialNumber`, `assetTag`, `firmwareVersion`, `status` (Active, InRepair, Retired).

## 2. The Ledger (Transactions & Commitments)

### `CommercialRelationship`
- **Description**: Represents the formal, time-bound agreement status between two companies.
- **Properties**: `relationshipId` (UUID), `type` (Franchise, Distributor), `status` (Active, Expired), `startDate`, `endDate`.

### `Contract`
- **Description**: Represents a specific, signed legal document.
- **Properties**: `contractId` (UUID), `referenceNumber`, `type` (Distribution, NDA), `status`.

### `Order`
- **Description**: Represents a confirmed financial commitment (PO) for goods/services.
- **Properties**: `orderId` (UUID), `orderNumber`, `status` (Confirmed, Shipped, Paid), `totalAmount`, `currency`.

### `OrderLine`
- **Description**: Represents an individual line item in an Order.
- **Properties**: `quantity`, `unitPrice`, `total`.

## 3. The Catalog (Engineering & Stock)

### `Product`
- **Description**: Represents the abstract catalog model or engineering definition.
- **Properties**: `productId` (UUID), `modelName`, `brand`, `nature` (FinishedGood, Component), `description`.

### `SKU`
- **Description**: Represents a specific purchasable configuration with a price point.
- **Properties**: `sku` (string), `name`, `currency`, `listPrice`.

## 4. Logistics (The Physics)

### `Shipment`
- **Description**: Represents a physical movement of goods (Tracking # / BOL).
- **Properties**: `shipmentId` (UUID), `trackingNumber`, `carrier`, `status` (InTransit, Delivered), `shippedAt`, `estimatedDelivery`, `weight_kg`.

## 5. Provenance (The Evidence)

### `Source`
- **Description**: Represents the original document/file from which data was extracted.
- **Properties**: `sourceId` (UUID), `sourceType` (PDF, Email, WebPage), `uri`, `ingestedAt`.

### `Chunk`
- **Description**: Represents the specific text segment evidencing a fact.
- **Properties**: `chunkId` (UUID), `text` (string), `confidence` (float).

---

# PART II: ORGANIZING PRINCIPLES (Insights & Strategy)
*Concepts we impose on the data to create meaning, strategy, and narrative.*

## 6. Business Interactions (The Pipeline)

### `Activity`
- **Description**: Represents actual interaction or work done (energy spent).
- **Properties**: `activityId` (UUID), `type` (Meeting, Call, Email), `summary`, `occurredAt`, `durationMinutes`, `outcome`.

### `Progress`
- **Description**: Represents a discrete step, update, or change in state relevant to business goals (includes Milestones, Blockers, and Market Context).
- **Properties**: `progressId` (UUID), `summary`, `type` (Milestone, Blocker, MarketNews, Regulatory, Funding), `sentiment` (Positive, Negative, Neutral), `occurredAt`, `source` (Internal, External, URL).

### `Opportunity`
- **Description**: Represents a potential deal or ongoing negotiation.
- **Properties**: `opportunityId` (UUID), `name`, `stage` (Prospect, Negotiation, ClosedWon), `amount`, `confidence`, `expectedCloseDate`.

## 7. Strategy (The Direction)

### `Goal`
- **Description**: Represents a specific, measurable objective for a company or person.
- **Properties**: `goalId` (UUID), `name`, `status` (Achieved, NotAchieved), `deadline`.

### `Plan`
- **Description**: Represents a strategic roadmap or action plan document.
- **Properties**: `planId` (UUID), `name`, `status` (Ongoing, Finished, Abandoned), `url`.

## 8. Taxonomy & Policy (The Lens)

### `Territory`
- **Description**: Represents a defined geographic region or sales zone.
- **Properties**: `territoryId` (UUID), `name`, `type` (Region, SalesZone), `isoCode`.

### `Industry`
- **Description**: Represents economic activity classifications.
- **Properties**: `industryId` (UUID), `isicCode`, `title`.

### `ProductCategory`
- **Description**: Represents a taxonomic family for products.
- **Properties**: `categoryId` (UUID), `name`, `description`.

### `PriceList`
- **Description**: Represents a named set of pricing policies.
- **Properties**: `pricelistId` (UUID), `name`, `currency`, `validFrom`, `validTo`.

---

# PART III: RELATIONSHIPS

## 9. Universal Fact Relationships (Instance Links)

### Organization & Logistics
- `(:Company)-[:SUBSIDIARY_OF]->(:Company)`
    - **Description**: Connects a child company to its parent legal entity for ownership context.
- `(:Company)-[:HAS_SITE]->(:Site)`
    - **Description**: Connects a company to a physical facility it owns, leases, or operates.
- `(:Person)-[:WORKS_FOR]->(:Company)`
    - **Description**: Links a person to their payroll employer.
- `(:Company)-[:OWNS_ASSET]->(:Equipment)`
    - **Description**: Links a company to the physical equipment they own.
- `(:Equipment)-[:INSTALLED_AT]->(:Site)`
    - **Description**: Links a physical asset to its operating location.
- `(:Equipment)-[:INSTANCE_OF]->(:Product)`
    - **Description**: Connects a specific unit to its abstract Product model.

### Commerce & Supply Chain
- `(:Company)-[:MANUFACTURES]->(:Product)`
    - **Description**: Links a company to the product models they design or build.
- `(:Company)-[:DISTRIBUTES]->(:Product)`
    - **Description**: Links a company to the product models they are authorized to sell.
- `(:Company)-[:HAS_RELATIONSHIP]->(:CommercialRelationship)`
    - **Description**: Connects a company to the intermediate node storing the partnership status.
- `(:CommercialRelationship)-[:DEFINED_BY]->(:Contract)`
    - **Description**: Links a partnership node to the governing legal document.
- `(:Contract)-[:BINDS_COMPANY]->(:Company)`
    - **Description**: Links a contract document to the signing parties.
- `(:Company)-[:PLACED_ORDER]->(:Order)`
    - **Description**: Links the buying entity to the Order node.
- `(:Order)-[:SOLD_BY]->(:Company)`
    - **Description**: Links the Order node to the selling entity.
- `(:Order)-[:CONTAINS_LINE]->(:OrderLine)`
    - **Description**: Connects the parent Order to its individual line items.
- `(:OrderLine)-[:REFERENCES_SKU]->(:SKU)`
    - **Description**: Links a line item to the specific commercial SKU being purchased.
- `(:SKU)-[:VARIANT_OF]->(:Product)`
    - **Description**: Links a purchasable SKU to its abstract engineering Product model.

### Shipment Flow
- `(:Order)-[:FULFILLED_BY]->(:Shipment)`
    - **Description**: Connects an Order to the Shipment moving the goods.
- `(:Shipment)-[:ORIGINATED_FROM]->(:Site)`
    - **Description**: Links a shipment to its starting facility.
- `(:Shipment)-[:DESTINED_FOR]->(:Site)`
    - **Description**: Links a shipment to its destination.
- `(:Shipment)-[:CONTAINS_ASSET]->(:Equipment)`
    - **Description**: Links a shipment to the specific units inside it.

### Provenance
- `(:AnyNode)-[:EVIDENCED_BY]->(:Source)`
    - **Description**: Links any node to its original source document.

## 10. Organizing Principle Relationships (Insight Links)

### The Wisdom Chain (Narrative)
- `(:Progress)-[:TRIGGERED]->(:Activity)`
    - **Description**: Links external news (MarketSignal) to the outreach or action it inspired.
- `(:Person)-[:PERFORMED]->(:Activity)`
    - **Description**: Links a key stakeholder to the work they did.
- `(:Activity)-[:TARGETED]->(:Company)`
    - **Description**: Connects an activity to the account it was for.
- `(:Activity)-[:TARGETED]->(:Opportunity)`
    - **Description**: Connects an activity to the specific deal it supports.
- `(:Activity)-[:YIELDED]->(:Progress)`
    - **Description**: Links work done to the tangible progress or outcome (Milestone/Blocker).
- `(:Activity)-[:ENCOUNTERED]->(:Progress)`
    - **Description**: Links work done to the friction or hurdle discovered (Blocker).
- `(:Activity)-[:RESOLVES]->(:Progress)`
    - **Description**: Links work done to the removal of a previous blocker.
- `(:Progress)-[:STALLS]->(:Opportunity)`
    - **Description**: Explicitly links a specific problem (Blocker) to the frozen deal status.
- `(:CommercialRelationship)-[:RELATIONSHIP_CHANGED]->(:Activity)` 
    - **Description**: Connects a relationship to an activity that altered its status.

### Pipeline & Strategy
- `(:Person)-[:OWNS_OPPORTUNITY]->(:Opportunity)`
    - **Description**: Links a salesperson to the deal they manage.
- `(:Opportunity)-[:RELATED_TO_COMPANY]->(:Company)`
    - **Description**: Connects a potential deal to the prospective customer.
- `(:Opportunity)-[:INVOLVES_PRODUCT]->(:Product)`
    - **Description**: Links an opportunity to the relevant product models.
- `(:Opportunity)-[:CONTRIBUTES_TO]->(:Goal)`
    - **Description**: Connects a deal to the strategic goal it supports.
- `(:Goal)-[:ASSIGNED_TO]->(:Person)`
    - **Description**: Links a goal to the accountable person.
- `(:Goal)-[:ASSIGNED_TO]->(:Company)`
    - **Description**: Links a goal to the performance of a local hub company.
- `(:Goal)-[:DECOMPOSES_INTO]->(:Goal)`
    - **Description**: Links a high-level goal to its breakdown component goals.
- `(:Plan)-[:TARGETS]->(:Goal)`
    - **Description**: Links a strategic plan to the goal it aims to achieve.
- `(:Plan)-[:LINKED_TO]->(:Plan)`
    - **Description**: Connects related plans or roadmaps.
- `(:TimeFrame)-[:HAS_GOAL]->(:Goal)`
    - **Description**: Links a time period to its defined targets.

### Classification & Policy
- `(:Company)-[:BELONGS_TO_INDUSTRY]->(:Industry)`
    - **Description**: Links a company to its primary economic activity classification.
- `(:Site)-[:LOCATED_IN]->(:Territory)`
    - **Description**: Maps a physical site address to its broader geographic region or sales territory.
- `(:Company)-[:OPERATES_IN]->(:Territory)`
    - **Description**: Links a company to a region where it has a sales presence but no physical site.
- `(:Product)-[:CATEGORIZED_AS]->(:ProductCategory)`
    - **Description**: Connects a product model to its taxonomic family.
- `(:Company)-[:ELIGIBLE_FOR]->(:PriceList)`
    - **Description**: Links a company to its assigned pricing policy.
- `(:PriceList)-[:PRICES_SKU {amount: Number}]->(:SKU)`
    - **Description**: Defines the price for a SKU within a specific Price List.
