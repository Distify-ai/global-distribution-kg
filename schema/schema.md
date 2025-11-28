# Global Distribution Schema

# Organization Entities

## `Company`

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

## `Customer`

Company that purchases products/services. Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

## `GlobalDistributor`

The central entity representing the global distributor and franchisor. Used to anchor internal employees and direct relationships. Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

## `Prospect`

Potential customer in sales pipeline. Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

## `Manufacturer`

OEM that produces robots/equipment. Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

## `Vendor`

Company we purchase from (products, parts, services). Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

## `Franchisee`

Franchisee operating under the global brand. Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

## `Distributor`

Company that distributes products to market. Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

## `Partner`

Strategic partner (channel, integration, referral). Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

## `ServiceProvider`

Company providing services (logistics, maintenance). Used as additional label on `Company` nodes.
_Shares all properties with `Company`._

## `Competitor`

Company that competes in the ecosystem. Can be:

1.  **Direct Competitor**: Another distributor competing with the Global Distributor.
2.  **Manufacturer Competitor**: An OEM competing with our partner OEMs.
    _Shares all properties with `Company`._

## `Person`

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

### Specialized Labels (applied to Person nodes)

-   **`Technician`**: Field service professional qualified to install, repair, or maintain equipment.
    -   **Suggested Properties**: `skills` (array), `certifications` (array), `serviceArea` (string), `availabilityStatus` (string)

## `Site`

Physical location such as customer site, franchise hub, warehouse, or repair center.

**Suggested Properties:**

-   `siteId` (string, UUID)
-   `name` (string)
-   `siteType` (string) - CustomerSite, FranchiseHub, Warehouse, RepairCenter
-   `addressLine1`, `addressLine2` (string)
-   `city`, `region`, `country`, `postalCode` (string)
-   `location` (point) - lat/lon for proximity queries
-   `sqmSize` (number)

# Classification Entities

## `Territory`

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

## `Industry`

Vertical industry classification using ISIC Rev 5 standard. Industries are organized in a hierarchy:

-   **Section**: 1 letter (e.g., "A - Agriculture, forestry and fishing")
-   **Division**: 2 digits (e.g., "01 - Crop and animal production...")
-   **Group**: 3 digits (e.g., "011 - Growing of non-perennial crops")
-   **Class**: 4 digits (e.g., "0111 - Growing of cereals...")

**Reference**: See `resources/ISIC_Rev_5.csv`

**Suggested Properties:**

-   `industryId` (string, UUID)
-   `isicCode` (string) - Section (letter), Division (2-digit), Group (3-digit), or Class (4-digit) code
-   `isicTitle` (string) - official ISIC title
-   `level` (string) - hierarchy level: "Section", "Division", "Group", "Class"
-   `customName` (string) - optional local/market name
-   `aliases` (array) - alternative names

# Product & Asset Entities

## `ProductCategory`

Product taxonomy category for organizing products in hierarchies.

**Suggested Properties:**

-   `categoryId` (string, UUID)
-   `name` (string)
-   `level` (integer) - hierarchy level (1, 2, 3...)
-   `description` (string)

## `Product`

Product model or family (e.g., "S100 Pro M Scrubber").

**Suggested Properties:**

-   `productId` (string, UUID)
-   `name` (string)
-   `brand` (string)
-   `modelNumber` (string)
-   `description` (string)
-   `lifecycleStage` (string) - Alpha, Beta, GA, EOL

## `Equipment`

Specific physical equipment instance with unique serial number (formerly RobotUnit).

**Suggested Properties:**

-   `equipmentId` (string, UUID)
-   `serialNumber` (string)
-   `commissionedAt` (timestamp)
-   `status` (string) - Active, PendingInstall, InRepair, Retired
-   `firmwareVersion` (string)

## `Part`

Parts, components, consumables, or accessories.

**Suggested Properties:**

-   `partId` (string, UUID)
-   `partNumber` (string)
-   `name` (string)
-   `partType` (string) - component, spare, consumable, accessory
-   `description` (string)
-   `category` (string) - infrastructure, mechanical, electrical, chemical

# Commercial Lifecycle Entities

## `Opportunity`

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

## `Order`

Confirmed sales order.

**Suggested Properties:**

-   `orderId` (string, UUID)
-   `orderDate` (date)
-   `status` (string) - Draft, Confirmed, Shipped, Completed, Cancelled
-   `currency` (string)
-   `totalNet`, `totalTax`, `totalGross` (number)

## `OrderLine`

