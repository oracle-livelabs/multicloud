# Source Traceability.

Estimated Time: 5 minutes

## Source Materials.

- `Demo Script for OD 1.2.1.docx`: source demo script for Oracle Database@Azure architecture and operations.
- Extracted text: `C:\codex\livelabs-od-source-extract\document-text.txt`.
- Extracted graphics: `C:\codex\livelabs-od-source-extract\media`.

## Lab Mapping

### Lab 1: Review Azure Access, Offers, and Resource Organization

- Duration: 15 minutes.
- Source use: Confirm the Azure subscription, private offer, resource group, and Oracle Database@Azure entry points.
- `image1.png` -> `azure-foundation/images/azure-private-offer-search.png`: Azure portal search showing the private offer entry point.
- `image2.png` -> `azure-foundation/images/azure-private-offer-management.png`: Azure Marketplace private offer management list.
- `image3.png` -> `azure-foundation/images/oracle-database-at-azure-offer.png`: Oracle Database@Azure private offer purchase review page.
- `image4.png` -> `azure-foundation/images/azure-network-resource-list.png`: Azure resource list showing Oracle Database@Azure networking assets.
- `image5.png` -> `azure-foundation/images/azure-resource-group-overview.png`: Azure resource group overview for the demo environment.
- `image6.png` -> `azure-foundation/images/oracle-database-at-azure-overview.png`: Oracle Database@Azure overview tile in the Azure portal.

### Lab 2: Review Exadata Infrastructure in Azure

- Duration: 15 minutes.
- Source use: Inspect provisioned Exadata infrastructure, VM clusters, and DB server views from Azure.
- `image7.png` -> `exadata-on-azure/images/exadata-infrastructure-list.png`: Azure list of Oracle Exadata infrastructure resources.
- `image8.png` -> `exadata-on-azure/images/exadata-infrastructure-details.png`: Exadata infrastructure details page in Azure.
- `image9.png` -> `exadata-on-azure/images/exadata-vm-clusters-list.png`: Exadata VM clusters list in Azure.
- `image10.png` -> `exadata-on-azure/images/exadata-db-servers-list.png`: Exadata database servers list in Azure.

### Lab 3: Explore the OCI Control Plane for Oracle Database@Azure

- Duration: 20 minutes.
- Source use: Use OCI views to inspect subscription mapping, identity, VM cluster scaling, and database operations.
- `image11.png` -> `oci-control-plane/images/go-to-oci-control-plane.png`: Go to OCI link from Oracle Database@Azure.
- `image12.png` -> `oci-control-plane/images/oci-subscription-mapping-list.png`: OCI subscription mapping list for Oracle Database@Azure.
- `image13.png` -> `oci-control-plane/images/oci-subscription-mapping-details.png`: OCI subscription mapping details for Azure tenancy association.
- `image14.png` -> `oci-control-plane/images/oci-identity-domains.png`: OCI identity domain view for administrator group review.
- `image15.png` -> `oci-control-plane/images/oci-default-domain-users.png`: OCI default identity domain users and groups view.
- `image16.png` -> `oci-control-plane/images/oci-vm-cluster-details.png`: OCI Exadata VM cluster details page.
- `image17.png` -> `oci-control-plane/images/oci-scale-vm-cluster.png`: OCI scale VM cluster dialog for resource allocation.
- `image18.png` -> `oci-control-plane/images/oci-exadata-database-details.png`: OCI Exadata database details and monitoring page.

### Lab 4: Explore Autonomous Database Operations

- Duration: 15 minutes.
- Source use: Review an Autonomous Database, disaster recovery status, and the create workflow.
- `image19.png` -> `autonomous-database/images/azure-autonomous-database-overview.png`: Azure Autonomous Database overview page.
- `image20.png` -> `autonomous-database/images/oci-autonomous-database-details.png`: OCI Autonomous Database details with backups and DR tabs.
- `image21.png` -> `autonomous-database/images/azure-autonomous-database-list.png`: Azure list of Autonomous Database resources.
- `image22.png` -> `autonomous-database/images/create-autonomous-database-basics.png`: Create Autonomous Database basics tab in Azure.
- `image23.png` -> `autonomous-database/images/create-autonomous-database-configuration.png`: Create Autonomous Database configuration tab.
- `image24.png` -> `autonomous-database/images/create-autonomous-database-networking.png`: Create Autonomous Database networking tab.

### Lab 5: Review Monitoring and Cost Signals

- Duration: 10 minutes.
- Source use: Use Azure and OCI monitoring views to discuss health, metrics, budget review, and operational follow-up.
- `image25.png` -> `monitoring-and-cost/images/azure-database-metrics-chart.png`: Azure metrics chart for Oracle Database@Azure resources.
- `image26.png` -> `monitoring-and-cost/images/oci-database-metrics-chart.png`: OCI database metrics chart for the same operational review.

## Oracle Validation Notes

- Exadata statements stay at architecture and console-review level.
- Autonomous Database statements use general Oracle-managed automation concepts: patching, backup, tuning, and auto scaling.
- Backup and recovery wording avoids implementation claims beyond the source unless framed as a design question.
- Data Guard and cross-region disaster recovery language remains conditional because the demo document does not provide full configuration evidence.

## Acknowledgements

* **Author** - Oracle LiveLabs workshop draft generated from the provided demo script.
* **Last Updated By/Date** - Codex, May 14, 2026
