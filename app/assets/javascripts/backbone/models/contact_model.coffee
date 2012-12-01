# Defines the model and the collection for a contact.

jQuery ->

    class Contact extends Backbone.Model
        urlRoot: '/contacts/'

    class Contacts extends Backbone.Collection
        model: Contact,
        url: '/contacts.json/',

    # Makes the model and the collection globals
    window.Contacts = Contacts
    window.Contact = Contact

    # c = new Contacts()
    # c.fetch
    #     success: ->
    #         console.log c.models
    #         for contact in c.models
    #             $('div#contacts').append("<p> #{ contact.get('first_name') } #{ contact.get('last_name')} </p>")
