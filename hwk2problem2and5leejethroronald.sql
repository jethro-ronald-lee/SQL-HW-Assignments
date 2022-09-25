-- Jethro Ronald Lee
-- CS 3200
-- Homework 3

-- Problem 2

-- 2.a) How many databases are created by the script?
	-- 3 databases are created by this script
-- 2.b) List the database names and the tables created for each database.
	-- Database name: AP
		-- Tables created: general_ledger_accounts, invoice_archive, invoice_line_items, invoices, terms, vendor_contacts, vendors
	-- Database name: EX
		-- Tables created: active_invoices, color_sample, customers, date_sample, departments, employees, float_sample, null_sample, paid_invoices, projects, string_sample
    -- Database name: OM
		-- Tables created: customers, items, order_details, orders
-- 2.c) How many records does the script insert into the om.order_details table?
	-- 47 records
-- 2.d) How many records does the script insert into the ap.invoices table?
	-- 114 records
-- 2.e) How many records does the script insert into the ap.vendors table?
	-- 122 records
-- 2.f) Is there a foreign key between the ap.invoices and the ap.vendors table?
	-- Yes; vendor_id
-- 2.g) How many foreign keys does the ap.vendors table have?
	-- 2 foreign keys
-- 2.h) What is the primary key for the om.customers table?
	-- customer_id
-- 2.i) Write a SQL command that will retrieve all values for all fields from the orders table
	SELECT * FROM om.orders;
-- 2.j) Write a SQL command that will retrieve the fields: title and artist from the om.items table
	SELECT title, artist FROM om.items;
    
-- Problem 5

-- 5.a) How many tables are created by the script?
	-- 11 tables
-- 5.b) List the names of the tables created for the Chinook database.
	-- Album
    -- Artist
    -- Customer
    -- Employee
    -- Genre
    -- Invoice
    -- InvoiceLine
    -- MediaType
    -- Playlist
    -- PlaylistTrack
    -- Track
-- 5.c) How many records does the script insert into the Album table?
	-- 347 records
-- 5.d) What is the primary key for the Album table?
	-- AlbumId is the primary key for the Album table
-- 5.e) Write a SQL SELECT command to retrieve all data from all columns and rows in the Artist table.
	SELECT * FROM Artist;
-- 5.f) Write a SQL SELECT command to retrieve the fields FirstName, LastName and Title from the Employee table
	SELECT FirstName, LastName, Title FROM Employee;
