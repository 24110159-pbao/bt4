package vn.iotstar.service;

import java.util.List;
import java.util.Optional;

import vn.iotstar.entity.Category;

public interface ICategoryService {

    List<Category> findAll();

    Optional<Category> findById(Long id);

    Optional<Category> findByCategoryName(String categoryName);

    Category save(Category category);

    void delete(Category category);
}
