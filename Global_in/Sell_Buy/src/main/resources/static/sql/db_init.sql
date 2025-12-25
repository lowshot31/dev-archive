CREATE TABLE member
(
    mem_id      NUMBER(19)    NOT NULL,
    img_id      NUMBER(19)    NULL,
    login_id    VARCHAR2(20)  NOT NULL,
    user_name   VARCHAR2(12)  NOT NULL,
    nickname    VARCHAR2(30)  NOT NULL,
    address     VARCHAR2(210) NULL,
    email       VARCHAR2(80)  NOT NULL,
    create_date TIMESTAMP     NOT NULL,
    phone_num   VARCHAR2(20)  NOT NULL,
    auth        NUMBER(1)     NOT NULL
);

CREATE TABLE auction
(
    prod_id        NUMBER(19) NOT NULL,
    starting_price NUMBER(10) NOT NULL,
    currunt_price  NUMBER(10) NOT NULL,
    instant_price  NUMBER(10) NULL,
    end_time       TIMESTAMP  NOT NULL,
    starting_time  TIMESTAMP  NOT NULL,
    is_enabled     NUMBER(1)  NOT NULL
);

CREATE TABLE bid
(
    bid_id      NUMBER(19) NOT NULL,
    bid_amount  NUMBER(9)  NOT NULL,
    bid_time    TIMESTAMP  NOT NULL,
    price_after NUMBER(10) NULL,
    bidder_id   NUMBER(19) NOT NULL,
    prod_id     NUMBER(19) NOT NULL
);

CREATE TABLE point_charge
(
    charge_id      NUMBER(19)   NOT NULL,
    charger_id     NUMBER(19)   NOT NULL,
    amount         NUMBER(6)    NOT NULL,
    charge_date    TIMESTAMP    NOT NULL,
    balance_after  NUMBER(10)   NOT NULL,
    method         VARCHAR2(10) NULL,
    transaction_id VARCHAR2(30) NULL
);

CREATE TABLE point
(
    mem_id  NUMBER(19) NOT NULL,
    balance NUMBER(10) NOT NULL
);

CREATE TABLE point_transfered
(
    transfer_id   NUMBER(19) NOT NULL,
    sender_id     NUMBER(19) NOT NULL,
    receiver_id   NUMBER(19) NOT NULL,
    amount        NUMBER(10) NOT NULL,
    transfer_date TIMESTAMP  NOT NULL,
    transfer_type NUMBER(1)  NULL
);

CREATE TABLE prod_order
(
    order_id         NUMBER(19)    NOT NULL,
    transfer_id      NUMBER(19)    NULL,
    prod_id          NUMBER(19)    NOT NULL,
    seller_id        NUMBER(19)    NOT NULL,
    buyer_id         NUMBER(19)    NOT NULL,
    receiver_name    VARCHAR2(12)  NOT NULL,
    receiver_address VARCHAR2(120) NOT NULL,
    receiver_phone   VARCHAR2(20)  NOT NULL,
    order_status     NUMBER(1)     NOT NULL,
    created_date     TIMESTAMP     NOT NULL,
    delivered_date   TIMESTAMP     NULL
);

CREATE TABLE category
(
    category_id       NUMBER(19)   NOT NULL,
    name              VARCHAR2(50) NOT NULL,
    path              VARCHAR2(50) NULL,
    super_category_id NUMBER(19)   NULL
);

CREATE TABLE product
(
    prod_id      NUMBER(19)     NOT NULL,
    seller_id    NUMBER(19)     NOT NULL,
    prod_name    VARCHAR2(120)  NOT NULL,
    prod_disc    VARCHAR2(1200) NULL,
    is_auction   NUMBER(1)      NOT NULL,
    price        NUMBER(10)     NOT NULL,
    create_date  TIMESTAMP      NOT NULL,
    is_avaliable NUMBER(1)      NOT NULL,
    category_id  NUMBER(19)     NOT NULL
);

CREATE TABLE delivery
(
    order_id    NUMBER(19)   NOT NULL,
    carrier     VARCHAR2(15) NULL,
    tracking_no VARCHAR2(15) NULL
);

