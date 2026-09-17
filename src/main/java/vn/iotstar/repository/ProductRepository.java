package vn.iotstar.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import vn.iotstar.entity.Product;

public interface ProductRepository
        extends JpaRepository<Product, Long> {

    Optional<Product> findByProductName(String productName);


}