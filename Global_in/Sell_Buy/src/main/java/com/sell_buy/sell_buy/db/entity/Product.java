package com.sell_buy.sell_buy.db.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.DynamicUpdate;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "prod_seq")
    @SequenceGenerator(name = "prod_seq", sequenceName = "product_seq", allocationSize = 1)
    @Column(name = "prod_id")
    private Long prodId;
    @Column(name = "seller_id")
    private Long sellerId;
    @Column(name = "prod_name")
    private String prodName;
    @Column(name = "prod_disc")
    private String prodDesc;
    @Column(name = "PRICE")
    private Integer price;
    @Column(name = "is_available")
    private Boolean isAvailable;
    @Column(name = "category_id")
    private Long category;
    // 0 직거래, 1 택배거래, 2 둘다
    @Column(name = "prod_type")
    private Integer prodType;
    @Column(name = "create_date")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createDate;
    @Column(name = "img_urls")
    private String imageUrls;
    @Transient // **@Transient 어노테이션 추가 (DB 컬럼 매핑 제외)**
    private List<String> listImageUrls; // **프론트엔드 전송용 List<String> 필드 추가**


    @PrePersist
    protected void onCreate() {
        if (createDate == null)
            createDate = LocalDateTime.now();
        System.out.println("createDate: " + createDate);
        if (isAvailable == null)
            isAvailable = true;
    }
}
