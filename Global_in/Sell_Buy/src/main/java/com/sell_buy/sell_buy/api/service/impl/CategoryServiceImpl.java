package com.sell_buy.sell_buy.api.service.impl;

import com.sell_buy.sell_buy.api.service.CategoryService;
import com.sell_buy.sell_buy.db.entity.Category;
import com.sell_buy.sell_buy.db.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {
    private final CategoryRepository categoryRepository;

    @Override
    public List<Category> getRootCategories() {
        return categoryRepository.findAllBySuperIdIsNull();
    }

    @Override
    public List<Category> getSubCategories(Long catId) {
        return categoryRepository.findAllBySuperId(catId);
    }

    @Override
    public Category getCategory(Long catId) {
        return categoryRepository.findById(catId).orElse(null);
    }

    @Override
    public boolean existsById(Long catId) {
        return categoryRepository.existsById(catId);
    }

    @Override
    public Category getSuperCategory(Long catId) {
        return categoryRepository.findByCatId(catId);
    }

    @Override
    public List<Long> findAllSuperCategory(Long catId) {
        List<Long> superCategoryIds = new ArrayList<>();
        Long catIdTemp = catId;
        while (catIdTemp != null) {
            Category cat = categoryRepository.findByCatId(catIdTemp);
            if (cat == null) {
                break;
            }
            catIdTemp = cat.getSuperId();
            if (catIdTemp != null) {
                superCategoryIds.add(catIdTemp);
            }
        }
        Collections.sort(superCategoryIds);
        return superCategoryIds;
    }
}
