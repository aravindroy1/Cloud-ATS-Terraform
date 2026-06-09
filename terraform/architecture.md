# Cloud-ATS Azure Architecture

This document describes the Azure architecture for the Cloud-ATS solution, using the Terraform modules in `terraform/modules` and the application code in `Cloud-ATS-App`.

## Architecture Summary

The Cloud-ATS architecture uses the following Azure services:

- **Azure Application Gateway**: external secure ingress for web traffic
- **Azure App Service**: host the Node.js frontend/backend web application
- **Azure Function App**: handle blob-triggered resume processing and Document Intelligence integration
- **Azure Storage Account**: store uploaded resumes and Function app storage
- **Azure Cosmos DB (MongoDB API)**: store user accounts, resume metadata, scores, and audit results
- **Azure Cognitive Services / Document Intelligence**: parse and analyze resume documents
- **Azure Key Vault**: store secrets, connection strings, and API keys
- **Azure Active Directory**: app registration and identity integration for the app
- **Azure Virtual Network + NSGs**: isolate infrastructure and route traffic privately
- **Azure Private Endpoints**: private access to storage, Cosmos DB, Key Vault, and cognitive services
- **Azure Monitor / Application Insights**: telemetry and monitoring for the application and functions

## High-level Data Flow

1. The end user opens the Cloud-ATS web application in a browser.
2. The browser traffic is routed through **Azure Application Gateway** to the **Azure App Service**.
3. The App Service serves the SPA frontend and backend API.
4. When the user uploads a resume, the app writes the file to **Azure Blob Storage**.
5. A **Function App** is triggered by the blob upload event.
6. The Function App uses **Azure Document Intelligence** to extract and analyze resume contents.
7. The parsed resume data and ATS scores are stored in **Azure Cosmos DB**.
8. The App Service reads data from Cosmos DB and returns results to the user.
9. Both App Service and Function App use **Azure Key Vault** and Managed Identity to secure secrets and storage access.
10. The entire solution is protected inside a **VNet** and connected through **Private Endpoints**.
11. **Azure Monitor** collects logs and metrics across App Service, Function App, Cosmos DB, and other resources.

## Azure Symbol Diagram

```mermaid
flowchart LR
  subgraph External
    User[User Browser]
  end

  subgraph Ingress[Azure Application Gateway]
    AG[Application Gateway]
  end

  subgraph AppLayer[Azure App Service + Azure Function App]
    App[App Service<br/>Web UI & API]
    Func[Function App<br/>Resume Processor]
  end

  subgraph DataLayer[Azure Data & AI Services]
    Blob[Storage Account<br/>Blob Container]
    Cosmos[Cosmos DB<br/>(MongoDB API)]
    DI[Document Intelligence<br/>Form Recognizer]
    KV[Key Vault]
  end

  subgraph Security[Azure Security & Networking]
    AAD[Azure Active Directory]
    VNet[Virtual Network]
    PE[Private Endpoints]
    NSG[Network Security Groups]
  end

  subgraph Observability[Azure Monitoring]
    Monitor[Azure Monitor / App Insights]
  end

  User --> AG --> App
  App --> Blob
  App --> Cosmos
  App --> KV
  App --> AAD
  Func --> Blob
  Func --> DI
  Func --> Cosmos
  Func --> KV
  AG -->|secure route| App
  App -->|managed identity| KV
  Func -->|managed identity| KV
  VNet -.-> App
  VNet -.-> Func
  VNet -.-> Blob
  VNet -.-> Cosmos
  VNet -.-> KV
  VNet -.-> DI
  VNet -.-> AAD
  PE -.-> Blob
  PE -.-> Cosmos
  PE -.-> KV
  PE -.-> DI
  Monitor --> App
  Monitor --> Func
  Monitor --> Cosmos
  Monitor --> Blob
  Monitor --> DI
```

## Notes

- The `functionapp` Terraform module defines the Function App, service plan, identities, and role assignments for Key Vault and Storage access.
- The `document-intelligence` module creates the Cognitive Services resource for resume parsing.
- The `entra-id` module defines the Azure AD application registration used for auth and app identity.
- The architecture strongly favors private networking and managed identities.

## Recommended Azure Symbols

If you want to draw this with Azure icons, use these service symbols:

- `Application Gateway`
- `App Service`
- `Function App`
- `Storage Account`
- `Cosmos DB`
- `Cognitive Services` / `Form Recognizer`
- `Key Vault`
- `Azure Active Directory`
- `Virtual Network`
- `Private Endpoint`
- `Azure Monitor`

## Visio-Style Diagram Description

Use this layout when drawing the architecture in Visio or any diagramming tool:

1. Top layer: user-facing entry
   - Place a `User` icon at the top
   - Connect it to an `Application Gateway` icon

2. Middle layer: application tier
   - Draw `App Service` and `Function App` side by side
   - Show the App Service handling web UI/API traffic
   - Show the Function App as an asynchronous processor triggered by blob uploads

3. Data and AI layer: dependencies below the app tier
   - Place `Storage Account` to the left
   - Place `Cosmos DB` in the center
   - Place `Document Intelligence` to the right
   - Add `Key Vault` below or beside them as a shared secret store

4. Security/networking layer: overlay or side decorations
   - Surround the app and data layer with a `Virtual Network` boundary
   - Show `Private Endpoints` connecting the app and function to Storage, Cosmos, Key Vault, and Document Intelligence
   - Add `Network Security Groups` for subnet control if you want more detail

5. Identity and monitoring
   - Add `Azure Active Directory` near App Service and Function App to show auth/identity
   - Add `Azure Monitor / Application Insights` as a monitoring service connected to both compute resources and the data layer

6. Connectors and annotations
   - Use arrows: User -> App Gateway -> App Service
   - App Service -> Blob Storage, Cosmos DB, Key Vault
   - Function App -> Blob Storage, Document Intelligence, Cosmos DB, Key Vault
   - Annotate app-to-Key Vault and function-to-Key Vault with `Managed Identity`
   - Annotate Storage and Cosmos DB access as `Private Endpoint` if using private networking

This Visio-style structure keeps the diagram clean and makes the security boundary and private network topology easy to understand.