CREATE TABLE notification
(
    noti_id     NUMBER(19)    NOT NULL,
    user_id     NUMBER(19)    NOT NULL,
    noti_type   NUMBER(1)     NOT NULL,
    noti_cont   VARCHAR2(120) NOT NULL,
    noti_expire TIMESTAMP     NOT NULL,
    is_read     NUMBER(1)     NOT NULL
);

CREATE TABLE notice
(
    notic_id      NUMBER(19)     NOT NULL,
    uploader_id   NUMBER(19)     NULL,
    is_activated  NUMBER(1)      NOT NULL,
    notic_title   VARCHAR2(120)  NOT NULL,
    notic_content VARCHAR2(4000) NOT NULL,
    create_date   TIMESTAMP      NOT NULL,
    update_date   TIMESTAMP      NOT NULL
);

CREATE TABLE chatroom
(
    chatr_id   NUMBER(19) NOT NULL,
    is_enabled NUMBER(1)  NOT NULL
);

CREATE TABLE MSG
(
    chat_id   NUMBER(19)     NOT NULL,
    chatr_id  NUMBER(19)     NOT NULL,
    sender_id NUMBER(19)     NOT NULL,
    chat_cont VARCHAR2(3000) NOT NULL,
    chat_date TIMESTAMP      NOT NULL,
    is_read   NUMBER(1)      NOT NULL
);

CREATE TABLE userChat_rel
(
    rel_id   NUMBER(19) NOT NULL,
    chatr_id NUMBER(19) NOT NULL,
    user_id  NUMBER(19) NOT NULL
);

CREATE TABLE image
(
    img_id   NUMBER(19)    NOT NULL,
    img_path VARCHAR2(500) NOT NULL,
    user_id  NUMBER(19)    NULL
);

CREATE TABLE prod_img
(
    rel_id  NUMBER(19) NOT NULL,
    img_id  NUMBER(19) NOT NULL,
    prod_id NUMBER(19) NOT NULL
);

CREATE TABLE notic_img
(
    rel_id   NUMBER(19) NOT NULL,
    notic_id NUMBER(19) NOT NULL,
    img_id   NUMBER(19) NOT NULL
);

ALTER TABLE member
    MODIFY create_date TIMESTAMP DEFAULT SYSTIMESTAMP;
ALTER TABLE notice
    MODIFY create_date TIMESTAMP DEFAULT SYSTIMESTAMP;
ALTER TABLE notice
    MODIFY update_date TIMESTAMP DEFAULT SYSTIMESTAMP;

ALTER TABLE member
    MODIFY (create_date TIMESTAMP DEFAULT SYSTIMESTAMP);

ALTER TABLE prod_order
    MODIFY (created_date TIMESTAMP DEFAULT SYSTIMESTAMP);

ALTER TABLE product
    MODIFY (create_date TIMESTAMP DEFAULT SYSTIMESTAMP);

ALTER TABLE notice
    MODIFY (create_date TIMESTAMP DEFAULT SYSTIMESTAMP);

ALTER TABLE notice
    MODIFY (update_date TIMESTAMP DEFAULT SYSTIMESTAMP);

ALTER TABLE member
    ADD CONSTRAINT PK_USER PRIMARY KEY (
                                        mem_id
        );

ALTER TABLE auction
    ADD CONSTRAINT PK_AUCTION PRIMARY KEY (
                                           prod_id
        );

ALTER TABLE bid
    ADD CONSTRAINT PK_BID PRIMARY KEY (
                                       bid_id
        );

ALTER TABLE point_charge
    ADD CONSTRAINT PK_POINT_CHARGE PRIMARY KEY (
                                                charge_id
        );

ALTER TABLE point
    ADD CONSTRAINT PK_POINT PRIMARY KEY (
                                         mem_id
        );

ALTER TABLE point_transfered
    ADD CONSTRAINT PK_POINT_TRANSFERED PRIMARY KEY (
                                                    transfer_id
        );

ALTER TABLE prod_order
    ADD CONSTRAINT PK_ORDER PRIMARY KEY (
                                         order_id
        );

ALTER TABLE category
    ADD CONSTRAINT PK_CATEGORY PRIMARY KEY (
                                            category_id
        );

