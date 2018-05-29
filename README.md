Postgres-Mail
=============

Creates an example Postgres database, which can be used to demonstrate Dovecot, and Postfix configuration using the Postgresql database for email recipient definition.

## Environment Variables
* Specific to this image
    * `POSTFIX_PASSWORD` - postfix database user password (defaults to "postfix"). Can also be supplied by file.
    * `DOVECOT_PASSWORD` - dovecot database user password (defaults to "dovecot"). Can also be supplied by file.
    * `DOVECOT_PASSWORD_FILE` - path to file containing postfix database user password.
    * `POSTFIX_PASSWORD_FILE` - path to file containing dovecot database user password.
*  [Inherited from Postgres official image](https://github.com/docker-library/docs/tree/master/postgres#environment-variables)
    * `POSTGRES_DB` - Postgres database to be created for storing Dovecot/Postfix configuration.
    * `POSTGRES_PASSWORD` - Postgres database password
    * ...

Additional [environment variables are inherited](https://github.com/docker-library/docs/tree/master/postgres#environment-variables) from the Postgres Docker Image

## Database Schema
The database schema focuses on providing virtual domains, with virtual aliases. i.e. `user@example.com` as a destination, and `alias@example.com` aliasing to `user@example.com`.

* Creates `service` group, with
    - `dovecot` user
    - `postfix` user
* Create `users` table for both Dovecot, and Postfix:
    - [password database](https://wiki.dovecot.org/PasswordDatabase)
    - [user database](https://wiki.dovecot.org/UserDatabase)
    - [virtual users](https://wiki.dovecot.org/VirtualUsers)
* Create `virtual` table for [Postfix virtual domain delivery](http://www.postfix.org/virtual.8.html)
