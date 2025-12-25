package com.sell_buy.sell_buy.api.service;

import com.sell_buy.sell_buy.db.entity.Category;

import java.util.List;

public interface CategoryService {
    List<Category> getRootCategories();

    List<Category> getSubCategories(Long catId);

    Category getCategory(Long catId);

    boolean existsById(Long catId);

    Category getSuperCategory(Long catId);

    List<Long> findAllSuperCategory(Long catId);
}
