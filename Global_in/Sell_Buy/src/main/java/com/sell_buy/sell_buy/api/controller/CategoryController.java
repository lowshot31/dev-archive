package com.sell_buy.sell_buy.api.controller;

import com.sell_buy.sell_buy.api.service.CategoryService;
import com.sell_buy.sell_buy.db.entity.Category;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;


    @GetMapping("/categories")
    public ResponseEntity<?> getCategories(@RequestParam(name = "catId", required = false) Long catId) {
        return ResponseEntity.ok(catId == null ? categoryService.getRootCategories() : categoryService.getSubCategories(catId));
    }

    @GetMapping("/category")
    public ResponseEntity<?> getCategory(@RequestParam(name = "catId") Long catId) {
        if (catId == null) {
            return ResponseEntity.badRequest().body("catId is required");
        }
        if (!categoryService.existsById(catId)) {
            return ResponseEntity.badRequest().body("Category not found");
        }
        return ResponseEntity.ok(categoryService.getCategory(catId));
    }

    @GetMapping("/category/super")
    public ResponseEntity<?> getSuperCategory(@RequestParam(name = "catId") Long catId) {
        if (catId == null) {
            return ResponseEntity.badRequest().body("catId is required");
        }
        if (!categoryService.existsById(catId)) {
            return ResponseEntity.badRequest().body("Category not found");
        }
        Category cat = categoryService.getSuperCategory(catId);
        if (cat == null) {
            return ResponseEntity.badRequest().body("Super category not found. Is it a root category?");
        }
        if (cat.getSuperId() == null) {
            return ResponseEntity.ok(cat);
        }

        List<Long> tempList = categoryService.findAllSuperCategory(catId);


        Map<String, List<Long>> responseMap = new HashMap<>();
        responseMap.put("dep1", Collections.singletonList(tempList.get(0)));
        responseMap.put("dep2", Collections.singletonList(tempList.get(1)));

        return ResponseEntity.status(200).body(responseMap);
    }


}
