create database if not exists parksmart;
use parksmart;

create table clients (
  id          int not null auto_increment,
  doc_type    varchar(20) not null,
  doc_number  varchar(30) not null,
  full_name   varchar(100) not null,
  phone       varchar(20),
  email       varchar(100),
  status      varchar(20) not null default 'active',
  created_at  timestamp not null default current_timestamp,
  updated_at  timestamp not null default current_timestamp
              on update current_timestamp,
  constraint pk_clients primary key (id),
  constraint uq_clients_doc unique (doc_number)
);

create table rates (
  id          int not null auto_increment,
  name        varchar(100) not null,
  amount_hour int not null,
  status      varchar(20) not null default 'active',
  created_at  timestamp not null default current_timestamp,
  updated_at  timestamp not null default current_timestamp
              on update current_timestamp,
  constraint pk_rates primary key (id)
);

create table employees (
  id          int not null auto_increment,
  full_name   varchar(100) not null,
  role        varchar(50) not null,
  status      varchar(20) not null default 'active',
  created_at  timestamp not null default current_timestamp,
  updated_at  timestamp not null default current_timestamp
              on update current_timestamp,
  constraint pk_employees primary key (id)
);

create table vehicles (
  id          int not null auto_increment,
  client_id   int not null,
  plate       varchar(20) not null,
  brand       varchar(100),
  description varchar(200),
  status      varchar(20) not null default 'active',
  created_at  timestamp not null default current_timestamp,
  updated_at  timestamp not null default current_timestamp
              on update current_timestamp,
  constraint pk_vehicles primary key (id),
  constraint uq_vehicles_plate unique (plate),
  constraint fk_client_vehicles
    foreign key (client_id) references clients(id)
);

create table subscriptions (
  id          int not null auto_increment,
  client_id   int not null,
  vehicle_id  int not null,
  rate_id     int not null,
  start_date  date not null,
  end_date    date not null,
  status      varchar(20) not null default 'active',
  created_at  timestamp not null default current_timestamp,
  updated_at  timestamp not null default current_timestamp
              on update current_timestamp,
  constraint pk_subscriptions primary key (id),
  constraint fk_client_subscriptions
    foreign key (client_id) references clients(id),
  constraint fk_vehicle_subscriptions
    foreign key (vehicle_id) references vehicles(id),
  constraint fk_rate_subscriptions
    foreign key (rate_id) references rates(id)
);

create table shifts (
  id           int not null auto_increment,
  employee_id  int not null,
  start_time   timestamp not null default current_timestamp,
  end_time     timestamp null,
  status       varchar(20) not null default 'open',
  created_at   timestamp not null default current_timestamp,
  updated_at   timestamp not null default current_timestamp
               on update current_timestamp,
  constraint pk_shifts primary key (id),
  constraint fk_employee_shifts
    foreign key (employee_id) references employees(id)
);

create table entries (
  id          int not null auto_increment,
  vehicle_id  int not null,
  shift_id    int not null,
  entry_time  timestamp not null default current_timestamp,
  exit_time   timestamp null,
  status      varchar(20) not null default 'active',
  created_at  timestamp not null default current_timestamp,
  updated_at  timestamp not null default current_timestamp
              on update current_timestamp,
  constraint pk_entries primary key (id),
  constraint fk_vehicle_entries
    foreign key (vehicle_id) references vehicles(id),
  constraint fk_shift_entries
    foreign key (shift_id) references shifts(id)
);

create table tickets (
  id          int not null auto_increment,
  entry_id    int not null,
  name        varchar(100) not null,
  status      varchar(20) not null default 'pending',
  created_at  timestamp not null default current_timestamp,
  updated_at  timestamp not null default current_timestamp
              on update current_timestamp,
  constraint pk_tickets primary key (id),
  constraint uq_tickets_entry unique (entry_id),
  constraint fk_entry_tickets
    foreign key (entry_id) references entries(id)
);

create table payments (
  id          bigint not null auto_increment,
  ticket_id   int not null,
  rate_id     int not null,
  method      varchar(50) not null,
  amount      bigint not null,
  pay_date    date not null,
  reference   varchar(100),
  status      varchar(20) not null default 'completed',
  created_at  timestamp not null default current_timestamp,
  updated_at  timestamp not null default current_timestamp
              on update current_timestamp,
  constraint pk_payments primary key (id),
  constraint fk_ticket_payments
    foreign key (ticket_id) references tickets(id),
  constraint fk_rate_payments
    foreign key (rate_id) references rates(id)
);
