REVOKE ALL ON DATABASE mail FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM PUBLIC;

CREATE ROLE services WITH NOLOGIN;
CREATE ROLE postfix WITH LOGIN IN GROUP services;
CREATE ROLE dovecot WITH LOGIN IN GROUP services;

GRANT CONNECT ON DATABASE mail TO services;
GRANT USAGE ON SCHEMA public TO services;

-- Modified from https://wiki.dovecot.org/AuthDatabase/SQL and
-- https://wiki.dovecot.org/HowTo/DovecotPostgresql
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
    username    TEXT NOT NULL,   -- user part of user@domain
    domain      TEXT NOT NULL,          -- domain part of user@domain
    password    TEXT NOT NULL           -- encrypted password
                    CHECK (password ~ '({SHA256-CRYPT}\$5\$)|({SHA512-CRYPT}\$6\$).+'),
    home        TEXT NOT NULL,          -- user's home directory
    mail        TEXT,                   -- alternative mail location
    uid         INTEGER NOT NULL,       -- user's User ID
    gid         INTEGER NOT NULL,       -- user's Group ID
    PRIMARY KEY (username, domain)
);
GRANT SELECT ON TABLE users TO services;


-- CREATE TABLE transport (
--     domain      TEXT NOT NULL,
-- )

-- From https://wiki.dovecot.org/HowTo/DovecotPostgresql
-- CREATE TABLE transport (
--   domain VARCHAR(128) NOT NULL,
--   transport VARCHAR(128) NOT NULL,
--   PRIMARY KEY (domain)
-- );
-- CREATE TABLE users (
--   userid VARCHAR(128) NOT NULL,
--   password VARCHAR(128),
--   realname VARCHAR(128),
--   uid INTEGER NOT NULL,
--   gid INTEGER NOT NULL,
--   home VARCHAR(128),
--   mail VARCHAR(255),
--   PRIMARY KEY (userid)
-- );
-- CREATE TABLE virtual (
--   address VARCHAR(255) NOT NULL,
--   userid VARCHAR(255) NOT NULL,
--   PRIMARY KEY (address)
-- );
-- create view postfix_mailboxes as
--   select userid, home||'/' as mailbox from users
--   union all
--   select domain as userid, 'dummy' as mailbox from transport;
-- create view postfix_virtual as
--   select userid, userid as address from users
--   union all
--   select userid, address from virtual;
