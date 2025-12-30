# Global Distribution Schema V3 (The Wisdom Graph)

> **Core Philosophy**: We model the **Universal Facts** (what happened) and the **Causal Wisdom** (why it changed).

---

## 1. Organization & Core Entities

### `Company`
- **Description**: Represents explicit legal or commercial organizations acting in a business context, distinct from their functional roles.
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
- **Description**: Represents named individuals with associated contact information or recurring business interactions.
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
- **Description**: Represents specific physical locations, facilities, or addresses where business operations or storage occur.
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
- **Description**: Represents unique, serialized physical assets or machines, distinct from the abstract product model.
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
- **Description**: Represents a defined geographic region or commercial sales zone used for organizational inputs.
- **Properties**:
    - `territoryId` (UUID)
    - `name` (string)
    - `type` (enum: Country, Region, Continent, SalesZone)
    - `isoCode` (string)

### `Industry`
- **Description**: Represents standard economic activity classifications or market segments.
- **Properties**:
    - `industryId` (UUID)
    - `isicCode` (string)
    - `title` (string)

---

## 3. Product Entities

### `Product`
- **Description**: Represents the abstract catalog model or engineering definition of an item, distinct from individual physical units.
- **Properties**:
    - `productId` (UUID)
    - `modelName` (string)
    - `brand` (string)
    - `nature` (enum: FinishedGood, Component, Kit)
    - `description` (string)

### `SKU`
- **Description**: Represents a specific purchasable configuration or stock keeping unit with a defined price point.
- **Properties**:
    - `sku` (string)
    - `name` (string)
    - `currency` (string)
    - `listPrice` (number)

### `ProductCategory`
- **Description**: Represents a taxonomic family or classification group for products.
- **Properties**:
    - `categoryId` (UUID)
    - `name` (string)
    - `description` (string)

---

## 4. Business Commitments (The Ledger)

### `CommercialRelationship`
- **Description**: Represents the formal, time-bound agreement status between two companies.
- **Properties**:
    - `relationshipId` (UUID)
    - `type` (enum: Franchise, Partnership, ServiceAgreement, Distributorship)
    - `status` (enum: Active, Expired, Terminated)
    - `startDate` (date)
    - `endDate` (date)

### `Contract`
- **Description**: Represents a specific, signed legal document that governs a commercial relationship or transaction.
- **Properties**:
    - `contractId` (UUID)
    - `referenceNumber` (string)
    - `type` (enum: Distribution, Franchise, Service, NDA)
    - `status` (enum)

### `PriceList`
- **Description**: Represents a named set of pricing policies, currencies, and validity dates applicable to specific partners.
- **Properties**:
    - `pricelistId` (UUID)
    - `name` (string)
    - `currency` (string)
    - `validFrom` (date)
    - `validTo` (date)

### `Order`
- **Description**: Represents a confirmed financial commitment or Purchase Order for goods or services.
- **Properties**:
    - `orderId` (UUID)
    - `orderNumber` (string)
    - `status` (enum: Confirmed, Shipped, Paid, Cancelled)
    - `totalAmount` (number)
    - `currency` (string)

### `OrderLine`
- **Description**: Represents an individual line item specifying quantity and price within a larger Order.
- **Properties**:
    - `quantity` (number)
    - `unitPrice` (number)
    - `total` (number)

---

## 5. Logistics (The Physics)

### `Shipment`
- **Description**: Represents a physical movement of goods identified by tracking numbers or bills of lading.
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
- **Description**: Represents a potential deal, lead, or ongoing negotiation that has not yet been finalized.
- **Properties**:
    - `opportunityId` (UUID)
    - `name` (string)
    - `stage` (enum: Prospect, Qualified, Proposal, Negotiation, ClosedWon, ClosedLost)
    - `amount` (number)
    - `confidence` (float)
    - `expectedCloseDate` (date)

### `Goal`
- **Description**: Represents a specific, measurable strategic target or objective assigned to a person or time period.
- **Properties**:
    - `name` (string)
    - `targetValue` (number)
    - `metric` (string)
    - `timeScope` (string)

### `TimeFrame`
- **Description**: Represents a specific operational period such as a week, quarter, or year used for planning.
- **Properties**:
    - `name` (string)
    - `startDate` (date)
    - `endDate` (date)

---

## 7. Events (The Wisdom Engine)

### `Event`
- **Description**: Represents any point-in-time occurrence, interaction, or state change that provides causal context.
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
- **Description**: Represents the original document, file, or URI from which data was extracted.
- **Properties**:
    - `sourceId` (UUID)
    - `sourceType` (enum: PDF, Email, Chat, NewsArticle, WebPage)
    - `uri` (string)
    - `ingestedAt` (timestamp)
    - `title` (string)

### `Chunk`
- **Description**: Represents the specific text block or segment within a source that evidenced a fact.
- **Properties**:
    - `chunkId` (UUID)
    - `text` (string)
    - `confidence` (float)

---

## 9. Universal Fact Relationships (The Verbs)

### Organization & Classification
- `(:Company)-[:SUBSIDIARY_OF]->(:Company)`
    - **Description**: Connects a child company to its parent legal entity for ownership context.
- `(:Company)-[:BELONGS_TO_INDUSTRY]->(:Industry)`
    - **Description**: Links a company to its primary economic activity classification.
- `(:Company)-[:HAS_SITE]->(:Site)`
    - **Description**: Connects a company to a physical facility it owns, leases, or operates.
- `(:Site)-[:LOCATED_IN]->(:Territory)`
    - **Description**: Maps a physical site address to its broader geographic region or sales territory.
- `(:Company)-[:OPERATES_IN]->(:Territory)`
    - **Description**: Links a company to a region where it has a sales presence but no physical site.
