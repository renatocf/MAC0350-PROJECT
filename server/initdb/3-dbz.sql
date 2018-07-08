-- Default schema for the business logic
CREATE SCHEMA IF NOT EXISTS public;

--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS
public.disciplinas (
  id_disciplina      bigserial,
  codigo_disciplina  character(7) NOT NULL,
  creditos_aula      integer NOT NULL,
  creditos_trabalho  integer NOT NULL,
  carga_horaria      integer NOT NULL,
  ativacao           date NOT NULL,
  desativacao        date,
  nome               varchar(280),
  ementa             text,

  CONSTRAINT pk_disciplina PRIMARY KEY (id_disciplina),
  CONSTRAINT sk_disciplina UNIQUE (codigo_disciplina),

  CONSTRAINT check_creditos_aula
    CHECK (creditos_aula >= 0),
  CONSTRAINT check_creditos_trabalho
    CHECK (creditos_trabalho >= 0),
  CONSTRAINT check_carga_horaria
    CHECK (carga_horaria >= 0)
);

--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS
public.prerequisitos (
  id_disciplina    bigint,
  id_prerequisito  bigint,
  total            boolean,

  CONSTRAINT pk_prerequisito PRIMARY KEY (id_disciplina, id_prerequisito),

	CONSTRAINT fk_disciplina FOREIGN KEY (id_disciplina)
    REFERENCES public.disciplinas (id_disciplina)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
	CONSTRAINT fk_prerequisito FOREIGN KEY (id_prerequisito)
    REFERENCES public.disciplinas (id_disciplina)
      ON DELETE CASCADE
      ON UPDATE CASCADE,

	CONSTRAINT check_prerequisitos
    CHECK (id_disciplina IS DISTINCT FROM id_prerequisito)
);

