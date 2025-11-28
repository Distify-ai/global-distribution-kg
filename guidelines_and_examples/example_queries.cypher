// 1. Find all Equipment installed at a specific Customer's sites
MATCH (c:Company {companyName: "Acme Corp"})-[:HAS_SITE]->(s:Site)<-[:INSTALLED_AT]-(e:Equipment)
RETURN c.companyName, s.name, e.serialNumber, e.status;

// 2. Analyze the sales pipeline for a specific Territory
MATCH (t:Territory {name: "North America"})
MATCH (c:Company)-[:IN_TERRITORY]->(t) // Assuming implied relationship or derived from address
MATCH (c)-[:HAS_OPPORTUNITY]->(o:Opportunity)
RETURN o.stage, count(o) as dealCount, sum(o.amount) as totalValue
ORDER BY totalValue DESC;

// 3. Find common issues (Tags) associated with a specific Product Model
MATCH (p:Product {modelNumber: "S100"})
MATCH (doc:Document)-[:ABOUT_PRODUCT]->(p)
MATCH (doc)-[:TAGGED_WITH]->(tag:Tag)
RETURN tag.name, count(doc) as frequency
ORDER BY frequency DESC
LIMIT 10;

// 4. Trace the "Spine" from Manufacturer to Equipment
MATCH path = (mfg:Company:Manufacturer)-[:SELLS_TO]->(dist:Company:GlobalDistributor)-[:FRANCHISES]->(fran:Company:Franchisee)-[:SELLS]->(cust:Company:Customer)-[:OWNS]->(e:Equipment)
RETURN path
LIMIT 5;

// 5. Find Interactions related to high-value Opportunities
MATCH (o:Opportunity) WHERE o.amount > 50000
MATCH (o)<-[:RELATED_TO]-(i:Interaction)
RETURN o.name, o.amount, i.type, i.summary, i.timestamp
ORDER BY i.timestamp DESC;

// 6. Identify "Stalled" Opportunities (No interaction in last 30 days)
MATCH (o:Opportunity) WHERE o.stage IN ['Qualified', 'Proposal']
OPTIONAL MATCH (o)<-[:RELATED_TO]-(i:Interaction)
WITH o, max(i.timestamp) as lastInteraction
WHERE lastInteraction < datetime() - duration('P30D') OR lastInteraction IS NULL
RETURN o.name, o.stage, lastInteraction;

// 7. Find Documents relevant to a specific Equipment instance (via Product)
MATCH (e:Equipment {serialNumber: "SN-12345"})-[:OF_MODEL]->(p:Product)
MATCH (doc:Document)-[:ABOUT_PRODUCT]->(p)
RETURN e.serialNumber, p.name, doc.title, doc.uri;

// 8. Calculate Franchisee Performance (Sales Volume)
MATCH (f:Company:Franchisee)-[:SELLS]->(p:Product)
MATCH (f)-[:PLACED_ORDER]->(o:Order)-[:HAS_LINE]->(ol:OrderLine)-[:OF_PRODUCT]->(p)
RETURN f.companyName, sum(ol.lineTotal) as totalSales
ORDER BY totalSales DESC;

// 9. Find available Technicians in a specific Region
MATCH (t:Person:Technician)
WHERE t.availabilityStatus = "Available" AND t.serviceArea CONTAINS "New York"
RETURN t.fullName, t.skills, t.certifications;

// 10. Find Employees working for Global Distributor
MATCH (p:Person)-[:WORKS_FOR]->(c:Company:GlobalDistributor)
RETURN p.fullName, p.jobTitle, c.companyName;

// 11. Find Franchise Owners (Role-based lookup)
MATCH (p:Person)-[r:WORKS_FOR]->(c:Company:Franchisee)
WHERE p.jobTitle CONTAINS "Owner" OR r.role = "Owner"
RETURN p.fullName, c.companyName;

// 12. Track Referral Performance (Partner & Individual)
MATCH (referrer)-[r:REFERRED_BY]->(o:Opportunity)
WHERE o.stage = "Won"
RETURN labels(referrer)[0] as referrerType, referrer.name, referrer.fullName, sum(o.amount) as totalRevenue, sum(r.commission) as totalCommission
ORDER BY totalRevenue DESC;

// 13. Find Equipment Maintained by Specific Technician
MATCH (t:Person:Technician {fullName: "Alex Tech"})-[:MAINTAINS]->(e:Equipment)
RETURN e.serialNumber, e.status, e.lastServiceDate;
