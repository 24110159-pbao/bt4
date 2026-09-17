
package vn.iotstar.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.*;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import vn.iotstar.dto.ProductDTO;
import vn.iotstar.dto.ProductResponse;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Product;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IProductService;

@RestController
@RequestMapping("/api/product")
public class ProductAPIController {

    @Autowired
    private IProductService productService;

    @Autowired
    private ICategoryService categoryService;

    private final Path uploadPath =
            Paths.get("uploads/products");

    // GET ALL
    @GetMapping
    public ResponseEntity<?> getAllProduct() {

        List<Product> products = productService.findAll();
        List<ProductDTO> result = new ArrayList<>();

        for (Product product : products) {
            result.add(convertToDTO(product));
        }

        return ResponseEntity.ok(
                new ProductResponse(
                        true,
                        "Lấy danh sách Product thành công",
                        result
                )
        );
    }

    // GET ONE
    @GetMapping("/{id}")
    public ResponseEntity<?> getProduct(
            @PathVariable Long id) {

        Optional<Product> optional =
                productService.findById(id);

        if (optional.isEmpty()) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(new ProductResponse(
                            false,
                            "Không tìm thấy Product",
                            null
                    ));
        }

        return ResponseEntity.ok(
                new ProductResponse(
                        true,
                        "Lấy Product thành công",
                        convertToDTO(optional.get())
                )
        );
    }

    // CREATE
    @PostMapping
    public ResponseEntity<?> addProduct(
            @RequestParam String productName,
            @RequestParam BigDecimal unitPrice,
            @RequestParam BigDecimal discount,
            @RequestParam String description,
            @RequestParam Long categoryId,
            @RequestParam Integer quantity,
            @RequestParam Short status,
            @RequestParam(value = "imageFile",
                    required = false)
            MultipartFile imageFile) {

        if (productName == null ||
                productName.trim().isEmpty()) {

            return badRequest("Tên Product không được trống");
        }

        productName = productName.trim();

        if (productService
                .findByProductName(productName)
                .isPresent()) {

            return badRequest("Product đã tồn tại");
        }

        Optional<Category> optionalCategory =
                categoryService.findById(categoryId);

        if (optionalCategory.isEmpty()) {
            return badRequest("Không tìm thấy Category");
        }

        if (unitPrice == null ||
                unitPrice.compareTo(BigDecimal.ZERO) < 0) {
            return badRequest("Đơn giá không hợp lệ");
        }

        if (discount == null ||
                discount.compareTo(BigDecimal.ZERO) < 0) {
            return badRequest("Giảm giá không hợp lệ");
        }

        if (quantity == null || quantity < 0) {
            return badRequest("Số lượng không hợp lệ");
        }

        Product product = new Product();

        product.setProductName(productName);
        product.setUnitPrice(unitPrice);
        product.setDiscount(discount);
        product.setDescription(description);
        product.setQuantity(quantity);
        product.setStatus(status);
        product.setCategory(optionalCategory.get());

        try {
            if (imageFile != null &&
                    !imageFile.isEmpty()) {
                product.setImages(saveImage(imageFile));
            }

            product = productService.save(product);

            return ResponseEntity.ok(
                    new ProductResponse(
                            true,
                            "Thêm Product thành công",
                            convertToDTO(product)
                    )
            );

        } catch (IOException e) {
            return serverError("Lỗi upload ảnh Product");
        }
    }

    // UPDATE
    @PutMapping("/{id}")
    public ResponseEntity<?> updateProduct(
            @PathVariable Long id,
            @RequestParam String productName,
            @RequestParam BigDecimal unitPrice,
            @RequestParam BigDecimal discount,
            @RequestParam String description,
            @RequestParam Long categoryId,
            @RequestParam Integer quantity,
            @RequestParam Short status,
            @RequestParam(value = "imageFile",
                    required = false)
            MultipartFile imageFile) {

        Optional<Product> optionalProduct =
                productService.findById(id);

        if (optionalProduct.isEmpty()) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(new ProductResponse(
                            false,
                            "Không tìm thấy Product",
                            null
                    ));
        }

        if (productName == null ||
                productName.trim().isEmpty()) {
            return badRequest("Tên Product không được trống");
        }

        productName = productName.trim();

        Optional<Product> oldProduct =
                productService.findByProductName(productName);

        if (oldProduct.isPresent() &&
                !oldProduct.get().getProductId().equals(id)) {
            return badRequest("Tên Product đã tồn tại");
        }

        Optional<Category> optionalCategory =
                categoryService.findById(categoryId);

        if (optionalCategory.isEmpty()) {
            return badRequest("Không tìm thấy Category");
        }

        if (unitPrice == null ||
                unitPrice.compareTo(BigDecimal.ZERO) < 0) {
            return badRequest("Đơn giá không hợp lệ");
        }

        if (discount == null ||
                discount.compareTo(BigDecimal.ZERO) < 0) {
            return badRequest("Giảm giá không hợp lệ");
        }

        if (quantity == null || quantity < 0) {
            return badRequest("Số lượng không hợp lệ");
        }

        Product product = optionalProduct.get();

        product.setProductName(productName);
        product.setUnitPrice(unitPrice);
        product.setDiscount(discount);
        product.setDescription(description);
        product.setQuantity(quantity);
        product.setStatus(status);
        product.setCategory(optionalCategory.get());

        try {
            // Không chọn ảnh mới thì giữ ảnh cũ
            if (imageFile != null &&
                    !imageFile.isEmpty()) {
                product.setImages(saveImage(imageFile));
            }

            product = productService.save(product);

            return ResponseEntity.ok(
                    new ProductResponse(
                            true,
                            "Cập nhật Product thành công",
                            convertToDTO(product)
                    )
            );

        } catch (IOException e) {
            return serverError("Lỗi upload ảnh Product");
        }
    }

    // DELETE
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteProduct(
            @PathVariable Long id) {

        Optional<Product> optional =
                productService.findById(id);

        if (optional.isEmpty()) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(new ProductResponse(
                            false,
                            "Không tìm thấy Product",
                            null
                    ));
        }

        Product product = optional.get();

        productService.delete(product);

        return ResponseEntity.ok(
                new ProductResponse(
                        true,
                        "Xóa Product thành công",
                        convertToDTO(product)
                )
        );
    }

    // SAVE IMAGE
    private String saveImage(
            MultipartFile imageFile) throws IOException {

        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        String originalName =
                imageFile.getOriginalFilename();

        String extension = "";

        if (originalName != null &&
                originalName.contains(".")) {
            extension = originalName.substring(
                    originalName.lastIndexOf(".")
            ).toLowerCase();
        }

        String fileName =
                UUID.randomUUID() + extension;

        Path filePath = uploadPath.resolve(fileName);

        Files.copy(
                imageFile.getInputStream(),
                filePath,
                StandardCopyOption.REPLACE_EXISTING
        );

        return fileName;
    }

    // CONVERT ENTITY TO DTO
    private ProductDTO convertToDTO(Product product) {

        ProductDTO dto = new ProductDTO();

        dto.setProductId(product.getProductId());
        dto.setProductName(product.getProductName());
        dto.setImages(product.getImages());
        dto.setUnitPrice(product.getUnitPrice());
        dto.setDiscount(product.getDiscount());
        dto.setDescription(product.getDescription());
        dto.setQuantity(product.getQuantity());
        dto.setStatus(product.getStatus());

        if (product.getCategory() != null) {
            dto.setCategoryId(
                    product.getCategory().getCategoryId()
            );

            dto.setCategoryName(
                    product.getCategory().getCategoryName()
            );
        }

        return dto;
    }

    private ResponseEntity<?> badRequest(String message) {
        return ResponseEntity.badRequest().body(
                new ProductResponse(false, message, null)
        );
    }

    private ResponseEntity<?> serverError(String message) {
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new ProductResponse(false, message, null));
    }
}