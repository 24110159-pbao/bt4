package vn.iotstar.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ProductResponse {

    private boolean success;

    private String message;

    private Object data;

    public ProductResponse() {
    }

    public ProductResponse(
            boolean success,
            String message,
            Object data) {

        this.success = success;
        this.message = message;
        this.data = data;
    }


}