--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS
public.grade_obrigatoria (
  id_disciplina          bigint,
  ano_grade_obrigatoria  date,

  CONSTRAINT fk_grade_obrigatoria PRIMARY KEY (
    id_disciplina, ano_grade_obrigatoria),

  CONSTRAINT fk_disciplina FOREIGN KEY (id_disciplina)
    REFERENCES public.disciplinas (id_disciplina)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS
public.grade_optativa (
  id_disciplina       bigint,
  ano_grade_optativa  date,
  eletiva             boolean,

  CONSTRAINT fk_grade_optativa PRIMARY KEY (
    id_disciplina, ano_grade_optativa),

  CONSTRAINT fk_disciplina FOREIGN KEY (id_disciplina)
    REFERENCES public.disciplinas (id_disciplina)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS
public.trilhas (
  id_trilha           serial,
  codigo_trilha       character(10) NOT NULL,
  nome                varchar(100) NOT NULL,
  descricao           varchar(280),
  minimo_disciplinas  integer,
  minimo_modulos      integer,

  CONSTRAINT pk_trilha PRIMARY KEY (id_trilha),
  CONSTRAINT sk_trilha UNIQUE (codigo_trilha),

  CONSTRAINT check_minimo_disciplinas
    CHECK (minimo_disciplinas >= 0),
  CONSTRAINT check_minimo_modulos
    CHECK (minimo_modulos >= 0)
);

CREATE TABLE IF NOT EXISTS
public.modulos (
  id_modulo           serial,
  codigo_modulo       varchar(10) NOT NULL,
  minimo_disciplinas  integer,
  id_trilha           integer,

  CONSTRAINT pk_modulo PRIMARY KEY (id_modulo),
  CONSTRAINT sk_modulo UNIQUE (codigo_modulo),

  CONSTRAINT fk_trilha FOREIGN KEY (id_trilha)
    REFERENCES public.trilhas (id_trilha)
      ON DELETE CASCADE
      ON UPDATE CASCADE,

  CONSTRAINT check_minimo_disciplinas
    CHECK (minimo_disciplinas >= 0)
);

--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS
public.optativas_compoem_modulos (
  id_disciplina       bigint,
  ano_grade_optativa  date,
  id_modulo           integer,

  CONSTRAINT pk_composicao PRIMARY KEY (
    id_disciplina, ano_grade_optativa, id_modulo),

  CONSTRAINT fk_grade_optativa FOREIGN KEY (id_disciplina, ano_grade_optativa)
    REFERENCES public.grade_optativa (id_disciplina, ano_grade_optativa)
      ON DELETE RESTRICT
      ON UPDATE CASCADE,
  CONSTRAINT fk_modulo FOREIGN KEY (id_modulo)
    REFERENCES public.modulos (id_modulo)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);

--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS
public.pessoas (
  id_pessoa   bigserial,
  cpf         character(11),
  nome        varchar(280) NOT NULL,
  nascimento  date,

  CONSTRAINT pk_pessoa PRIMARY KEY (id_pessoa),
  CONSTRAINT sk_pessoa UNIQUE (cpf)
);

CREATE TABLE IF NOT EXISTS
public.administradores (
  id_pessoa           bigint,
  nusp_administrador  varchar(10),
  data_inicio         date NOT NULL,
  data_fim            date,

  CONSTRAINT pk_administrador PRIMARY KEY (id_pessoa, nusp_administrador),

  CONSTRAINT fk_pessoa FOREIGN KEY (id_pessoa)
    REFERENCES public.pessoas (id_pessoa)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS
public.professores (
  id_pessoa       bigint,
  nusp_professor  varchar(10),
  departamento    varchar(100),
  sala            varchar(20),

  CONSTRAINT pk_professor PRIMARY KEY (id_pessoa, nusp_professor),

  CONSTRAINT fk_pessoa FOREIGN KEY (id_pessoa)
    REFERENCES public.pessoas (id_pessoa)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS
public.alunos (
  id_pessoa       bigint,
  nusp_aluno      varchar(10),
  turma_ingresso  date,

  CONSTRAINT pk_aluno PRIMARY KEY (id_pessoa, nusp_aluno),

  CONSTRAINT fk_pessoa FOREIGN KEY (id_pessoa)
    REFERENCES public.pessoas (id_pessoa)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS
public.professores_oferecem_disciplinas (
  id_oferecimento  bigserial,
  id_pessoa        bigint NOT NULL,
  nusp_professor   varchar(10) NOT NULL,
  id_disciplina    bigint NOT NULL,
  ano_semestre     numeric(5, 1) NOT NULL,

  CONSTRAINT pk_oferecimento PRIMARY KEY (id_oferecimento),
  CONSTRAINT sk_oferecimento UNIQUE (
    id_pessoa, nusp_professor, id_disciplina, ano_semestre),

  CONSTRAINT fk_professor FOREIGN KEY (id_pessoa, nusp_professor)
    REFERENCES public.professores (id_pessoa, nusp_professor)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
  CONSTRAINT fk_disciplina FOREIGN KEY (id_disciplina)
    REFERENCES public.disciplinas (id_disciplina)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS
public.alunos_planejam_disciplinas (
  id_plano       bigserial,
  id_pessoa      bigint NOT NULL,
  nusp_aluno     varchar(10) NOT NULL,
  id_disciplina  bigint NOT NULL,
  num_plano      bigint NOT NULL,

  CONSTRAINT pk_plano PRIMARY KEY (id_plano),
  CONSTRAINT sk_plano UNIQUE (id_pessoa, nusp_aluno,
                              id_disciplina, num_plano),

  CONSTRAINT fk_aluno FOREIGN KEY (id_pessoa, nusp_aluno)
    REFERENCES public.alunos (id_pessoa, nusp_aluno)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
  CONSTRAINT fk_disciplina FOREIGN KEY (id_disciplina)
    REFERENCES public.disciplinas (id_disciplina)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS
public.alunos_cursam_disciplinas (
  id_execucao      bigserial,
  id_pessoa        bigint NOT NULL,
  nusp_aluno       varchar(10) NOT NULL,
  id_oferecimento  bigint NOT NULL,
  nota             numeric(3, 1),

  CONSTRAINT pk_execucao PRIMARY KEY (id_execucao),
  CONSTRAINT sk_execucao UNIQUE (id_pessoa, nusp_aluno, id_oferecimento),

  CONSTRAINT fk_aluno FOREIGN KEY (id_pessoa, nusp_aluno)
    REFERENCES public.alunos (id_pessoa, nusp_aluno)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
  CONSTRAINT fk_oferecimento FOREIGN KEY (id_oferecimento)
    REFERENCES public.professores_oferecem_disciplinas (id_oferecimento)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS
public.administradores_coordenam_grades (
  id_pessoa           bigint,
  nusp_administrador  varchar(10),
  ano_grade           date,
  inicio              date NOT NULL,
  fim                 date,

  CONSTRAINT pk_coordenacao  PRIMARY KEY (
    id_pessoa, nusp_administrador, ano_grade),

  CONSTRAINT fk_administrador FOREIGN KEY (id_pessoa, nusp_administrador)
    REFERENCES public.administradores (id_pessoa, nusp_administrador)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

--------------------------------------------------------------------------------
