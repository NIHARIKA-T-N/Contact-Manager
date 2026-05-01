package com.exam.service;

import com.exam.model.Contact;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;

public class ContactServiceTest {
    @Test
    void testAddContact() {
        ContactService service = new ContactService();
        service.addContact(new Contact("Test User", "000-000-0000"));
        Assertions.assertEquals(1, service.getContactCount());
    }

    @Test
    void testGetAllContacts() {
        ContactService service = new ContactService();
        service.addContact(new Contact("A", "1"));
        Assertions.assertFalse(service.getAllContacts().isEmpty());
    }
}