ALTER TABLE product
    ADD CONSTRAINT PK_PRODUCT PRIMARY KEY (
                                           prod_id
        );

ALTER TABLE delivery
    ADD CONSTRAINT PK_DELIVERY PRIMARY KEY (
                                            order_id
        );

ALTER TABLE notification
    ADD CONSTRAINT PK_NOTIFICATION PRIMARY KEY (
                                                noti_id
        );

ALTER TABLE notice
    ADD CONSTRAINT PK_NOTICE PRIMARY KEY (
                                          notic_id
        );

ALTER TABLE chatroom
    ADD CONSTRAINT PK_CHATROOM PRIMARY KEY (
                                            chatr_id
        );

ALTER TABLE MSG
    ADD CONSTRAINT PK_MSG PRIMARY KEY (
                                       chat_id
        );

ALTER TABLE userChat_rel
    ADD CONSTRAINT PK_USERCHAT_REL PRIMARY KEY (
                                                rel_id
        );

ALTER TABLE image
    ADD CONSTRAINT PK_IMAGE PRIMARY KEY (
                                         img_id
        );

ALTER TABLE prod_img
    ADD CONSTRAINT PK_PROD_IMG PRIMARY KEY (
                                            rel_id
        );

ALTER TABLE notic_img
    ADD CONSTRAINT PK_NOTIC_IMG PRIMARY KEY (
                                             rel_id
        );

ALTER TABLE member
    ADD CONSTRAINT FK_image_TO_user_1 FOREIGN KEY (
                                                   img_id
        )
        REFERENCES image (
                          img_id
            );

ALTER TABLE auction
    ADD CONSTRAINT FK_product_TO_auction_1 FOREIGN KEY (
                                                        prod_id
        )
        REFERENCES product (
                            prod_id
            );

ALTER TABLE bid
    ADD CONSTRAINT FK_user_TO_bid_1 FOREIGN KEY (
                                                 bidder_id
        )
        REFERENCES member (
                           mem_id
            );

ALTER TABLE bid
    ADD CONSTRAINT FK_auction_TO_bid_1 FOREIGN KEY (
                                                    prod_id
        )
        REFERENCES auction (
                            prod_id
            );

ALTER TABLE point_charge
    ADD CONSTRAINT FK_point_TO_point_charge_1 FOREIGN KEY (
                                                           charger_id
        )
        REFERENCES point (
                          mem_id
            );

ALTER TABLE point
    ADD CONSTRAINT FK_user_TO_point_1 FOREIGN KEY (
                                                   mem_id
        )
        REFERENCES member (
                           mem_id
            );

ALTER TABLE point_transfered
    ADD CONSTRAINT FK_point_TO_point_transfered_1 FOREIGN KEY (
                                                               sender_id
        )
        REFERENCES point (
                          mem_id
            );

ALTER TABLE point_transfered
    ADD CONSTRAINT FK_point_TO_point_transfered_2 FOREIGN KEY (
                                                               receiver_id
        )
        REFERENCES point (
                          mem_id
            );

ALTER TABLE prod_order
    ADD CONSTRAINT FK_point_transfered_TO_order_1 FOREIGN KEY (
                                                               transfer_id
        )
        REFERENCES point_transfered (
                                     transfer_id
            );

ALTER TABLE prod_order
    ADD CONSTRAINT FK_product_TO_order_1 FOREIGN KEY (
                                                      prod_id
        )
        REFERENCES product (
                            prod_id
            );

ALTER TABLE prod_order
    ADD CONSTRAINT FK_product_TO_order_2 FOREIGN KEY (
                                                      seller_id
        )
        REFERENCES member (
                           mem_id
            );

ALTER TABLE prod_order
    ADD CONSTRAINT FK_user_TO_order_1 FOREIGN KEY (
                                                   buyer_id
        )
        REFERENCES member (
                           mem_id
            );

ALTER TABLE category
    ADD CONSTRAINT FK_category_TO_category_1 FOREIGN KEY (
                                                          super_category_id
        )
        REFERENCES category (
                             category_id
            );

ALTER TABLE product
    ADD CONSTRAINT FK_user_TO_product_1 FOREIGN KEY (
                                                     seller_id
        )
        REFERENCES member (
                           mem_id
            );

