jQuery ->

    class ContactsView extends Backbone.View
        el: $('div#content')

        events:
            'click button#create_contact': 'create_contact'
            'click button#update_contact': 'update_contact'
            'click button#cancel_contact_update': 'cancel_contact_update'

        initialize: ->
            @collection = new Contacts()
            @pusher_event()
            @render()


        render: ->
            @fetch_contacts()

        # Creates the pusher listener. When a contact is deleted, created, or udpated,
        # this listener is executed.
        pusher_event: ->
            self = @
            contact_channel.bind('change', (data) ->
                self.fetch_contacts()
            )

        # Fetch the contacts' information from the API.
        fetch_contacts: ->
            # Saves the objects to be accesible inside the fetch.
            self = @
            @collection.fetch
                success: ->
                    self.appendContacts(self.collection.models)

        # Appends all the fetched contacts to the view.
        appendContacts: (contacts) ->

            contactViews = []
            for contact in contacts
                # Creates a contact view.
                contactView = new ContactView {
                    model: contact
                }
                # Adds the HTML contact view to the list.
                contactViews.push(contactView.render().el)

            # Renders the contacts.
            $('div#contacts', @el).html(contactViews)


        # Creates a contact.
        create_contact:  ->
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
                    self.fetch_contacts()
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
                    self.fetch_contacts()

        # Cleans the contact form.
        clean_form: ->
            $('div#contacts_form input').val("")
            $('h2#form_title').text("New Contact")

        # Method which is executed when the user clicks the cancel button for
        # a contact update.
        cancel_contact_update: ->
            $('.update_contact_toggle').toggle()
            $('button.update_contact').removeAttr('disabled')
            $('button.delete_contact').removeAttr('disabled')
            $('button.update_phone').removeAttr('disabled')
            $('button.delete_phone').removeAttr('disabled')
            $('h2#form_title').text("New Contact")
            @clean_form()


    class ContactView extends Backbone.View

        events:
            'click button.delete_contact': 'delete_contact'
            'click button.update_contact': 'fill_contact_information_for_update'

        render: ->
            @render_contact_template()
            @create_phones_view()
            return @

        render_contact_template: ->
            # Gets the contact information from the model.
            contact_information = {
                first_name: @model.get('first_name')
                last_name: @model.get('last_name')
                id: @model.get('id')
            }

            # Compiles a template adding the contact information.
            template = _.template($("#contact_template").html(), contact_information)
            $(@el).append(template)

        fill_contact_information_for_update: ->
            # Gets model values.
            first_name = @model.get('first_name')
            last_name = @model.get('last_name')
            full_name = first_name + " " + last_name

            # Sets models values to the form
            $('input#first_name_input').val(first_name)
            $('input#last_name_input').val(last_name)
            $('input#contact_id').val(@model.get('id'))

            # Disable/enable necessary fields for the update.
            $('button.update_contact_toggle').toggle()
            $('button.update_contact').attr('disabled', '')
            $('button.delete_contact').attr('disabled', '')
            $('button.update_phone').attr('disabled', '')
            $('button.delete_phone').attr('disabled', '')

            # Changes form title.
            $('h2#form_title').text("Editing #{ full_name }")

        # Deletes a contact.
        delete_contact: ->
            self = @
            @model.destroy
                success: ->
                    console.log(self.el)
                    $(self.el).fadeOut ->
                        $(self.el).remove()

        # Creates the phones view.
        create_phones_view: ->
            # Creates a phones view.
            phonesView = new PhonesView(@model.get('id'))
            $('div#phones', @el).append(phonesView.render().el)

    # Initializes Pusher and its channel.
    pusher = new Pusher('dd485dd170fb48eb43c0')
    contact_channel = pusher.subscribe('contact-channel');

    window.phone_channel = pusher.subscribe('phone-channel');


    # Main view creation.
    new ContactsView()

