
package vn.iotstar.controller;

import java.io.IOException;
import java.nio.file.*;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import vn.iotstar.dto.CategoryResponse;
import vn.iotstar.entity.Category;
import vn.iotstar.service.ICategoryService;

@RestController
@RequestMapping("/api/category")
public class CategoryAPIController {

    @Autowired
    private ICategoryService categoryService;

    private final Path uploadPath =
            Paths.get("uploads/categories");

    // GET ALL
    @GetMapping
    public ResponseEntity<?> getAllCategory() {

        List<Category> categories =
                categoryService.findAll();

        return ResponseEntity.ok(
                new CategoryResponse(
                        true,
                        "Lấy danh sách thành công",
                        categories
                )
        );
    }

    // GET ONE
    @GetMapping("/{id}")
    public ResponseEntity<?> getCategory(
            @PathVariable Long id) {

        Optional<Category> optional =
                categoryService.findById(id);

        if (optional.isEmpty()) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(new CategoryResponse(
                            false,
                            "Không tìm thấy Category",
                            null
                    ));
        }

        return ResponseEntity.ok(
                new CategoryResponse(
                        true,
                        "Thành công",
                        optional.get()
                )
        );
    }

    // CREATE
    @PostMapping
    public ResponseEntity<?> addCategory(
            @RequestParam("categoryName")
            String categoryName,

            @RequestParam(value = "imageFile",
                    required = false)
            MultipartFile imageFile) {

        if (categoryName == null ||
                categoryName.trim().isEmpty()) {

            return ResponseEntity.badRequest().body(
                    new CategoryResponse(
                            false,
                            "Tên Category không được trống",
                            null
                    )
            );
        }

        categoryName = categoryName.trim();

        if (categoryService
                .findByCategoryName(categoryName)
                .isPresent()) {

            return ResponseEntity.badRequest().body(
                    new CategoryResponse(
                            false,
                            "Category đã tồn tại",
                            null
                    )
            );
        }

        Category category = new Category();
        category.setCategoryName(categoryName);

        try {
            if (imageFile != null &&
                    !imageFile.isEmpty()) {

                category.setIcon(saveImage(imageFile));
            }

            category = categoryService.save(category);

            return ResponseEntity.ok(
                    new CategoryResponse(
                            true,
                            "Thêm Category thành công",
                            category
                    )
            );

        } catch (IOException e) {
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new CategoryResponse(
                            false,
                            "Lỗi upload ảnh Category",
                            null
                    ));
        }
    }

    // UPDATE
    @PutMapping("/{id}")
    public ResponseEntity<?> updateCategory(
            @PathVariable Long id,

            @RequestParam("categoryName")
            String categoryName,

            @RequestParam(value = "imageFile",
                    required = false)
            MultipartFile imageFile) {

        Optional<Category> optional =
                categoryService.findById(id);

        if (optional.isEmpty()) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(new CategoryResponse(
                            false,
                            "Không tìm thấy Category",
                            null
                    ));
        }

        if (categoryName == null ||
                categoryName.trim().isEmpty()) {

            return ResponseEntity.badRequest().body(
                    new CategoryResponse(
                            false,
                            "Tên Category không được trống",
                            null
                    )
            );
        }

        categoryName = categoryName.trim();

        Optional<Category> oldCategory =
                categoryService
                        .findByCategoryName(categoryName);

        if (oldCategory.isPresent() &&
                !oldCategory.get().getCategoryId().equals(id)) {

            return ResponseEntity.badRequest().body(
                    new CategoryResponse(
                            false,
                            "Tên Category đã tồn tại",
                            null
                    )
            );
        }

        Category category = optional.get();

        try {
            category.setCategoryName(categoryName);

            if (imageFile != null &&
                    !imageFile.isEmpty()) {

                category.setIcon(saveImage(imageFile));
            }

            category = categoryService.save(category);

            return ResponseEntity.ok(
                    new CategoryResponse(
                            true,
                            "Cập nhật Category thành công",
                            category
                    )
            );

        } catch (IOException e) {
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new CategoryResponse(
                            false,
                            "Lỗi upload ảnh Category",
                            null
                    ));
        }
    }

    // DELETE
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteCategory(
            @PathVariable Long id) {

        Optional<Category> optional =
                categoryService.findById(id);

        if (optional.isEmpty()) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(new CategoryResponse(
                            false,
                            "Không tìm thấy Category",
                            null
                    ));
        }

        Category category = optional.get();

        categoryService.delete(category);

        return ResponseEntity.ok(
                new CategoryResponse(
                        true,
                        "Xóa Category thành công",
                        category
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
}