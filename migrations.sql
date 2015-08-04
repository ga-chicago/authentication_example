CREATE DATABASE auth_example;

\c auth_example

CREATE TABLE user_accounts (id SERIAL PRIMARY KEY, name VARCHAR(255), password_hash VARCHAR(255), password_salt VARCHAR(255));
