# 🍔 FastFood SOAT Database

Repositório responsável pela gestão da infraestrutura como código (IaC) e estrutura do banco de dados do sistema FastFood SOAT. Este projeto gerencia automaticamente a criação e migração do banco PostgreSQL na AWS usando Terraform e GitHub Actions.

## 📋 Visão Geral

Este projeto implementa:
- **Infraestrutura como Código** com Terraform
- **Banco de dados PostgreSQL** na AWS RDS
- **Migrações automáticas** via GitHub Actions
- **Versionamento de schema** com scripts SQL
- **Integração Discord** para notificações

## 🏗️ Arquitetura

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  GitHub Actions │    │  AWS RDS         │    │  Discord        │
│                 │───▶│  PostgreSQL 17   │    │  Notifications  │
│  CI/CD Pipeline │    │  (db.t3.micro)   │◀───│                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                        │
         ▼                        │
┌──────────────────┐              │
│   Terraform      │              │
│   State (S3)     │◀─────────────┘
│   Lock (DynamoDB)│
└──────────────────┘
```

## 🗄️ Estrutura do Banco de Dados

### Tabelas Principais

| Tabela | Descrição | Características |
|--------|-----------|-----------------|
| `clients` | Cadastro de clientes | Soft delete, UUID público |
| `orders` | Pedidos do sistema | Numeração sequencial, status |
| `order_products` | Itens dos pedidos | Relacionamento N:N |
| `products` | Catálogo de produtos | Preços, categorias |
| `product_categories` | Categorias (Lanche, Bebida, etc.) | Sistema fixo |
| `payments` | Pagamentos | QR Code, referência externa |
| `staff` | Funcionários | Sistema de permissões |
| `roles` | Cargos (ADMIN, EMPLOYEE) | Controle de acesso |

### Características Técnicas

- ✅ **Soft Delete**: Todas as tabelas com `deleted_at`
- ✅ **Auditoria**: `created_at` e `updated_at` automáticos
- ✅ **UUIDs**: Identificação externa segura
- ✅ **Índices Otimizados**: Hash, B-tree e BRIN
- ✅ **Triggers**: Timestamps automáticos

## 📁 Estrutura do Projeto

```
├── 📁 scripts/                         # Migrações SQL versionadas
│   ├── V1__init.sql                    # Schema inicial
│   └── V2__insert_initial_data.sql     # Dados base
├── 📁 infra/                           # Infraestrutura
│   ├── 📁 terraform/                   # Infraestrutura AWS
│   │   ├── backend.tf                  # Configuração do backend (tfstate)
│   │   ├── data.tf                     # Recuperando recursos da AWS
│   │   ├── destroy_config.json         # Define se deve ser aplicado o destroy
│   │   ├── main.tf                     # Configuração do Terraform
│   │   ├── outputs.tf                  # Define o output do endpoint do rds
│   │   ├── provider.tf                 # Configura o provider da AWS (sa-east-1)
│   │   ├── rds.tf                      # Configura subnet-group do rds e instancia rds
│   │   ├── security.tf                 # Security Groups
│   │   └── 📁 envs/                    # Variáveis por ambiente
│   │       ├── 📁 dev/                 # Config do ambiente de DEV
│   │       │   └── terraform.tfvars    # Variaveis de ambiente de DEV
│   │       └── 📁 prod/                # Config do ambiente de PROD
│   │           └── terraform.tfvars    # Variaveis de ambientte de PROD
│   └── 📁 scripts/                     # Automação Python
│       ├── run_scripts.py              # Executor de migrações
│       └── requirements.txt            # Dependências Python
├── 📁 .github/workflows/               # CI/CD Pipelines
└── config.yaml                         # Definição dos scripts que serão executados
```

## 🚀 CI/CD Pipelines

### Workflows Disponíveis

| Workflow | Trigger | Ambiente | Função |
|----------|---------|----------|--------|
| `main.yaml` | Push para `main` | **PROD** | Deploy produção |
| `release.yaml` | Push para `release/*` | **DEV** | Deploy desenvolvimento |
| `workflow-pull-request.yaml` | Pull Request | - | Notificações Discord |
| `database.yaml` | Reutilizável | Configurável | Deploy completo |

### Fluxo de Deploy

```mermaid
    A[Push Code] --> B[GitHub Actions]
    B --> C[Terraform Plan]
    C --> D[Terraform Apply]
    D --> E[Run SQL Scripts]
    E --> F[Discord Notification]
```

## 🔐 Configuração das GitHub Secrets

### AWS (IAM Roles - Recomendado)
```bash
AWS_GITHUB_ACTIONS_ROLE_ARN    # ARN da role IAM para GitHub Actions
AWS_REGION                     # Região AWS (ex: sa-east-1)
AWS_STATEFILE_S3_BUCKET        # Bucket S3 para Terraform state
AWS_LOCK_DYNAMODB_TABLE        # Tabela DynamoDB para Terraform lock (partition key: LockID)
```

### Database
```bash
DB_NAME                        # Nome do banco PostgreSQL
DB_USERNAME                    # Usuário do PostgreSQL
DB_PASSWORD                    # Senha do PostgreSQL
```

### Network Security
```bash
ALLOWED_CIDR                   # CIDR permitido para acesso ao RDS
```

### Discord Notifications
```bash
DISCORD_BUILD_WEBHOOK          # Webhook para notificações de build
DISCORD_PULLREQUEST_WEBHOOK    # Webhook para notificações de PR
```

### Como Configurar
1. Acesse: `Settings` → `Secrets and variables` → `Actions`
2. Configure todas as 10 secrets listadas acima
3. Certifique-se de que a AWS IAM Role tenha as permissões necessárias

## 🏗️ Pré-requisitos AWS

### Infraestrutura Base
- [x] **IAM Role** configurada com OIDC para GitHub Actions
- [x] **S3 Bucket** para Terraform state
- [x] **DynamoDB Table** para Terraform lock
- [x] **VPC** com subnets públicas taggeadas (`Name: fastfood-vpc`)

### Permissões IAM Necessárias
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds:*",
        "ec2:*",
        "s3:*",
        "dynamodb:*"
      ],
      "Resource": "*"
    }
  ]
}
```

## 🛠️ Como Usar

### 1. Configuração Inicial
```bash
# Clone o repositório
git clone https://github.com/seu-usuario/fastfood-soat-database.git
cd fastfood-soat-database

# Configure o repositório no seu GitHub
# Configure as secrets no GitHub
# Certifique-se de ter a infraestrutura AWS base
```

### 2. Deploy Desenvolvimento
```bash
# Crie uma branch release
git checkout -b release
git push origin release

# GitHub Actions irá automaticamente:
# 1. Executar Terraform para criar/atualizar RDS
# 2. Executar scripts SQL de migração
# 3. Notificar resultado no Discord
```

### 3. Deploy Produção
```bash
# Merge para main após testes
git checkout main
git merge release
git push origin main

# Deploy automático em produção
```

### 4. Executar Scripts Localmente (Opcional)
```bash
# Configure as variaveis de ambiente
#   DB_HOST
#   DB_USER
#   DB_PASS
#   DB_NAME
cd infra/scripts
pip install -r requirements.txt

# Configure config.yaml com suas credenciais
python run_scripts.py
```

## ⚙️ Configuração dos Scripts SQL

### Arquivo `config.yaml`

O arquivo `config.yaml` é o **coração da execução das migrações**, definindo quais scripts SQL serão executados e em qual ordem.

#### Estrutura do `config.yaml`
```yaml
# Scripts SQL a serem executados (ORDEM IMPORTA!)
scripts:
  - V1__init.sql
  - V2__insert_initial_data.sql
```
#### Como Funciona a Execução

1. **Leitura do Config**: O `run_scripts.py` carrega o `config.yaml`
2. **Validação**: Verifica conexão com banco e existência dos arquivos
3. **Execução Sequencial**: Roda cada script na ordem definida
4. **Log de Progresso**: Registra sucesso/falha de cada script nos logs
5. **Relatório Final**: Sumário da execução completa

### Adicionando Novos Scripts

Para adicionar uma nova migração:

1. **Crie o script SQL** em `/scripts/` (ex: `V3__add_new_table.sql`)
2. **Atualize o `config.yaml`**:
   ```yaml
   scripts:
     # ...scripts existentes...
     - V3__add_new_table.sql
     # Basta definir o nome do arquivo, a pipeline já considera o diretório scripts
   ```
3. **Commit e push** - o CI/CD executará automaticamente

## 📊 Monitoramento

### Discord Notifications
- **Build Status**: Sucesso/falha dos deploys
- **Pull Requests**: Notificações de novos PRs
- **Erros**: Alertas de problemas na pipeline

## 🔧 Configuração de Ambientes

### Desenvolvimento (`envs/dev/terraform.tfvars`)
```hcl
# No momento todos estão sendo definidos por variaveis de ambiente TF_VAR, pois são dados sensíveis,
# recuperados de secrets do GitHub.
```

### Produção (`envs/prod/terraform.tfvars`)
```hcl
# No momento todos estão sendo definidos por variaveis de ambiente TF_VAR, pois são dados sensíveis,
# recuperados de secrets do GitHub.
```

## 🚨 Troubleshooting

### Problemas Comuns

| Problema | Solução |
|----------|---------|
| "Role não encontrada" | Verificar `AWS_GITHUB_ACTIONS_ROLE_ARN` |
| "Bucket não existe" | Criar bucket S3 para Terraform state |
| "Subnet não encontrada" | Verificar tags da VPC (`Name: fastfood-vpc`) |
| "Script SQL falhou" | Verificar logs no GitHub Actions |
