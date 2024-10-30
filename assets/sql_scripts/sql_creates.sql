-- SQL Create Script for Finance Tracker Application
-- Author: [Djiatsa Dunamis]
-- Date: [17/09/24]

-- Create the "users" table
CREATE TABLE users (
  -- The user "id" with email, name, and password
  id VARCHAR(255) NOT NULL PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL
);

-- Create the "accounts" table
CREATE TABLE accounts (
  -- The account "id" associated with user "user_id"
  id VARCHAR(255) NOT NULL PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL REFERENCES users(id),
  name VARCHAR(255) NOT NULL,
  salary DECIMAL(15, 2) NOT NULL -- Use DECIMAL for precise financial values
);

-- Create the "categories" table
CREATE TABLE categories (
  -- The category "id" linked to the user "user_id"
  id VARCHAR(255) NOT NULL PRIMARY KEY,
  userId VARCHAR(255) NOT NULL REFERENCES users(id),
  name VARCHAR(255) NOT NULL
);

-- Create the "budgets" table
CREATE TABLE budgets (
  -- The budget "id" by the user "user_id" for the category "category_id"
  id VARCHAR(255) NOT NULL PRIMARY KEY,
  userId VARCHAR(255) NOT NULL REFERENCES users(id),
  categoryId VARCHAR(255) NOT NULL REFERENCES categories(id),
  amount DECIMAL(15, 2) NOT NULL, -- Amount allocated to this budget
  created BIGINT NOT NULL -- Date the budget was created
);

-- Create the "transactions" table
CREATE TABLE transactions (
  -- The transaction "id" by the user "user_id" for an account "account_id"
  id VARCHAR(255) NOT NULL PRIMARY KEY,
  userId VARCHAR(255) NOT NULL REFERENCES users(id),
  accountId VARCHAR(255) NOT NULL REFERENCES accounts(id),
  amount DECIMAL(15, 2) NOT NULL, -- Transaction amount
  categoryId VARCHAR(255) NOT NULL REFERENCES categories(id),
  made BIGINT NOT NULL, -- Date of the transaction
  description TEXT NOT NULL -- Description of the transaction
);