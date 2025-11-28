# Governance & Contribution

## Versioning Strategy

This schema follows [Semantic Versioning](https://semver.org/):

-   **MAJOR (v1.0.0)**: Breaking changes (removing entities/properties, changing relationship directions).
-   **MINOR (v1.1.0)**: Backwards-compatible additions (new entities, new optional properties).
-   **PATCH (v1.0.1)**: Documentation fixes, clarification of descriptions.

### Current Version: v1.0.0-draft

## Change Management Process

1.  **Proposal**: Open an issue describing the proposed change (e.g., "Add `Warranty` entity").
2.  **Review**: The core maintainers review the proposal for alignment with the "Spine & Flesh" architecture.
3.  **Implementation**: Create a Pull Request with:
    -   Updated `schema/schema.md`
    -   Updated `guidelines_and_examples/validation_rules.md`
    -   Example Cypher query demonstrating the new feature.
4.  **Approval**: Requires approval from 1 core maintainer.

## Extension Guidelines

If you need to extend this schema for your specific organization:

1.  **Add, Don't Modify**: Add new labels and properties rather than changing existing definitions.
2.  **Namespace Custom Properties**: Prefix custom properties with your org name (e.g., `acme_customField`) to avoid future collisions.
3.  **Use Tags First**: Before creating a new Entity type, try using the `Tag` entity to capture the concept.
