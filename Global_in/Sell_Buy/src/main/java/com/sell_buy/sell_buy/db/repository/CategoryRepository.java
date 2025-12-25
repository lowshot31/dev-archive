package com.sell_buy.sell_buy.db.repository;

import com.sell_buy.sell_buy.db.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {


    List<Category> findAllBySuperId(Long catId);

    List<Category> findAllBySuperIdIsNull();

    @Query("SELECT c.catId FROM Category c WHERE c.superId = :catId")
    List<Long> findSubcategoryIds(Long catId);

    default List<Long> findAllLeafSubcategoryIds(Long catId) {
        List<Long> subcategoryIds = findSubcategoryIds(catId);
        List<Long> leafCategoryIds = new ArrayList<>();
        if (subcategoryIds.isEmpty()) {
            leafCategoryIds.add(catId);
        } else {
            for (Long subCatId : subcategoryIds) {
                leafCategoryIds.addAll(findAllLeafSubcategoryIds(subCatId));
            }
        }
        return leafCategoryIds;
    }

    Category findByCatId(Long catId);

}
