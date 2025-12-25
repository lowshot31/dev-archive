package com.sell_buy.sell_buy.db.repository;

import com.sell_buy.sell_buy.db.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    Slice<Product> findAllByOrderByCreateDateDesc(Pageable pageable);

    Slice<Product> findByProdNameContainingOrProdDescContainingOrderByCreateDateDesc(Pageable pageable, String searchQuery, String searchQuery1);

    Slice<Product> findBySellerIdOrderByCreateDateDesc(Pageable pageable, Long seller_id);

    Page<Product> findByProdIdInOrderByCreateDateDesc(List<Long> prodIdList, Pageable pageable);

    Slice<Product> findByCategoryInOrderByCreateDateDesc(Pageable pageable, List<Long> categoryIds);

    Slice<Product> findByCategoryInAndProdNameContainingOrProdDescContainingOrderByCreateDateDesc(Pageable pageable, List<Long> categoryIds, String searchQuery, String searchQuery1);

    Slice<Product> findByCategoryInAndSellerIdOrderByCreateDateDesc(Pageable pageable, List<Long> categoryIds, Long sellerId);

    Product findByProdId(Long prodId);

    Product findByProdName(String prodName);

    Product findByProdNameAndSellerId(String prodName, Long sellerId);
}