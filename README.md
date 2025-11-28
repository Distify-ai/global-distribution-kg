# Global Distribution Knowledge Graph Schema

> **A Deep Contextual Engine for the Future of B2B Distribution**

This repository contains the public schema for a **Global Distribution Knowledge Graph**. It is designed to model the entire equipment distribution value chain—from manufacturers to franchisees to end customers and their equipment assets—enabling AI agents to understand and act upon deep business context.

## Vision

The goal is to build a **Deep Contextual Engine** that revolutionizes how B2B distribution companies preserve context and eliminate miscommunication. By structuring data into a semantic graph, we can:

-   **Eliminate "Boring Middle Management"**: Automate coordination and information routing.
-   **Empower Agents**: Give AI agents the deep context they need to make decisions, not just chat.
-   **Preserve Institutional Memory**: Capture the "pulse" of the business (interactions, decisions, relationships) alongside the static records.

## Architecture: Spine & Flesh

The schema is organized into two primary layers:

1.  **The Spine (Value Chain Structure)**: The rigid backbone of the market.
    -   `Manufacturer` → `Distributor` → `Franchisee` → `Customer` → `Equipment`
2.  **The Flesh (Cadence & Context)**: The dynamic pulse of business.
    -   `Interaction`, `Task`, `Document`, `Opportunity`

See [schema/concepts.md](schema/concepts.md) for a visual diagram of this architecture.

## Repository Structure

-   `schema/`: The core specification.
    -   `concepts.md`: Core entities, principles, and data model diagram.
    -   `schema.md`: Detailed definitions of Entities and Relationships.
-   `guidelines_and_examples/`: Implementation guides.
    -   `organizing_principles.md`: LLM extraction rules.
    -   `technical_specs.md`: Indexing, security, and performance specs.
    -   `validation_rules.md`: Cardinality and property constraints.
    -   `example_queries.cypher`: 10+ example Cypher queries.
-   `resources/`: Standard reference data (e.g., ISIC codes).

## Getting Started

1.  **Explore the Schema**: Start with [schema/concepts.md](schema/concepts.md) to understand the core model.
2.  **View Examples**: Check `guidelines_and_examples/example_queries.cypher` for Neo4j queries.
3.  **Implement**: Use the `guidelines_and_examples/organizing_principles.md` to configure your LLM extraction pipelines.

## Governance

This project follows Semantic Versioning. See [GOVERNANCE.md](GOVERNANCE.md) for contribution guidelines and change management processes.

## License

MIT License. See [LICENSE](LICENSE) for details.
