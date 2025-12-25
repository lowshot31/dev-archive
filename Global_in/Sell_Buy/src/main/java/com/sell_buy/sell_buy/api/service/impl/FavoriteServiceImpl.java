package com.sell_buy.sell_buy.api.service.impl;

import com.sell_buy.sell_buy.api.service.FavoriteService;
import com.sell_buy.sell_buy.db.entity.Favorite;
import com.sell_buy.sell_buy.db.entity.Member;
import com.sell_buy.sell_buy.db.entity.Product;
import com.sell_buy.sell_buy.db.repository.FavoriteRepository;
import com.sell_buy.sell_buy.db.repository.MemberRepository;
import com.sell_buy.sell_buy.db.repository.ProductRepository;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class FavoriteServiceImpl implements FavoriteService {

    private final FavoriteRepository favRepo;
    private final ProductRepository productRepository;
    private final MemberRepository memberRepository;

    @Override
    public Favorite addFavorite(Long memId, Long prodId) {
        Member member = memberRepository.findById(memId).orElseThrow();
        Product product = productRepository.findById(prodId).orElseThrow();
        Favorite fav = Favorite.builder()
                .member(member)
                .product(product)
                .build();

        return favRepo.save(fav);
    }

    @Override
    public void deactivateFavorite(Long memId, Long prodId) {
        favRepo.updateIsActivatedByMemIdAndProdId(memId, prodId, false);
    }

    @Override
    public void activateFavorite(Long memId, Long prodId) {
        favRepo.updateIsActivatedByMemIdAndProdId(memId, prodId, true);
    }

    @Override
    public boolean isFavorite(Long memId, Long prodId) {
        return favRepo.existsByMemIdAndProdIdAndIsActivated(memId, prodId, true);
    }

    @Override
    public boolean wasFavorite(Long memId, Long prodId) {
        return favRepo.existsByMemberMemIdAndProductProdId(memId, prodId);
    }

    @Override
    public Page<Product> getFavoriteProductList(Long memId, int page, int size) {
        Pageable pageable = PageRequest.of(page - 1, size);

        return favRepo.findActivatedProduct(memId, true, pageable);
    }

    @Override
    public void deleteFavorite(Long memId, Long prodId) {
        if (prodId == null) {
            favRepo.deleteByMemberMemId(memId);
        } else if (memId == null) {
            favRepo.deleteByProductProdId(prodId);
        } else {
            favRepo.deleteByMemberMemIdOrProductProdId(memId, prodId);
        }
    }
}