ALTER TABLE product
    ADD CONSTRAINT FK_category_TO_product_1 FOREIGN KEY (
                                                         category_id
        )
        REFERENCES category (
                             category_id
            );

ALTER TABLE delivery
    ADD CONSTRAINT FK_order_TO_delivery_1 FOREIGN KEY (
                                                       order_id
        )
        REFERENCES prod_order (
                               order_id
            );

ALTER TABLE notification
    ADD CONSTRAINT FK_user_TO_notification_1 FOREIGN KEY (
                                                          user_id
        )
        REFERENCES member (
                           mem_id
            );

ALTER TABLE notice
    ADD CONSTRAINT FK_user_TO_notice_1 FOREIGN KEY (
                                                    uploader_id
        )
        REFERENCES member (
                           mem_id
            );

ALTER TABLE MSG
    ADD CONSTRAINT FK_chatroom_TO_MSG_1 FOREIGN KEY (
                                                     chatr_id
        )
        REFERENCES chatroom (
                             chatr_id
            );

ALTER TABLE MSG
    ADD CONSTRAINT FK_user_TO_MSG_1 FOREIGN KEY (
                                                 sender_id
        )
        REFERENCES member (
                           mem_id
            );

ALTER TABLE userChat_rel
    ADD CONSTRAINT FK_chatroom_TO_userChat_rel_1 FOREIGN KEY (
                                                              chatr_id
        )
        REFERENCES chatroom (
                             chatr_id
            );

ALTER TABLE userChat_rel
    ADD CONSTRAINT FK_user_TO_userChat_rel_1 FOREIGN KEY (
                                                          user_id
        )
        REFERENCES member (
                           mem_id
            );

ALTER TABLE image
    ADD CONSTRAINT FK_user_TO_image_1 FOREIGN KEY (
                                                   user_id
        )
        REFERENCES member (
                           mem_id
            );

ALTER TABLE prod_img
    ADD CONSTRAINT FK_image_TO_prod_img_1 FOREIGN KEY (
                                                       img_id
        )
        REFERENCES image (
                          img_id
            );

ALTER TABLE prod_img
    ADD CONSTRAINT FK_product_TO_prod_img_1 FOREIGN KEY (
                                                         prod_id
        )
        REFERENCES product (
                            prod_id
            );

ALTER TABLE notic_img
    ADD CONSTRAINT FK_notice_TO_notic_img_1 FOREIGN KEY (
                                                         notic_id
        )
        REFERENCES notice (
                           notic_id
            );

ALTER TABLE notic_img
    ADD CONSTRAINT FK_image_TO_notic_img_1 FOREIGN KEY (
                                                        img_id
        )
        REFERENCES image (
                          img_id
            );

-- user 테이블에 대한 시퀀스
CREATE SEQUENCE mem_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- auction 테이블에 대한 시퀀스
CREATE SEQUENCE auction_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- bid 테이블에 대한 시퀀스
CREATE SEQUENCE bid_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- point_charge 테이블에 대한 시퀀스
CREATE SEQUENCE point_charge_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- point 테이블에 대한 시퀀스
CREATE SEQUENCE point_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- point_transfered 테이블에 대한 시퀀스
CREATE SEQUENCE point_transfered_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- order 테이블에 대한 시퀀스
CREATE SEQUENCE order_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- category 테이블에 대한 시퀀스
CREATE SEQUENCE category_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- product 테이블에 대한 시퀀스
CREATE SEQUENCE product_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- delivery 테이블에 대한 시퀀스
CREATE SEQUENCE delivery_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- notification 테이블에 대한 시퀀스
CREATE SEQUENCE notification_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- notice 테이블에 대한 시퀀스
CREATE SEQUENCE notice_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- chatroom 테이블에 대한 시퀀스
CREATE SEQUENCE chatroom_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- MSG 테이블에 대한 시퀀스
CREATE SEQUENCE msg_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- userChat_rel 테이블에 대한 시퀀스
CREATE SEQUENCE userchat_rel_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- image 테이블에 대한 시퀀스
CREATE SEQUENCE image_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- prod_img 테이블에 대한 시퀀스
CREATE SEQUENCE prod_img_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- notic_img 테이블에 대한 시퀀스
CREATE SEQUENCE notic_img_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

