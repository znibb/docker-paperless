Document management using paperless-ngx hosted via Docker Compose

This setup assumes that you're already running:
  - A [Traefik](https://github.com/znibb/docker-traefik) reverse-proxy
  - An [Authentik](https://github.com/znibb/docker-authentik) Identity Provider

**Table of contents**
- [1. Authentik Setup](#1-authentik-setup)
- [2. Docker Setup](#2-docker-setup)
- [3. Application Setup](#3-application-setup)
- [4. Maintenance](#4-maintenance)
  - [4.1. Update file names](#41-update-file-names)
  - [4.2. Change logo](#42-change-logo)

## 1. Authentik Setup
1. Open the Authentik Admin Interface
2. Go to `Applications->Providers` and click `Create`
3. Select `OAuth2/OpenID Provider` and click `Next`
4. Enter the following:
   - Name `Paperless Provider`
   - Authorization flow: implicit-consent
   - Redirect URIs/Origins: `https://paperless.DOMAIN.COM/accounts/oidc/authentik/login/callback/`
5. Take note of `Client ID` and `Client Secret`, you will use these when setting up your `.env` file later
6. Click `Finish`
7. Go to `Application->Applications` and click `Create`
8. Enter `Name`/`Slug` as `Paperless`/`paperless` and for `Provider` select the recently created `Paperless Provider`
9. Click `Create`

## 2. Docker Setup
1. Initialize config by running init.sh: `./init.sh`
2. Input personal information into `.env`
3. Create passwords for the admin user and database and put them in `./secrets/admin_password.secret` and `./secrets/db_password.secret` respectively
4. Put your email password in `./secrets/email_password.secret`, if you're using Gmail this is your App Password
5. Create a random Paperless secret key and put it in `./secrets/secret_key.secret`, just face-roll something long
6. Run `docker compose up` and check logs

## 3. Application Setup
1. Go to `https://paperless.DOMAIN.COM` and log in with your Authentik user, this will fail due to permissions but will serve to create your user in Paperless
2. Go directly to the Paperless login page by accessing the local ip of your server (remember to add `:8000`) and log in with username `admin` and password according to what you set in `./secrets/admin_password.secret`
3. In the left menu under the `ADMINISTRATION` section go to `Users & Groups`
4. Create a group with basic permissions and name it e.g. `Basic`, needs at least `View` permission for `UISettings` to be able to access the service (suggested to give all permissions and remove `AppConfig`, `User`, `Group` and all but `View` for `UISettings`)
5. (Optionally) Create a group called `All` that has ALL permissions
6. Edit your User and add it to the recently created group
7. Try to access the FQDN again and this time you should be presented with the Dashboard view of Paperless

Whenever a new user logs in via Authentik you will have to log in as an admin user and manually assign the new user to the `Basic` group before they can access Paperless

## 4. Maintenance
### 4.1. Update file names
If you change the `PAPERLESS_FILENAME_FORMAT` and want to update existing filenames to the new format run `docker compose exec paperless document_renamer`
### 4.2. Change logo
1. Go to `Configuration` and upload an icon using the `Application Logo` pane
2. Open `docker-compose.yml` and change the `PAPERLESS_APP_LOGO` environment variable to `/logo/FILENAME`