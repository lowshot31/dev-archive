package com.sell_buy.sell_buy.common.utills;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sell_buy.sell_buy.db.entity.Product;

import java.util.ArrayList;
import java.util.List;

public class CommonUtils {
    public static final String FILE_EXTENSION_SEPARATOR = ".";
    private static final ObjectMapper objectMapper;

    static {
        objectMapper = new ObjectMapper();
    }

    public static String getFileName(String originalFileName) {
        int fileExtensionIndex = originalFileName.lastIndexOf(FILE_EXTENSION_SEPARATOR);
        return originalFileName.substring(0, fileExtensionIndex); //파일 이름
    }

    public static String buildFileName(String originalFileName) {
        int fileExtensionIndex = originalFileName.lastIndexOf(FILE_EXTENSION_SEPARATOR); //파일 확장자 구분선
        String fileExtension = originalFileName.substring(fileExtensionIndex); //파일 확장자
        String fileName = originalFileName.substring(0, fileExtensionIndex); //파일 이름
        String now = String.valueOf(System.currentTimeMillis()); //파일 업로드 시간

        return fileName + "_" + now + fileExtension;
    }

    public static List<Product> processProductList(List<Product> productList) throws JsonProcessingException {
        List<Product> processedProductList = new ArrayList<>();
        for (Product product : productList) {
            String imageUrlsJson = product.getImageUrls();
            List<String> imageUrls = new ArrayList<>();
            if (imageUrlsJson != null && !imageUrlsJson.isEmpty()) {
                try {
                    imageUrls = objectMapper.readValue(imageUrlsJson, objectMapper.getTypeFactory().constructCollectionType(List.class, String.class));
                    if (!imageUrls.isEmpty()) {
                        product.setImageUrls(imageUrls.get(0)); // 기존 코드: 첫 번째 이미지 URL 만 imageUrls 에 설정 (썸네일 용도)
                        product.setListImageUrls(imageUrls); // **새로운 코드: listImageUrls 에 전체 이미지 URL 목록 설정**
                    } else {
                        product.setImageUrls(null);
                        product.setListImageUrls(null); // listImageUrls 도 null 설정 (일관성 유지)
                    }
                } catch (JsonProcessingException e) {
                    System.err.println("JSON 파싱 오류: " + e.getMessage() + " - 상품 ID: " + product.getProdId());
                    product.setImageUrls(null);
                    product.setListImageUrls(null); // listImageUrls 도 null 설정 (일관성 유지)
                }
            } else {
                product.setImageUrls(null);
                product.setListImageUrls(null); // listImageUrls 도 null 설정 (일관성 유지)
            }
            processedProductList.add(product);
        }
        return processedProductList;
    }
}
