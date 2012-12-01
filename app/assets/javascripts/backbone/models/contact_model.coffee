# Defines the model and the collection for a contact.

jQuery ->

    # A contact model is defined by:
    # first_name:  String. The contact's first name.
    # second_name: String. The contact's last name.
    class Contact extends Backbone.Model
        # Defines the default values for a contact.
        defaults: {
            first_name: 'Jhon'
            last_name: 'Doe'
        }
        urlRoot: '/contacts/'

    class Contacts extends Backbone.Collection
        model: Contact,
        url: '/contacts.json/',

    # Makes the model and the collection globals
    window.Contacts = Contacts
    window.Contact = Contact