--------------------------------------------------------------------------------
--- Insere disciplinas
--------------------------------------------------------------------------------

INSERT INTO
public.disciplinas(
  codigo_disciplina,
  creditos_aula,
  creditos_trabalho,
  carga_horaria,
  ativacao)
VALUES
( 'MAC0101', 4, 0, 60, '2015-01-01' ),
( 'MAC0110', 4, 0, 60, '1998-01-01' ),
( 'MAC0121', 4, 0, 60, '2015-01-01' ),
( 'MAC0350', 4, 0, 60, '2017-06-01' ),
( 'MAC0426', 4, 0, 60, '1998-01-01' );

--------------------------------------------------------------------------------
--- Insere pessoas em seus respectivos cargos
--------------------------------------------------------------------------------

INSERT INTO
public.pessoas(nome)
VALUES
( 'Jef'    ),
( 'Décio'  ),
( 'Renato' );

INSERT INTO
public.administradores(id_pessoa, nusp_administrador, data_inicio)
VALUES
(
  (SELECT id_pessoa FROM public.pessoas WHERE nome = 'Jef' LIMIT 1),
  '0000001',
  '2018-01-01'
);

INSERT INTO
public.professores(id_pessoa, nusp_professor, departamento)
VALUES
(
  (SELECT id_pessoa FROM public.pessoas WHERE nome = 'Jef' LIMIT 1),
  '0000001',
  'Departamento de Ciência da Computação'
);

INSERT INTO
public.alunos(id_pessoa, nusp_aluno, turma_ingresso)
VALUES
(
  (SELECT id_pessoa FROM public.pessoas WHERE nome = 'Décio' LIMIT 1),
  '0000002',
  '2015-03-01'
),
(
  (SELECT id_pessoa FROM public.pessoas WHERE nome = 'Renato' LIMIT 1),
  '0000003',
  '2012-03-01'
);

--------------------------------------------------------------------------------
--- Cria estrutura de autenticação
--------------------------------------------------------------------------------

INSERT INTO
auth.usuarios(email_usuario, senha, expira)
VALUES
( 'jef@ime.usp.br', '12345', '2019-01-01' ),
( 'decio@ime.usp.br', '12345', '2019-01-01' ),
( 'renatocf@ime.usp.br', '12345', '2019-01-01' );

INSERT INTO
public.pessoas_geram_usuarios(id_pessoa, id_usuario)
VALUES
(
  (SELECT id_pessoa FROM public.pessoas WHERE nome = 'Jef' LIMIT 1),
  (SELECT id_usuario FROM auth.usuarios WHERE email_usuario = 'jef@ime.usp.br')
),
(
  (SELECT id_pessoa FROM public.pessoas WHERE nome = 'Décio' LIMIT 1),
  (SELECT id_usuario FROM auth.usuarios WHERE email_usuario = 'decio@ime.usp.br')
),
(
  (SELECT id_pessoa FROM public.pessoas WHERE nome = 'Renato' LIMIT 1),
  (SELECT id_usuario FROM auth.usuarios WHERE email_usuario = 'renatocf@ime.usp.br')
);

INSERT INTO
auth.perfis(nome_perfil)
VALUES
( 'administrador' ), -- 1
( 'professor' ), -- 2
( 'aluno' ); -- 3

INSERT INTO
auth.servicos(caminho_servico)
VALUES
( '/'             ), -- 1
( '/index'        ), -- 2
( '/estrutura'    ), -- 3
( '/plano'        ), -- 4
( '/cruds'        ), -- 5
( '/cruds/index'  ), -- 6
( '/cruds/new'    ), -- 7
( '/cruds/edit'   ), -- 8
( '/cruds/show'   ); -- 9

INSERT INTO
auth.usuarios_possuem_perfis(id_usuario, id_perfil, expira)
VALUES
(
  (SELECT id_usuario FROM auth.usuarios WHERE email_usuario = 'jef@ime.usp.br'),
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'administrador'),
  '2019-01-01'
),
(
  (SELECT id_usuario FROM auth.usuarios WHERE email_usuario = 'jef@ime.usp.br'),
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'professor'),
  '2019-01-01'
),
(
  (SELECT id_usuario FROM auth.usuarios WHERE email_usuario = 'decio@ime.usp.br'),
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'aluno'),
  '2019-01-01'
),
(
  (SELECT id_usuario FROM auth.usuarios WHERE email_usuario = 'renatocf@ime.usp.br'),
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'aluno'),
  '2019-01-01'
);

INSERT INTO
auth.perfis_acessam_servicos(id_perfil, id_servico, expira)
VALUES
-- Administrador
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'administrador'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'administrador'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/index'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'administrador'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/estrutura'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'administrador'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/plano'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'administrador'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/cruds'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'administrador'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/cruds/index'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'administrador'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/cruds/new'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'administrador'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/cruds/edit'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'administrador'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/cruds/show'),
  '2019-01-01'
),
-- Professor
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'professor'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'professor'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/index'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'professor'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/estrutura'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'professor'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/plano'),
  '2019-01-01'
),
-- Estudante
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'aluno'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'aluno'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/index'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'aluno'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/estrutura'),
  '2019-01-01'
),
(
  (SELECT id_perfil FROM auth.perfis WHERE nome_perfil = 'aluno'),
  (SELECT id_servico FROM auth.servicos WHERE caminho_servico = '/plano'),
  '2019-01-01'
);
