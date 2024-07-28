#!/bin/bash
if [ ! -f .env ]; then
	cp ./files/.env.example .env
fi
if [ ! -f ./secrets/admin_password.secret ]; then
	touch ./secrets/admin_password.secret
fi
if [ ! -f ./secrets/db_password.secret ]; then
	touch ./secrets/db_password.secret
fi
if [ ! -f ./secrets/email_password.secret ]; then
	touch ./secrets/email_password.secret
fi
if [ ! -f ./secrets/secret_key.secret ]; then
	touch ./secrets/secret_key.secret
fi
mkdir -p ./data/consume/