DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS session_ids;

CREATE TABLE users (
    id          INTEGER PRIMARY KEY,
    username    TEXT NOT NULL,
    userpass    TEXT NOT NULL,
    avatar      TEXT NOT NULL,
    create_date TEXT NOT NULL
    );

CREATE TABLE messages (
    id          INTEGER PRIMARY KEY,
    owner_id    INTEGER NOT NULL,
    body        TEXT    NOT NULL,
    send_date   TEXT    NOT NULL
    );

CREATE TABLE session_ids (
    id          INTEGER PRIMARY KEY,
    owner_id    INTEGER NOT NULL,
    create_date TEXT    NOT NULL,
    session_key TEXT    NOT NULL
    );