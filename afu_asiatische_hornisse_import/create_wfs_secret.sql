CREATE SECRET http_auth (
    TYPE HTTP,
    EXTRA_HTTP_HEADERS MAP {
        'Authorization': ${wfs_credentials_encoded}
    }
);