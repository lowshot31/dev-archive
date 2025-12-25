package com.sell_buy.sell_buy.api.service;

import com.sell_buy.sell_buy.db.entity.Favorite;
import com.sell_buy.sell_buy.db.entity.Product;
import org.springframework.data.domain.Page;

public interface FavoriteService {
    Favorite addFavorite(Long memId, Long prodId);

    void deactivateFavorite(Long memId, Long prodId);

    void activateFavorite(Long memId, Long prodId);

    boolean isFavorite(Long memId, Long prodId);

    Page<Product> getFavoriteProductList(Long memId, int page, int size);

    boolean wasFavorite(Long memId, Long prodId);

    void deleteFavorite(Long memId, Long prodId);
}
