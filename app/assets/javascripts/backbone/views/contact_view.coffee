jQuery ->

    class ContactsView extends Backbone.View
        el: $('div#contacts_content')

        events:
            'click button#create_contact': 'create_contact'
            'click button#update_contact': 'update_contact'
            'click button#cancel_contact_update': 'cancel_contact_update'

        initialize: ->
            @collection = new Contacts()
            @render()

        render: ->
            @fetch_contacts()

        # Fetch the contacts' information from the API.
        fetch_contacts: ->
            # Saves the objects to be accesible inside the fetch.
            self = @
            @collection.fetch
                success: ->
                    # Iterates over the retrieved info.
                    for contact in self.collection.models
                        self.appendContact(contact)

        # Creates a contact.
        create_contact: ->
            # Catches the information of the form.
            first_name = $('input#first_name_input').val()
            last_name = $('input#last_name_input').val()

            # Sets contact's new information.
            contact = new Contact()
            contact.set {
                first_name: first_name
                last_name: last_name
            }

            # Creates the contact.
            self = @
            contact.save {},
                success: (contact_model) ->
                    self.collection.add(contact_model)
                    self.appendContact(contact_model)
                    self.clean_form()

        # Updates a contact.
        update_contact: ->
            # Catches the information of the form.
            first_name = $('input#first_name_input').val()
            last_name = $('input#last_name_input').val()
            contact_id = $('input#contact_id').val()

            # Searchs the contact in the collection.
            contact_to_update = @collection.get(contact_id)

            # Sets the new information.
            contact_to_update.set {
                first_name: first_name
                last_name: last_name
            }

            # Updates the contact.
            self = @
            contact_to_update.save {},
                success: ->
                    $('.update_contact_toggle').toggle()
                    self.clean_form()

        # Cleans the contact form.
        clean_form: ->
            $('div#contacts_form input').val("")

        # Method which executed when the user clicks the cancel button for
        # and update.
        cancel_contact_update: ->
            $('.update_contact_toggle').toggle()
            @clean_form()

        # Appends a contact to the view.
        appendContact: (contact) ->
            # Creates a contact view.
            contactView = new ContactView {
                model: contact
            }

            # Appends the contact view to the contacts' view.
            $('ul#contacts', @el).append(contactView.render().el)


    class ContactView extends Backbone.View
        tagName: 'li'

        events:
            'click button.delete_contact': 'delete_contact'
            'click button.update_contact': 'fill_contact_information_for_update'

        render: ->
            # Gets the contact information from the model.
            contact_information = {
                first_name: @model.get('first_name')
                last_name: @model.get('last_name')
            }

            # Compiles a template adding the contact information.
            template = _.template($("#contact_template").html(), contact_information)
            $(@el).append(template)

            @create_phones_view()
            return @

        fill_contact_information_for_update: ->
            # Gets model values.
            first_name = @model.get('first_name')
            last_name = @model.get('last_name')
            full_name = first_name + " " + last_name

            # Sets models values to the form
            $('input#first_name_input').val(first_name)
            $('input#last_name_input').val(last_name)
            $('input#contact_id').val(@model.get('id'))

            # Hide/show necessary fields for the update.
            $('.update_contact_toggle').toggle()

            # Adds a title with the contact's name who is updating.
            $('h3#updating_contact_title').text("Updating #{ full_name }")

        # Deletes a contact.
        delete_contact: ->
            self = @
            @model.destroy
                success: ->
                    $(self.el).remove()

        create_phones_view: ->
            # Creates a phones view.
            phonesView = new PhonesView(@model.get('id'))
            $(@el).append(phonesView.render().el)

    # Main view creation.
    new ContactsView()