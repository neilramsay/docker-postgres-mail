#
# Pull secrets for dovecot, and postfix users.
#

# Copy of https://github.com/docker-library/postgres/blob/master/docker-entrypoint.sh#L4-L24
# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local default="${2:-}"
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    local val="$default"
    if [ "${!var:-}" ]; then
        val="${!var}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${!fileVar}")"
    fi
    export "$var"="$val"
    unset "$fileVar"
}

file_env POSTFIX_PASSWORD postfix
file_env DOVECOT_PASSWORD dovecot

(envsubst '$POSTFIX_PASSWORD:$DOVECOT_PASSWORD' | psql $POSTGRES_DB) <<EOF
ALTER ROLE postfix WITH PASSWORD '$POSTFIX_PASSWORD';
ALTER ROLE dovecot WITH PASSWORD '$DOVECOT_PASSWORD';
EOF
