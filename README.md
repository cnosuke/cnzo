# cnzo
Gyazo server and application for my own.
Cnzo runs on Docker and uses AWS S3 as its file storage.
As default, files are serverside-encrypted with AES256 and stored with educed_redundancy storage class on S3.

## How to use

1. Setup `.env`
Copy `server_config/env.sample` to `server_config/.env` and write AWS credentials which granted to access S3 bucket

2. Modify your Gyazo.app

Cnzo needs credentials with `key` parameter from your Gyazo.app.
Authorized `key` parameters should be set on `AUTHORIZE_KEY` ENV of `.env`.

3. Run Cnzo with Docker

```
% docker build -t cnzo .
% docker run -d -p 80:8080 cnzo
```

If you're using reverse proxy like nginx, bind your server port like `-p 8080:8080` and write proxy settings in your nginx cofigs.

## LICENSE

MIT License

Copyright (C) 2015 Shinnosuke Takeda (cnosuke)
