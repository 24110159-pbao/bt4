package vn.iotstar.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Entity
@Table(name = "categories")
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_id")
    private Long categoryId;

    @Column(name = "category_name", nullable = false, unique = true)
    private String categoryName;

    @Column(name = "icon")
    private String icon;

    public Category() {
    }

    public Category(String categoryName, String icon) {
        this.categoryName = categoryName;
        this.icon = icon;
    }

}
