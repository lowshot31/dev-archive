package com.sell_buy.sell_buy.db.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Table(name = "fav")
public class Favorite {
    @Column(name = "fav_id")
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "mem_seq")
    @SequenceGenerator(name = "mem_seq", sequenceName = "mem_seq", allocationSize = 1)
    private Long favId;
    @JoinColumn(name = "mem_id")
    @ManyToOne
    private Member member;
    @JoinColumn(name = "prod_id")
    @ManyToOne
    private Product product;
    @Column(name = "is_activated")
    private boolean isActivated;
}
