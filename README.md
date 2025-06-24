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
      - main # trigger push to main branch 

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
          postman-spec-id: "<your-postman-spec-id>"
          openapi-file-path: "<openapi-file-path>"
          openapi-format: "yaml"
```

The following example demonstrates how to check for changes in the OpenAPI file and only proceed with the workflow if modifications are detected:

```yaml
name: Sync OpenAPI to Postman SpecHub

on:
  push:
    branches:
      - main # trigger push to main branch 

env:
  OPENAPI_FILE: oas/openapi.yaml # Path to your OpenAPI file
  POSTMAN_SPEC_ID: "12345678-27b6-4169-b5f1-af123b75be75"  # Your Postman Spec ID

jobs:
  sync-openapi:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout main branch
        uses: actions/checkout@v3

      - name: Check for changes in openapi.yaml
        id: detect_change
        run: |
          git fetch origin main
          # Check if OpenAPI has changed in the last commit (diff HEAD~1 and HEAD)
          CHANGED=$(git diff --name-only HEAD~1 HEAD | grep "$OPENAPI_FILE" || true)
          echo "changed_files=$CHANGED" >> $GITHUB_OUTPUT

      - name: Exit if no changes detected
        if: steps.detect_change.outputs.changed_files == ''
        run: |
          echo "No changes detected in $OPENAPI_FILE. Exiting workflow."
          exit 0

      - name: Sync OpenAPI to Postman SpecHub
        uses: yokawasa/action-sync-openapi-to-postman-spechub@v0.1.0
        with:
          postman-api-key: ${{ secrets.POSTMAN_API_KEY }}
          postman-spec-id: ${{ env.POSTMAN_SPEC_ID }}
          openapi-file-path: ${{ env.OPENAPI_FILE }}
          openapi-format: "yaml"

```

### Notes

- Ensure that `POSTMAN_API_KEY` is securely stored as a GitHub Actions secret. You can add it in your repository settings under **Settings > Secrets and variables > Actions > New repository secret**.
