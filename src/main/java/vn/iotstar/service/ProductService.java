package vn.iotstar.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import vn.iotstar.entity.Product;
import vn.iotstar.repository.ProductRepository;

@Service
public class ProductService implements IProductService {

    @Autowired
    private ProductRepository productRepository;

    @Override
    public List<Product> findAll() {

        return productRepository.findAll();

    }

    @Override
    public Optional<Product> findById(Long id) {

        return productRepository.findById(id);

    }

    @Override
    public Optional<Product> findByProductName(String productName) {

        return productRepository.findByProductName(productName);

    }

    @Override
    public Product save(Product product) {

        return productRepository.save(product);

    }

    @Override
    public void delete(Product product) {

        productRepository.delete(product);

    }


}