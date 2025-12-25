package com.sell_buy.sell_buy.db.repository;

import com.sell_buy.sell_buy.db.entity.Favorite;
import com.sell_buy.sell_buy.db.entity.Product;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FavoriteRepository extends JpaRepository<Favorite, Long> {

    void deleteByMemberMemIdOrProductProdId(Long memId, Long prodId);

    boolean existsByMemberMemIdAndProductProdId(Long memId, Long prodId);

    @Transactional
    @Modifying
    @Query("update Favorite f set f.isActivated = :isActivated where f.member.memId = :memId and f.product.prodId = :prodId")
    void updateIsActivatedByMemIdAndProdId(@Param("memId") Long memId, @Param("prodId") Long prodId, @Param("isActivated") boolean b);

    @Query("SELECT CASE WHEN COUNT(f) > 0 THEN true ELSE false END FROM Favorite f WHERE f.member.memId = :memId AND f.product.prodId = :prodId AND f.isActivated = :isActivated")
    boolean existsByMemIdAndProdIdAndIsActivated(@Param("memId") Long memId, @Param("prodId") Long prodId, @Param("isActivated") boolean isActivated);

    @Query("select f from Favorite  f where f.member.memId = :memId and f.isActivated = true")
    Page<Favorite> findFavoriteList(@Param("memId") Long memId, Pageable pageable);

    @Query("select f.product.prodId from Favorite f where f.member.memId = :memId")
    List<Long> findProdIdListByMemId(@Param("memId") Long memId);

    void deleteByProductProdId(Long prodId);

    void deleteByMemberMemId(Long memId);

    @Query("SELECT f.product FROM Favorite f WHERE f.member.memId = :memId AND f.isActivated = true ORDER BY f.product.createDate DESC")
    Page<Product> findActivatedProduct(Long memId, boolean isActivated, Pageable pageable);
}