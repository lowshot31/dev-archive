package com.sell_buy.sell_buy.api.service.impl;

import com.sell_buy.sell_buy.api.service.ProductService;
import com.sell_buy.sell_buy.db.entity.Product;
import com.sell_buy.sell_buy.db.repository.*;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {


    private final ProductRepository productRepository;
    private final MemberRepository memberRepository;
    private final CategoryRepository categoryRepository;
    private final FavoriteRepository favoriteRepository;
    private final OrderRepository orderRepository;

    // This constructor is not needed because of Lombok's @RequiredArgsConstructor
    /*@Autowired
    public ProductServiceImpl(ProductRepository productRepository, MemberRepository memberRepository) {
        this.productRepository = productRepository;
        this.memberRepository = memberRepository;
    } */


    @Override
    public Product registerProduct(Product product) {
        return productRepository.save(product);
    }

    @Override
    public Product updateProduct(Product product) {
        if (productRepository.existsById(product.getProdId())) {
            return productRepository.save(product);

        } else {
            throw new EntityNotFoundException("Product with id " + product.getProdId() + " not found.");
        }
    }

    @Override
    public boolean existsById(Long prodId) {
        return productRepository.existsById(prodId);
    }

    @Override
    @Transactional
    public void deleteProduct(Long prodId) {
        if (orderRepository.findByProdId(prodId).getOrderStatus().equals("거래전")) {
            throw new IllegalStateException("Product with id " + prodId + " is already ordered.");
        }
        favoriteRepository.deleteByProductProdId(prodId);
        productRepository.deleteById(prodId);
    }

    @Override
    public Product getProductById(Long prodId) {
        return productRepository.findById(prodId).orElseThrow(() -> new EntityNotFoundException("Product with id " + prodId + " not found."));
    }

    @Override
    public Slice<Product> getProductList(int page, int size, Long catId, String searchQuery, String searchType) {
        Pageable pageable = PageRequest.of(page - 1, 18);

        List<Long> categoryIds = new ArrayList<>();
        if (catId != null) {
            categoryIds = categoryRepository.findAllLeafSubcategoryIds(catId);
        }

        if (searchType == null) {
            if (categoryIds.isEmpty()) {
                return productRepository.findAllByOrderByCreateDateDesc(pageable);
            }
            return productRepository.findByCategoryInOrderByCreateDateDesc(pageable, categoryIds);
        }

        switch (searchType) {
            case "title-desc":
                if (categoryIds.isEmpty()) {
                    return productRepository.findByProdNameContainingOrProdDescContainingOrderByCreateDateDesc(pageable, searchQuery, searchQuery);
                }
                return productRepository.findByCategoryInAndProdNameContainingOrProdDescContainingOrderByCreateDateDesc(pageable, categoryIds, searchQuery, searchQuery);

            case "seller":
                Long sellerId = memberRepository.findByNickname(searchQuery).getMemId();
                if (categoryIds.isEmpty()) {
                    return productRepository.findBySellerIdOrderByCreateDateDesc(pageable, sellerId);
                }
                return productRepository.findByCategoryInAndSellerIdOrderByCreateDateDesc(pageable, categoryIds, sellerId);

            default:
                if (categoryIds.isEmpty()) {
                    return productRepository.findAllByOrderByCreateDateDesc(pageable);
                }
                return productRepository.findByCategoryInOrderByCreateDateDesc(pageable, categoryIds);
        }
    }

    public Page<Product> favoriteProductList(List<Long> prodIdList, int page) {
        Pageable pageable = PageRequest.of(page - 1, 18);

        return productRepository.findByProdIdInOrderByCreateDateDesc(prodIdList, pageable);
    }

}
