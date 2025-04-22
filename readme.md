# API Client Generator

This repository contains a shell script (`generate-api.sh`) to generate client SDKs from an OpenAPI spec using the official `openapi-generator-cli`. It supports multiple output languages including TypeScript, Python, and C#.

## Table of Contents

- [Installation](#installation)
  - [Install Java](#install-java)
- [Usage](#usage)
  - [Run the Script](#run-the-script)
- [Importing Generated Clients](#importing-generated-clients)
  - [TypeScript (Axios)](#typescript-axios)
  - [Python](#python)
  - [C#](#c)
- [License](#license)

## Installation

### Install Java

This script requires Java 17 or higher.

#### macOS
```bash
brew install openjdk@17
brew link --force --overwrite openjdk@17
```

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install openjdk-17-jdk
```

#### Verify Installation
```bash
java -version
```

## Usage

### Run the Script

Use the `generate-api.sh` script:

```bash
./generate-api.sh <output-directory>
```

You will be prompted to choose a target language:

1. TypeScript (Axios)  
2. C#  
3. Python

The script will:
- Check for Java
- Download `openapi-generator-cli` if not already available
- Fetch the OpenAPI schema from a remote URL
- Generate the SDK in the given directory
- Clean up unnecessary files

**Example:**

```bash
./generate-api.sh ./generated-client
```

## Importing Generated Clients

### TypeScript (Axios)
```bash
npm install axios
```

```ts
import { Configuration, AuthApi, ItemApi } from './api1';

export class ApiClient {
  itemApi: ItemApi;
  authApi: AuthApi;

  constructor(apiEndpoint: string) {
    const config = this.getApiConfiguration(apiEndpoint);
    this.itemApi = new ItemApi(config);
    this.authApi = new AuthApi(config);
  }

  private getApiConfiguration(apiEndpoint: string): Configuration {
    return new Configuration({
      basePath: apiEndpoint,
      accessToken: async () => {
        return 'token';
      },
    });
  }
}

```

### Python
```bash
pip install -e ./generated-client
```

```python
from generated_client import MyApiClient
```

### C#
Include the generated `.cs` files in your .NET project.

## License

MIT License.