- `(:Person)-[:WORKS_FOR]->(:Company)`
    - **Description**: Links a person to their payroll employer.

### Commercial Structure (The Bridge)
- `(:Company)-[:HAS_RELATIONSHIP]->(:CommercialRelationship)`
    - **Description**: Connects a company to the intermediate node storing the partnership status.
- `(:CommercialRelationship)-[:DEFINED_BY]->(:Contract)`
    - **Description**: Links a partnership node to the governing legal document.
- `(:CommercialRelationship)-[:RELATIONSHIP_CHANGED]->(:Event)`
    - **Description**: Connects a relationship to a timestamped event that altered its status.

### Transactions (The Money)
- `(:Company)-[:PLACED_ORDER]->(:Order)`
    - **Description**: Links the buying entity to the Order node.
- `(:Order)-[:SOLD_BY]->(:Company)`
    - **Description**: Links the Order node to the selling entity.
- `(:Order)-[:CONTAINS_LINE]->(:OrderLine)`
    - **Description**: Connects the parent Order to its individual line items.
- `(:OrderLine)-[:REFERENCES_SKU]->(:SKU)`
    - **Description**: Links a line item to the specific commercial SKU being purchased.
- `(:Contract)-[:BINDS_COMPANY]->(:Company)`
    - **Description**: Links a contract document to the signing parties.
- `(:Company)-[:OWNS_ASSET]->(:Equipment)`
    - **Description**: Links a company to the physical equipment they own.

### Supply Chain & Product Logic
- `(:Company)-[:MANUFACTURES]->(:Product)`
    - **Description**: Links a company to the product models they design or build.
- `(:Company)-[:DISTRIBUTES]->(:Product)`
    - **Description**: Links a company to the product models they are authorized to sell.
- `(:Product)-[:CATEGORIZED_AS]->(:ProductCategory)`
    - **Description**: Connects a product model to its taxonomic family.
- `(:SKU)-[:VARIANT_OF]->(:Product)`
    - **Description**: Links a purchasable SKU to its abstract engineering Product model.
- `(:Product)-[:COMPOSED_OF]->(:Product)`
    - **Description**: Connects a parent product to its child components or parts.
- `(:Product)-[:COMPATIBLE_WITH]->(:Product)`
    - **Description**: Links a spare part or accessory to the main product model it works with.

### Physical Inventory & Logistics
- `(:Site)-[:STORES]->(:Product)`
    - **Description**: Links a physical location to the product models held in inventory there.
- `(:Equipment)-[:INSTANCE_OF]->(:Product)`
    - **Description**: Connects a specific unit to its abstract Product model.
- `(:Equipment)-[:INSTALLED_AT]->(:Site)`
    - **Description**: Links a physical asset to its operating location.
- `(:Order)-[:FULFILLED_BY]->(:Shipment)`
    - **Description**: Connects an Order to the Shipment moving the goods.
- `(:Shipment)-[:ORIGINATED_FROM]->(:Site)`
    - **Description**: Links a shipment to its starting facility.
- `(:Shipment)-[:DESTINED_FOR]->(:Site)`
    - **Description**: Links a shipment to its destination.
- `(:Shipment)-[:CURRENTLY_LOCATED_AT]->(:Site)`
    - **Description**: Links an active shipment to its last scanned location.
- `(:Shipment)-[:CONTAINS_ASSET]->(:Equipment)`
    - **Description**: Links a shipment to the specific units inside it.
- `(:Shipment)-[:CONTAINS_STOCK]->(:SKU)`
    - **Description**: Links a shipment to the quantity of SKUs being transported.

### Pricing Logic
- `(:Company)-[:ELIGIBLE_FOR]->(:PriceList)`
    - **Description**: Links a company to its assigned pricing policy.
- `(:PriceList)-[:PRICES_SKU {amount: Number}]->(:SKU)`
    - **Description**: Defines the price for a SKU within a specific Price List.

### Intent & Planning
- `(:Person)-[:OWNS_OPPORTUNITY]->(:Opportunity)`
    - **Description**: Links a salesperson to the deal they manage.
- `(:Opportunity)-[:RELATED_TO_COMPANY]->(:Company)`
    - **Description**: Connects a potential deal to the prospective customer.
- `(:Opportunity)-[:INVOLVES_PRODUCT]->(:Product)`
    - **Description**: Links an opportunity to the relevant product models.
- `(:Opportunity)-[:CONTRIBUTES_TO]->(:Goal)`
    - **Description**: Connects a deal to the strategic goal it supports.
- `(:TimeFrame)-[:HAS_GOAL]->(:Goal)`
    - **Description**: Links a time period to its defined targets.
- `(:Goal)-[:ASSIGNED_TO]->(:Person)`
    - **Description**: Links a goal to the accountable person.

### Interaction History & Wisdom
- `(:Person)-[:PARTICIPATED_IN]->(:Event)`
    - **Description**: Links an individual to an interaction they attended.
- `(:Company)-[:ORGANIZED]->(:Event)`
    - **Description**: Links a company to an event they hosted.
- `(:Event)-[:DISCUSSED]->(:Product)`
    - **Description**: Links an interaction to the product discussed.
- `(:Event)-[:DISCUSSED]->(:Company)`
    - **Description**: Links an interaction to a company discussed.
- `(:Event)-[:GENERATED]->(:Opportunity)`
    - **Description**: Links an interaction to a resulting deal or lead.
- `(:Event)-[:CHANGED_STATUS_OF]->(:Entity)`
    - **Description**: Connects a causal event to the entity whose status changed.

### Provenance (Evidence)
- `(:AnyNode)-[:EVIDENCED_BY]->(:Source)`
    - **Description**: Links any node to its original source document.
