REVOKE ALL ON DATABASE mail FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM PUBLIC;

CREATE ROLE services WITH NOLOGIN;
CREATE ROLE postfix WITH LOGIN IN GROUP services;
CREATE ROLE dovecot WITH LOGIN IN GROUP services;

GRANT CONNECT ON DATABASE mail TO services;
GRANT USAGE ON SCHEMA public TO services;

-- Modified from https://wiki.dovecot.org/AuthDatabase/SQL
--
-- Note that the password scheme should be SHA256-CRYPT ($5$),
-- or SHA512-CRYPT ($6$), and set with the default_pass_scheme
-- These can be generated using doveadm pw -s SHA512-CRYPT
--
-- The password_query expects the password column
-- The user_query expects the home, uid, and gid
--
-- Queries can be minimised with 'prefetching', see
-- https://wiki.dovecot.org/UserDatabase/Prefetch#SQL_example
CREATE TABLE users (
    username VARCHAR(64) NOT NULL UNIQUE,
    domain VARCHAR(64) NOT NULL,
    password VARCHAR(128) NOT NULL
             CHECK (password ~ '({SHA256-CRYPT}\$5\$)|({SHA512-CRYPT}\$6\$).+'),
    home VARCHAR(255) NOT NULL,
    mail VARCHAR(255),
    uid INTEGER NOT NULL,
    gid INTEGER NOT NULL
);
GRANT SELECT ON TABLE users TO services;