Line item within an order.

**Suggested Properties:**

-   `orderLineId` (string, UUID)
-   `quantity` (number)
-   `unitPrice` (number)
-   `discount` (number)
-   `lineTotal` (number)
-   `lineType` (string) - Product, Service, Subscription

## `Contract`

Legal agreement (Franchise, OEM, Service, Subscription).

**Suggested Properties:**

-   `contractId` (string, UUID)
-   `type` (string) - Franchise, OEM, Service, Subscription
-   `startDate`, `endDate` (date)
-   `autoRenew` (boolean)
-   `status` (string) - Active, Expired, Terminated
-   `slaLevel` (string) - 1-Day, 4-Hours, NBD

# Knowledge & Document Entities

## `Document`

Logical document (PDF, webpage, email, manual, playbook, online article, etc.).

**Suggested Properties:**

-   `documentId` (string, UUID)
-   `sourceType` (string) - OEM_Manual, Franchise_Playbook, Email, Support_Article, CompanyNews, PressRelease, BlogPost, SocialMedia, WebPage, ResearchReport, VideoTranscript
-   `title` (string)
-   `uri` (string) - GDrive, S3, Notion link, or web URL
-   `mimeType` (string)
-   `createdAt` (timestamp) - when document was ingested/discovered
-   `publishedDate` (date) - when content was originally published
-   `author` (string) - author or publisher name
-   `sentiment` (string) - Positive, Negative, Neutral
-   `relevanceScore` (float) - 0.0-1.0

## `Chunk`

Text chunk extracted from document for RAG retrieval.

**Suggested Properties:**

-   `chunkId` (string, UUID)
-   `text` (string)
-   `embedding` (vector)
-   `position` (integer) - page/paragraph index

## `Tag`

Flexible label for concepts, topics, or potential entities not yet strictly defined.

**Suggested Properties:**

-   `tagId` (string, UUID)
-   `name` (string) - normalized snake_case
-   `category` (string) - optional grouping

**Constraints:**

-   **Use for potential future entities**: Capture concepts that seem important but don't have a schema definition yet.
-   **Link to source**: Always link tags to the Document or Chunk where they were found.
-   **Avoid high cardinality**: Do NOT tag unique values like specific dates, IDs, or sentence fragments.
-   **Not unlimited**: Only create tags for concepts that appear to have reusability or analytical value.

# Engagement Entities

## `Interaction`

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

## `Task`

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

## `Goal`

Business objective to track progress against.

**Suggested Properties:**

-   `goalId` (string, UUID)
-   `name` (string) - e.g., "Close 10 deals in Q1"
-   `type` (string) - Sales, Onboarding, Revenue, Expansion
-   `targetValue` (number)
-   `currentValue` (number)
-   `startDate`, `endDate` (date)
-   `status` (string) - Active, Achieved, Missed, Cancelled

# Relationships

## Identity & Organization

### Company

-   `(Company)-[:HAS_SITE]->(Site)`
-   `(Company)-[:IN_INDUSTRY]->(Industry)`
-   `(Company)-[:HAS_CONTRACT]->(Contract)`
-   `(Company)-[:PLACED_ORDER]->(Order)`
-   `(Company)-[:HAS_OPPORTUNITY]->(Opportunity)`
-   `(Company)-[:HAS_INTERACTION]->(Interaction)`
-   `(Company)-[:TAGGED_WITH]->(Tag)`

### Company-to-Company

-   `(Company)-[:SELLS_TO {products, since}]->(Company)`
-   `(Company)-[:SUPPLIES {materialType, since}]->(Company)`
-   `(Company)-[:PARTNERS_WITH {type, since}]->(Company)`
-   `(Company)-[:FRANCHISES {territory, contractId}]->(Company)`
-   `(Company)-[:SERVICES {serviceType}]->(Company)`
-   `(Company)-[:PARENT_COMPANY_OF]->(Company)`
-   `(Company)-[:SUBSIDIARY_OF]->(Company)`
-   `(Company)-[:COMPETES_WITH {strength, market}]->(Company)`
-   `(Company)-[:MAINTAINS]->(Site)` - ServiceProvider maintains a site

### Specialized Company Roles

