// FILE START
// FILE PATH: src\main\java\com\sell_buy\sell_buy\db\entity\Board.java
package com.sell_buy.sell_buy.db.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name = "NOTICE")
public class Board {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "NOTIC_ID", nullable = false)
    private Long noticId;

    // String 타입에서 Long 타입으로 변경
    @Column(name = "UPLOADER_ID")
    private Long uploaderId;

    @Column(name = "IS_ACTIVATED", nullable = false)
    private boolean isActivated;

    @Column(name = "NOTIC_TITLE", nullable = false)
    private String title;

    @Column(name = "NOTIC_CONTENT", nullable = false, length = 4000)
    private String content;

    @Column(name = "CREATE_DATE", nullable = false, updatable = false)
    private LocalDateTime createDate;

    @Column(name = "UPDATE_DATE", nullable = false)
    private LocalDateTime updateDate;

    @Transient
    private String searchCondition;
    @Transient
    private String searchKeyword;

    @PrePersist
    public void prePersist() {
        this.isActivated = true;
        this.createDate = LocalDateTime.now();
        this.updateDate = LocalDateTime.now();
    }

    @PreUpdate
    public void preUpdate() {
        this.updateDate = LocalDateTime.now();
    }
}
