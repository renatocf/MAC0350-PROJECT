-- Default schema for authentication / authorization
CREATE SCHEMA IF NOT EXISTS auth;

--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS
auth.usuarios (
  id_usuario     uuid NOT NULL DEFAULT pgcrypto.gen_random_uuid(),
  email_usuario  varchar(256) NOT NULL,
  senha          varchar(256) NOT NULL,
  expira         date NOT NULL,

  CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
  CONSTRAINT sk_usuario UNIQUE (email_usuario)
);

CREATE TABLE IF NOT EXISTS
auth.perfis (
  id_perfil    bigserial,
  nome_perfil  varchar(64) NOT NULL,
  descricao    varchar(512),

  CONSTRAINT pk_perfil PRIMARY KEY (id_perfil),
  CONSTRAINT sk_perfil UNIQUE (nome_perfil)
);

CREATE TABLE IF NOT EXISTS
auth.servicos (
  id_servico       bigserial,
  caminho_servico  varchar(64) NOT NULL,
  descricao        varchar(512),

  CONSTRAINT pk_servico PRIMARY KEY (id_servico),
  CONSTRAINT sk_servico UNIQUE (caminho_servico)
);

--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS
auth.usuarios_possuem_perfis (
  id_papel    bigserial,
  id_usuario  uuid,
  id_perfil   bigint,
  expira      date NOT NULL,
  descricao   varchar(280),

  CONSTRAINT pk_papel PRIMARY KEY (id_papel),
  CONSTRAINT sk_papel UNIQUE (id_usuario, id_perfil),

  CONSTRAINT fk_usuario FOREIGN KEY (id_usuario)
    REFERENCES auth.usuarios (id_usuario)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
  CONSTRAINT fk_perfil FOREIGN KEY (id_perfil)
    REFERENCES auth.perfis (id_perfil)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS
auth.perfis_acessam_servicos (
  id_acesso   bigserial,
  id_perfil   bigint,
  id_servico  bigint,
  expira      date NOT NULL,
  descricao   varchar(280),

  CONSTRAINT pk_acesso PRIMARY KEY (id_acesso),
  CONSTRAINT sk_acesso UNIQUE (id_perfil, id_servico),

  CONSTRAINT fk_perfil FOREIGN KEY (id_perfil)
    REFERENCES auth.perfis (id_perfil)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
  CONSTRAINT fk_servico FOREIGN KEY (id_servico)
    REFERENCES auth.servicos (id_servico)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

--------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS
public.pessoas_geram_usuarios (
  id_pessoa     bigint,
  id_usuario    uuid,
  ultimo_login  date,

  CONSTRAINT pk_login PRIMARY KEY (id_pessoa, id_usuario),

  CONSTRAINT fk_pessoa FOREIGN KEY (id_pessoa)
    REFERENCES public.pessoas (id_pessoa)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
  CONSTRAINT fk_usuario FOREIGN KEY (id_usuario)
    REFERENCES auth.usuarios (id_usuario)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION
auth.cria_perfil_postgres()
  RETURNS trigger
  LANGUAGE PLPGSQL
AS $$
BEGIN
  EXECUTE format('CREATE ROLE %I', new.nome_perfil);
  EXECUTE format('GRANT %I TO web', new.nome_perfil);
  RETURN new;
END
$$;

DROP TRIGGER IF EXISTS garante_perfil_existe ON auth.perfis;
CREATE TRIGGER garante_perfil_existe
  AFTER INSERT OR UPDATE ON auth.perfis
  FOR EACH ROW
  EXECUTE PROCEDURE auth.cria_perfil_postgres();

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION
auth.encripta_senha()
  RETURNS trigger
  LANGUAGE PLPGSQL
AS $$
BEGIN
  IF tg_op = 'INSERT' OR new.senha <> old.senha THEN
    new.senha = pgcrypto.crypt(new.senha, pgcrypto.gen_salt('bf', 8));
  END IF;
  RETURN new;
END
$$;

DROP TRIGGER IF EXISTS encripta_senha ON auth.usuarios;
CREATE TRIGGER encripta_senha
  BEFORE INSERT OR UPDATE ON auth.usuarios
  FOR EACH ROW
  EXECUTE PROCEDURE auth.encripta_senha();

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION
auth.usuario_registrado(email varchar(256), senha varchar(256))
  RETURNS uuid
  LANGUAGE SQL
AS $$
  SELECT usuarios.id_usuario
    FROM auth.usuarios
   WHERE usuarios.email_usuario = usuario_registrado.email
     AND usuarios.senha = pgcrypto.crypt(usuario_registrado.senha,
                                         usuarios.senha);
$$;

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION
auth.usuario_acessa_servico(id_usuario uuid, caminho_servico varchar(64))
  RETURNS boolean
  LANGUAGE PLPGSQL
AS $$
BEGIN
  RETURN (
    SELECT count(*)
      FROM (
             SELECT 1
               FROM auth.usuarios
               JOIN auth.usuarios_possuem_perfis USING (id_usuario)
               JOIN auth.perfis_acessam_servicos USING (id_perfil)
               JOIN auth.servicos USING (id_servico)
              WHERE usuarios.id_usuario
											= usuario_acessa_servico.id_usuario
                AND servicos.caminho_servico
										  = usuario_acessa_servico.caminho_servico
              LIMIT 1
            ) AS b
  );
END
$$;

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION
public.autenticar(email varchar(256), senha varchar(256))
  RETURNS jwt.token
  LANGUAGE PLPGSQL
AS $$
DECLARE
  _id_usuario uuid;
  _token jwt.token;
BEGIN
  -- Check email and password
  _id_usuario := (SELECT auth.usuario_registrado(email, senha));

  -- Throw error for invalid password
  IF _id_usuario IS NULL THEN
    RAISE invalid_password USING message = 'Invalid user or password';
  END IF;

  -- Generate JWT
  SELECT jwt.sign(row_to_json(r), current_setting('app.settings.jwt_secret'))
    FROM (SELECT _id_usuario AS id_usuario,
                 current_setting('app.settings.web_role') AS role,
                 extract(epoch from now())::integer + 60*60 as exp) AS r
    INTO _token;

  RETURN _token;
END
$$;

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION
public.autorizar(caminho_servico varchar(64))
  RETURNS boolean
  LANGUAGE PLPGSQL
AS $$
DECLARE
  _id_usuario uuid;
BEGIN
  _id_usuario := (select current_setting('request.jwt.claim.id_usuario', true));

  RETURN auth.usuario_acessa_servico(_id_usuario, caminho_servico);
END
$$;

--------------------------------------------------------------------------------
