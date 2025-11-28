# Graph Modeling Best Practices

## 1. Naming Conventions

-   **Node Labels**: PascalCase (e.g., `RobotUnit`, `ServiceTicket`)
-   **Relationship Types**: UPPER_SNAKE_CASE (e.g., `INSTALLED_AT`, `HAS_PART`)
-   **Properties**: camelCase (e.g., `serialNumber`, `createdAt`)

## 2. Handling Time

-   **Timestamps**: Always store as ISO 8601 strings with timezone offsets (`2024-01-01T12:00:00+00:00`) or standard Neo4j temporal types if using a driver that supports them natively.
-   **Versioning**: For entities that change often (like `Opportunity`), consider using a separate `State` node or just tracking `updatedAt` if history isn't critical.

## 3. Sparse vs. Dense Nodes

-   **Avoid Supernodes**: Be careful with nodes that might have millions of relationships (e.g., a generic `Country` node connected to every user).
-   **Solution**: Use intermediate nodes or properties to shard relationships if necessary.

## 4. Graph Refactoring

-   **Use `Equipment` for physical assets**: Don't confuse products (abstract) with equipment (physical instances). Use `Tag` nodes for concepts you aren't sure about yet.
-   **Promote Tags**: When a `Tag` becomes important (e.g., "Lidar" appears 1000 times), refactor it into a `Technology` node.

## 5. Security & Access

-   **Tenant Isolation**: If serving multiple customers, ensure every query filters by `Tenant` or `Organization` ID.
-   **Role-Based Access**: Use `Person` roles to restrict access to sensitive commercial data (e.g., `Opportunity.amount`).
