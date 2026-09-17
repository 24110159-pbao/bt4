package vn.iotstar.service;

import java.util.List;
import java.util.Optional;

import vn.iotstar.entity.Product;

public interface IProductService {

    List<Product> findAll();

    Optional<Product> findById(Long id);

    Optional<Product> findByProductName(String productName);

    Product save(Product product);

    void delete(Product product);


}