package com.exam.model;

public record Contact(String name, String phone) {
    @Override
    public String toString() {
        return String.format("Contact[Name=%s, Phone=%s]", name, phone);
    }
}
