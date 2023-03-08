# Notas de Aula - PostgreSQL: Comandos DML e DDL

# Link do Curso

[Curso Online PostgreSQL: comandos DML e DDL | Alura](https://cursos.alura.com.br/course/pgsql-comandos-dml-ddl)

# Materiais de Apoio

[CREATE DATABASE](https://www.postgresql.org/docs/current/sql-createdatabase.html)

[CREATE TABLE](https://www.postgresql.org/docs/12/sql-createtable.html)

[ALTER TABLE](https://www.postgresql.org/docs/12/sql-altertable.html)

[3.4. Transactions](https://www.postgresql.org/docs/current/tutorial-transactions.html)

[CREATE TYPE](https://www.postgresql.org/docs/current/sql-createtype.html)

# Aulas

## Modelagem de Dados:

### *Schemas*

- Separação das entidades (tabelas)
- Pode ocorrer duas tabelas com o mesmo nome em um banco de dados, desde que estejam em esquemas diferentes.
- Se não é especificado um Schema, o postegreSQL insere as tabelas criadas num Schema chamado Public.

Para criar um Schema:

```sql
CREATE SCHEMA nome_esquema;
```

Para fazer menção ao esquema, basta fazer

```sql
nome_esquema.nome_tabela
```

## Estrutura do banco:

### Sintaxe da criação de um banco de dados

```sql
CREATE DATABASE name
    [ WITH ] [ OWNER [=] user_name ]
           [ TEMPLATE [=] template ]
           [ ENCODING [=] encoding ]
           [ STRATEGY [=] strategy ] ]
           [ LOCALE [=] locale ]
           [ LC_COLLATE [=] lc_collate ]
           [ LC_CTYPE [=] lc_ctype ]
           [ ICU_LOCALE [=] icu_locale ]
           [ LOCALE_PROVIDER [=] locale_provider ]
           [ COLLATION_VERSION = collation_version ]
           [ TABLESPACE [=] tablespace_name ]
           [ ALLOW_CONNECTIONS [=] allowconn ]
           [ CONNECTION LIMIT [=] connlimit ]
           [ IS_TEMPLATE [=] istemplate ]
           [ OID [=] oid ]
```

### Sintaxe criação de tabela

Principais comandos:

- TEMPORARY: Cria tabelas temporárias
- IF NOT EXISTS: Cria uma tabela se ela não existe

*Column Constraints*

- NOT NULL: é obrigatório algum valor.
- DEFAULT: Valor padrão quando o mesmo não é informado.
- CHECK: Verificar um valor
- PRIMARY KEY: Chave primária
- etc.

> existem as restrições de tabela (*Table Constraints*) e as restrições de coluna (*Column Constraints*).
> 
> 
> *Column Constraints* se referem a restrições ou informações de uma única coluna. Ex.: Uma chave primária, um campo que deve ser único, um campo que não pode ser nulo, etc.
> 
> *Table Constraints* são informações ou restrições de mais de um campo. Ex.: Chave primária composta, índices compostos, etc.
> 

*Alter table*

Principais ações:

- Renomear uma coluna;
    
    ```sql
    ALTER TABLE nome_tab RENAME nome_col_antigo TO nome_col_novo;
    ```
    
- Renomear constraint;
- Renomear a própria tabela
    
    ```sql
    ALTER TABLE nome_tab_antigo RENAME TO nome_tab_novo;
    ```
    
- Adicionar ou remover uma coluna;

### DDL vs DML

DDL: Data definition language (linguagem de definição de dados)

DML: Data Manipulation Language (linguagem de manipulação dos dados)

![Untitled](Notas%20de%20Aula%20-%20PostgreSQL%20Comandos%20DML%20e%20DDL%200c39e8b3fdf546aeafc16c54ba5f0c41/Untitled.png)

## Inclusão de dados:

> OBS:
- Aspas simples delimitam valores (texto, datas, etc);
- Aspas duplas delimitam campos;
> 
- Para fazermos uma tabela temporária a partir de um *select* de outra tabela, é necessário usar a mesma ordem de criação de parâmetros nas duas tabelas, porém não é necessário que tenham o mesmo nome. Exemplo:

```sql
-- como foi criada a tabela academico.curso
CREATE TABLE academico.curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);
-- criação tabela temporária com a id e nome do curso
CREATE TEMPORARY TABLE cursos_programacao(
	id_curso INTEGER PRIMARY KEY,
	nome_curso VARCHAR(255) NOT NULL
);

-- Inserindo os valores na tabela temporária
INSERT INTO cursos_programacao

SELECT academico.curso.id,
	   academico.curso.nome
	FROM academico.curso
 WHERE categoria_id = 2;
```

### Para importar dados

```
schemas > tables
```

clique com o botão direito na tabela em que se deseja inserir dados e selecione “import/Export Data” e abrirá a seguinte tela, no qual você irá selecionar o arquivo desejado:

![Untitled](Notas%20de%20Aula%20-%20PostgreSQL%20Comandos%20DML%20e%20DDL%200c39e8b3fdf546aeafc16c54ba5f0c41/Untitled%201.png)

## Alteração de dados

### Atualizando dados

Com a função UPDATE, conseguimos atualizar elementos de uma tabela bem como uma tabela com base em outra tabela.

Exemplos de atualização de campos:

```sql
-- atualizando campos
UPDATE academico.curso SET nome = 'PHP Básico' WHERE  id = 4 ;
UPDATE academico.curso SET nome = 'Java Básico' WHERE  id = 5 ;
UPDATE academico.curso SET nome = 'C++ Básico' WHERE  id = 6 ;
```

Exemplo de atualização de tabela:

```sql
UPDATE teste.cursos_programacao SET nome_curso = nome
  FROM academico.curso WHERE teste.cursos_programacao.id_curso = academico.curso.id;
```

### Deletando informação

Por exemplo, para excluir todos os cursos da categoria com nome “Teste”, podemos fazer:

```sql
DELETE FROM curso
      USING categoria
      WHERE categoria.id = curso.categoria_id
        AND categoria.nome = 'Teste';
```

### Cuidados:

Antes de executar o DELETE ou UPDATE, faça um SELECT para verificar se está deletando o que se quer.

### Transações

Um dos conceitos do banco de dados relacional é a atomicidade, ou seja. ou ele executa um comando inteiro ou não executa nada.

Antes de começar a execução de um comando, o postgre marca um *checkpoint,* caso ocorra um erro, o postgre retorna ao momento do checkpoint (como se fosse um *save game*).

Podemos fazer isso manualmente quando quisermos usando o comando a seguir para marcar o ‘*check point*’

```sql
START TRANSACTION;
-- ou
BEGIN;
```

Para reverter as ações, usamos o comando

```sql
ROLLBACK;
```

Para confirmar as ações, usamos o comando:

```sql
COMMIT;
```

Caso você abra um check point e se desconecte do banco de dados, o SGBD fará automaticamente um ‘ROLLBACK’.

## Particularidades do PostgreSQL:

### Sequência:

- CREATE SEQUENCE: Para criar uma sequencia de números, como os SERIAL.
    - CURRVAL: Retorna o valor atual
    - NEXTVAL: Informa o próximo valor e incrementa um na sequência.

### Tipos:

- ENUM: Tipo de dado em que você define os valores possíveis.
    - Exemplo: Um classificação da indicação de um filme.

**Criação de um tipo:**

```sql
CREATE TYPE CLASSIFICACAO AS ENUM ('LIVRE', '12_ANOS', '14_ANOS', '16_ANOS', '18_ANOS')
```

- Como usar:
    
    ```sql
    CREATE TEMPORARY TABLE filme (
    	id SERIAL PRIMARY KEY,
    	nome VARCHAR(255) NOT NULL,
    	classificacao CLASSIFICACAO
    );
    ```
