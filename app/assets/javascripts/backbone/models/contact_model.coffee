# Defines the model and the collection for the contact object.

jQuery ->

    # A contact model is defined by:
    # first_name:  String. The contact's first name(obligatory).
    # second_name: String. The contact's last name(optional).
    class Contact extends Backbone.Model
        # Defines the validations for this model.
        validate: (attrs) ->
            if not attrs.first_name
                return 'First name is required.'

        urlRoot: '/contacts/'

    # Defines the collection for the Contact model.
    class Contacts extends Backbone.Collection
        model: Contact,
        url: '/contacts.json/',

    # Makes the model and the collection globals.
    window.Contacts = Contacts
    window.Contact = Contact