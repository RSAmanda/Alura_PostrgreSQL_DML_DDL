CREATE SCHEMA academico;
-- ########################################################## 
-- Informações do treinamento anterior  - Alura
CREATE TABLE academico.aluno (
    id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL
);

CREATE TABLE academico.categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE academico.curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

CREATE TABLE academico.aluno_curso (
	aluno_id INTEGER NOT NULL REFERENCES aluno(id),
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);

INSERT INTO academico.aluno (primeiro_nome, ultimo_nome, data_nascimento) VALUES (
	'Vinicius', 'Dias', '1997-10-15'
), (
	'Patricia', 'Freitas', '1986-10-25'
), (
	'Diogo', 'Oliveira', '1984-08-27'
), (
	'Maria', 'Rosa', '1985-01-01'
);

INSERT INTO academico.categoria (nome) VALUES ('Front-end'), ('Programação'), ('Bancos de dados'), ('Data Science');

INSERT INTO academico.curso (nome, categoria_id) VALUES
	('HTML', 1),
	('CSS', 1),
	('JS', 1),
	('PHP', 2),
	('Java', 2),
	('C++', 2),
	('PostgreSQL', 3),
	('MySQL', 3),
	('Oracle', 3),
	('SQL Server', 3),
	('SQLite', 3),
	('Pandas', 4),
	('Machine Learning', 4),
	('Power BI', 4);
	
INSERT INTO academico.aluno_curso VALUES (1, 4), (1, 11), (2, 1), (2, 2), (3, 4), (3, 3), (4, 4), (4, 6), (4, 5);
-- ########################################################## 
 
-- criação tabela temporária com a id e nome do curso
CREATE TEMPORARY TABLE cursos_programacao(
	id_curso INTEGER PRIMARY KEY,
	nome_curso VARCHAR(255) NOT NULL
);

-- inserindo valroes na tabela temporária
INSERT INTO cursos_programacao

SELECT academico.curso.id,
	   academico.curso.nome
	FROM academico.curso
   WHERE categoria_id = 2;
   
SELECT * FROM cursos_programacao;

-- importar arquivo
-- criando um esquema teste
CREATE SCHEMA teste;

-- criando uma tabela temporária
-- criação tabela 
CREATE TABLE teste.cursos_programacao(
	id_curso INTEGER PRIMARY KEY,
	nome_curso VARCHAR(255) NOT NULL
);

-- inserindo valores:
INSERT INTO teste.cursos_programacao

SELECT academico.curso.id,
	   academico.curso.nome
	FROM academico.curso
   WHERE categoria_id = 2;
   
SELECT * FROM teste.cursos_programacao;
   
-- atualizando campos
UPDATE academico.curso SET nome = 'PHP Básico' WHERE  id = 4 ;
UPDATE academico.curso SET nome = 'Java Básico' WHERE  id = 5 ;
UPDATE academico.curso SET nome = 'C++ Básico' WHERE  id = 6 ;

SELECT * FROM academico.curso ORDER BY 1;
   
-- agora Precisamos atualizar a tabela teste.cursos_programacao de acorco com academico.curso
UPDATE teste.cursos_programacao SET nome_curso = nome
  FROM academico.curso WHERE teste.cursos_programacao.id_curso = academico.curso.id;
  