ALTER TABLE member
    ADD CONSTRAINT unique_login_id UNIQUE (login_id);
ALTER TABLE member
    ADD CONSTRAINT unique_email UNIQUE (email);
ALTER TABLE product
    ADD CONSTRAINT chk_is_avaliable CHECK (is_avaliable IN (0, 1));
ALTER TABLE member
    ADD CONSTRAINT chk_auth CHECK (role IN (0, 1));
ALTER TABLE notification
    ADD CONSTRAINT chk_is_read CHECK (is_read IN (0, 1));
ALTER TABLE MSG
    ADD CONSTRAINT MSG_chk_is_read CHECK (is_read IN (0, 1));
ALTER TABLE auction
    MODIFY (is_enabled NUMBER(1) DEFAULT 1);

ALTER TABLE point_transfered
    MODIFY (transfer_type NUMBER(1) DEFAULT 0);

ALTER TABLE product
    MODIFY (is_auction NUMBER(1) DEFAULT 0);
ALTER TABLE category
    MODIFY (super_category_id NUMBER(19) DEFAULT NULL);
ALTER TABLE notification
    MODIFY (is_read NUMBER(1) DEFAULT 0);
ALTER TABLE notice
    MODIFY is_activated DEFAULT 1;
ALTER TABLE product
    MODIFY is_avaliable DEFAULT 1;
ALTER TABLE product
    MODIFY prod_disc DEFAULT '';
ALTER TABLE point_charge
    MODIFY method DEFAULT NULL;
ALTER TABLE point_charge
    MODIFY transaction_id DEFAULT NULL;
ALTER TABLE auction
    MODIFY is_enabled DEFAULT 1;
ALTER TABLE member
    MODIFY address DEFAULT NULL;
ALTER TABLE member
    MODIFY img_id DEFAULT NULL;
ALTER TABLE member
    MODIFY role DEFAULT 0;

-- user 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE member
    MODIFY mem_id DEFAULT MEM_SEQ.NEXTVAL;

-- auction 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE auction
    MODIFY prod_id DEFAULT auction_seq.NEXTVAL;

-- bid 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE bid
    MODIFY bid_id DEFAULT bid_seq.NEXTVAL;

-- point_charge 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE point_charge
    MODIFY charge_id DEFAULT point_charge_seq.NEXTVAL;

-- point 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE point
    MODIFY mem_id DEFAULT point_seq.NEXTVAL;

-- point_transfered 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE point_transfered
    MODIFY transfer_id DEFAULT point_transfered_seq.NEXTVAL;

-- order 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE prod_order
    MODIFY order_id DEFAULT order_seq.NEXTVAL;

-- category 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE category
    MODIFY category_id DEFAULT category_seq.NEXTVAL;

-- product 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE product
    MODIFY prod_id DEFAULT product_seq.NEXTVAL;

-- delivery 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE delivery
    MODIFY order_id DEFAULT delivery_seq.NEXTVAL;

-- notification 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE notification
    MODIFY noti_id DEFAULT notification_seq.NEXTVAL;

-- notice 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE notice
    MODIFY notic_id DEFAULT notice_seq.NEXTVAL;

-- chatroom 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE chatroom
    MODIFY chatr_id DEFAULT chatroom_seq.NEXTVAL;

-- MSG 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE MSG
    MODIFY chat_id DEFAULT msg_seq.NEXTVAL;

-- userChat_rel 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE userChat_rel
    MODIFY rel_id DEFAULT userchat_rel_seq.NEXTVAL;

-- image 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE image
    MODIFY img_id DEFAULT image_seq.NEXTVAL;

-- prod_img 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE prod_img
    MODIFY rel_id DEFAULT prod_img_seq.NEXTVAL;

-- notic_img 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE notic_img
    MODIFY rel_id DEFAULT notic_img_seq.NEXTVAL;

-- userChat_rel 테이블에 시퀀스를 디폴트값으로 설정
ALTER TABLE userChat_rel
    MODIFY rel_id DEFAULT userchat_rel_seq.NEXTVAL;
