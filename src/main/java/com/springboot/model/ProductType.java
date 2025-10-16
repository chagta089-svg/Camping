package com.springboot.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "productType")
public class ProductType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "productTypeid")
    private Integer productTypeid;

    @Column(name = "type_name", nullable = false)
    private String typeName;

    @OneToMany(mappedBy = "productType", cascade = CascadeType.ALL)
    private List<Product> products;

    // Constructors
    public ProductType() {}

    public ProductType(String typeName) {
        this.typeName = typeName;
    }

    // Getters and Setters
    public Integer getProductTypeid() { return productTypeid; }
    public void setProductTypeid(Integer productTypeid) { this.productTypeid = productTypeid; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public List<Product> getProducts() { return products; }
    public void setProducts(List<Product> products) { this.products = products; }
}