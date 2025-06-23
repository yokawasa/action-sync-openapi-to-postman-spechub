# action-sync-openapi-to-postman-spechub

GitHub Action that synchronizes OpenAPI specifications to Postman SpecHub. This action allows you to update your Postman SpecHub with OpenAPI files stored in your repository.

> Postman [SpecHub](https://www.postman.com/product/spec-hub/) is a feature within Postman that allows teams to manage and collaborate on API specifications. It provides a centralized location for storing, editing, and sharing API specifications, such as OpenAPI and AsyncAPI.

## Usage

The following inputs are required to use this GitHub Action:

| Input Name            | Description                                                                                                                                    | Required | Default          |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------------- |
| `postman-api-key`   | Postman API Key. Please refer to [this page](https://learning.postman.com/docs/developer/postman-api/authentication/) to get Postman API Key | Yes      | None             |
| `postman-spec-id`   | Postman Spec ID. A Spec ID refers to the unique identifier assigned to an API specification stored in Postman SpecHub. | Yes      | None             |
| `openapi-file-path` | Path to the OpenAPI specification file in the repository. | Yes      | `openapi.yaml` |
| `openapi-format`    | OpenAPI file format. Must be either `yaml` or `json`. | Yes      | `yaml`         |

## Example Workflow

Below is an example of how to use this GitHub Action in a workflow:

```yaml
name: Sync OpenAPI to Postman SpecHub

on:
  push:
    branches:
      - main

jobs:
  sync-openapi:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
  
      - name: Sync OpenAPI to Postman SpecHub
        uses: yokawasa/action-sync-openapi-to-postman-spechub@v0.1.0
        with:
          postman-api-key: ${{ secrets.POSTMAN_API_KEY }}
          postman-spec-id: "your-postman-spec-id"
          openapi-file-path: "openapi.yaml"
          openapi-format: "yaml"
```

### Notes

- Ensure that `POSTMAN_API_KEY` is securely stored as a GitHub Actions secret. You can add it in your repository settings under **Settings > Secrets and variables > Actions > New repository secret**.
