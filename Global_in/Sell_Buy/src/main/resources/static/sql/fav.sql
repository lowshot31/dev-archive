CREATE table fav
(
    fav_id       number(19) primary key not null,
    mem_id       number(19)             not null,
    prod_id      number(19)             not null,
    is_activated number(1) default 1    not null
);
alter table fav
    add constraint fk_fav_user foreign key (mem_id) references MEMBER (MEM_ID);
alter table fav
    add constraint fk_fav_prod foreign key (prod_id) references PRODUCT (PROD_ID);
create sequence fav_seq start with 1 increment by 1 nocache nocycle;
alter table fav
    modify fav_id default fav_seq.nextval;
alter table fav
    add constraint check_fav_activated check (is_activated in (0, 1));


alter table fav
    add prod_id number(19) not null;
