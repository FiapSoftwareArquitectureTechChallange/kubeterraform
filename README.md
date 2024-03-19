# BurgerRoyale K8s

## Pré-requisitos

Antes de começar, você precisa ter os seguintes softwares instalados:

- AWS CLI
- Terraform
- kubectl

### Instalação do AWS CLI

Para instalar o AWS CLI, siga as instruções disponíveis na documentação oficial da AWS:

```bash
https://aws.amazon.com/cli/
```

### Instalação do Terraform

Para instalar o Terraform, visite a página de downloads do Terraform e siga as instruções específicas para o seu sistema operacional:

```bash
https://www.terraform.io/downloads.html
```

### Instalação do kubectl

Para instalar o kubectl, siga as instruções na documentação oficial do Kubernetes:

```bash
https://kubernetes.io/docs/tasks/tools/
```

## Configuração

Após a instalação dos softwares necessários, configure o AWS CLI com suas credenciais:

```bash
aws configure
```

Isso permitirá que o Terraform e o kubectl interajam com os recursos da AWS.

## Uso

Para iniciar o projeto BurgerRoyale K8s, siga os passos abaixo:

1. Inicialize o Terraform para preparar seu projeto:

```bash
terraform init
```

2. Revise o plano de execução do Terraform para entender as alterações que serão aplicadas na AWS:

```bash
terraform plan
```

3. Aplique as configurações na AWS:

```bash
terraform apply
```

Após a aplicação, o cluster EKS estará pronto para ser usado. Você pode configurar o `kubectl` para interagir com seu novo cluster EKS atualizando seu kubeconfig:

```bash
aws eks update-kubeconfig --region <regiao-aws> --name <nome-do-cluster-eks>
```

Substitua `<regiao-aws>` pela região AWS do seu cluster e `<nome-do-cluster-eks>` pelo nome do seu cluster EKS.

## Configuração do Estado Remoto do Terraform com S3

O projeto utiliza um bucket do S3 para armazenar o estado remoto do Terraform, permitindo uma gestão de estado mais segura e colaborativa entre a equipe. Para configurar isso, você precisa:

1. Criar um bucket do S3 na AWS. Certifique-se de habilitar o versionamento para proteger e gerenciar as versões do seu estado do Terraform.

```bash
aws s3 mb s3://<nome-do-seu-bucket> --region <regiao-aws>
aws s3api put-bucket-versioning --bucket <nome-do-seu-bucket> --versioning-configuration Status=Enabled
```

Substitua `<nome-do-seu-bucket>` pelo nome único do seu bucket S3 e `<regiao-aws>` pela região onde o bucket será criado.

2. Configurar o provider do Terraform para usar este bucket do S3 como backend para o estado:

```hcl
terraform {
  backend "s3" {
    bucket         = "<nome-do-seu-bucket>"
    key            = "estado/terraform.tfstate"
  }
}
```

Neste exemplo, substitua `<nome-do-seu-bucket>` pelo nome do seu bucket S3, `<regiao-aws>` pela região AWS do seu bucket.

3. Após configurar o backend do S3, inicialize novamente o Terraform para que ele comece a usar o novo backend configurado:

```bash
terraform init
```

Isso pode solicitar que você confirme a migração do estado local para o estado remoto. Confirme conforme necessário para completar a configuração.

### Importante

- Certifique-se de aplicar as políticas de segurança adequadas ao seu bucket S3 e à tabela DynamoDB para proteger seu estado do Terraform.
- Nunca compartilhe seu estado do Terraform publicamente, pois ele pode conter informações sensíveis sobre sua infraestrutura.
