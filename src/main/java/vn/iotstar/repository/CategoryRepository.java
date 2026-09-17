package vn.iotstar.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import vn.iotstar.entity.Category;

public interface CategoryRepository
        extends JpaRepository<Category, Long> {

    Optional<Category> findByCategoryName(String categoryName);

}
