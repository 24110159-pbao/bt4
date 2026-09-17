package vn.iotstar.entity;

import java.math.BigDecimal;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Entity
@Table(name = "products")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private Long productId;

    @Column(name = "product_name", nullable = false, unique = true)
    private String productName;

    @Column(name = "images")
    private String images;

    @Column(name = "unit_price", nullable = false)
    private BigDecimal unitPrice;

    @Column(name = "discount")
    private BigDecimal discount;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "quantity")
    private Integer quantity;

    @Column(name = "status")
    private Short status;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    public Product() {
    }

    public Product(
            String productName,
            String images,
            BigDecimal unitPrice,
            BigDecimal discount,
            String description,
            Integer quantity,
            Short status,
            Category category) {

        this.productName = productName;
        this.images = images;
        this.unitPrice = unitPrice;
        this.discount = discount;
        this.description = description;
        this.quantity = quantity;
        this.status = status;
        this.category = category;
    }


}