alter table MEMBER
    add password varchar2(300) not null;

alter table MEMBER
    add constraint check_member_password check (length(password) >= 12 and length(password) <= 40);

alter table MEMBER
    add constraint check_member_password_allowed_characters check (regexp_like(password,
                                                                               '^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{12,}$'));