-   `(Company:Manufacturer)-[:MANUFACTURES {since}]->(Product)`
-   `(Company:Distributor)-[:DISTRIBUTES {territory, since}]->(Product)`
-   `(Company:Franchisee)-[:SELLS {authorizedDate, status}]->(Product)`
-   `(Company:Franchisee)-[:COVERS {startDate, endDate, exclusivityLevel}]->(Territory)`
-   `(Company:Customer)-[:OWNS {purchaseDate, purchasePrice, warrantyEndDate}]->(Equipment)`
-   `(Company:Competitor)-[:COMPETES_ON {status, strength, notes}]->(Opportunity)`

### Person

-   `(Person)-[:WORKS_FOR {startDate, endDate, role, department}]->(Company)`
-   `(Person)-[:REPRESENTS {isPrimary, role}]->(Company)`
-   `(Person)-[:HAS_ROLE_IN {role}]->(Opportunity)`
-   `(Person)-[:HAS_ROLE_IN {role}]->(Opportunity)`
-   `(Person)-[:PARTICIPATED_IN {role}]->(Interaction)`
-   `(Person:Technician)-[:MAINTAINS]->(Equipment)`

### Territory

-   `(Territory)-[:PART_OF]->(Territory)`

## Product & Assets

### Product

-   `(ProductCategory)-[:SUBCATEGORY_OF]->(ProductCategory)`
-   `(Product)-[:IN_CATEGORY]->(ProductCategory)`
-   `(Product)-[:REQUIRES_COMPONENT]->(Part)`
-   `(Product)-[:COMPATIBLE_WITH {source, confidence}]->(Part)`
-   `(Product)-[:USES_CONSUMABLE {replacementFrequency}]->(Part)`
-   `(Product)-[:HAS_SPARE]->(Part)`
-   `(Product)-[:COMPETES_WITH]->(Product)`

### Equipment

-   `(Equipment)-[:OF_MODEL]->(Product)`
-   `(Equipment)-[:INSTALLED_AT {installDate, commissionedBy}]->(Site)`
-   `(Equipment)-[:INSTALLED_AT {installDate, commissionedBy}]->(Site)`
-   `(Equipment)-[:OWNED_BY {purchaseDate, purchasePrice, warrantyEndDate}]->(Company)`
-   `(Equipment)-[:MAINTAINED_BY]->(Person:Technician)`

## Commercial Lifecycle

### Order & Contract

-   `(Order)-[:HAS_LINE]->(OrderLine)`
-   `(Order)-[:SOLD_BY]->(Company)`
-   `(Order)-[:SHIPPED_TO]->(Site)`
-   `(OrderLine)-[:OF_PRODUCT]->(Product)`
-   `(Contract)-[:WITH]->(Company)`

## Knowledge & Documents

### Document & Chunk

-   `(Document)-[:ABOUT_PRODUCT]->(Product)`
-   `(Document)-[:ABOUT_COMPANY]->(Company)`
-   `(Document)-[:DISCOVERED_BY]->(Person)`
-   `(Document)-[:TAGGED_WITH]->(Tag)`
-   `(Chunk)-[:PART_OF]->(Document)`
-   `(Chunk)-[:MENTIONS_COMPANY]->(Company)`
-   `(Chunk)-[:MENTIONS_PRODUCT]->(Product)`
-   `(Chunk)-[:MENTIONS_EQUIPMENT]->(Equipment)`
-   `(Chunk)-[:TAGGED_WITH]->(Tag)`

## Engagement

### Interaction & Task

-   `(Interaction)-[:RELATED_TO]->(Opportunity)`
-   `(Interaction)-[:HAPPENED_AT]->(Site)`
-   `(Interaction)-[:CONCERNS]->(Company)`
-   `(Interaction)-[:CONCERNS]->(Product)`
-   `(Interaction)-[:CREATED_BY]->(Person)`
-   `(Task)-[:ASSIGNED_TO]->(Person)`
-   `(Task)-[:RELATED_TO_OPPORTUNITY]->(Opportunity)`
-   `(Task)-[:RELATED_TO_COMPANY]->(Company)`
-   `(Task)-[:PART_OF_GOAL]->(Goal)`

### Goal

-   `(Goal)-[:OWNED_BY]->(Person)`
-   `(Goal)-[:OWNED_BY]->(Company)`
-   `(Opportunity)-[:CONTRIBUTES_TO]->(Goal)`
-   `(Opportunity)-[:CONTRIBUTES_TO]->(Goal)`
-   `(Order)-[:CONTRIBUTES_TO]->(Goal)`
-   `(Opportunity)-[:REFERRED_BY {commission, date}]->(Company)`
-   `(Opportunity)-[:REFERRED_BY {commission, date}]->(Person)`
