package com.exam.service;

import com.exam.model.Contact;
import java.util.ArrayList;
import java.util.List;
import java.util.Collections;

public class ContactService {
    private final List<Contact> contacts = new ArrayList<>();

    public void addContact(Contact contact) {
        if (contact == null) throw new IllegalArgumentException("Contact cannot be null");
        contacts.add(contact);
    }

    public int getContactCount() {
        return contacts.size();
    }

    public List<Contact> getAllContacts() {
        return Collections.unmodifiableList(contacts);
    }
}
