CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

insert into taskuser (UUID, FirebaseId, CreationDate, FirstName, LastName, email)
values (uuid_generate_v4(), 'THRbOVbGimVbhrJ5gUqzgzOmNLf2', current_timestamp, 'John', 'Doe', 'reloni@ya.ru');

insert into taskuser (UUID, FirebaseId, CreationDate, FirstName, LastName, email, password)
values (uuid_generate_v4(), 'testid', current_timestamp, 'Jane', 'Doe', 'jane@domain.com', 'ololo')
