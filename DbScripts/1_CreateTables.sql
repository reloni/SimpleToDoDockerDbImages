CREATE TABLE TaskUser (
UUID UUID PRIMARY KEY,
FirebaseId varchar(50) NOT NULL UNIQUE,
CreationDate timestamptz NOT NULL,
FirstName varchar(255),
LastName varchar(255),
Email varchar(255) unique NOT NULL
);

CREATE UNIQUE INDEX FirebaseIdIndex ON TaskUser (FirebaseId);

CREATE TABLE Task (
UUID UUID PRIMARY KEY,
Completed BOOL NOT NULL,
Description varchar(255) NOT NULL,
Notes varchar(4000),
CreationDate timestamptz NOT NULL,
TargetDate timestamptz,
Owner UUID REFERENCES TaskUser (UUID) ON DELETE CASCADE
);
