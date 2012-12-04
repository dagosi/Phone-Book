jQuery ->

    # Contains the view for a list of contacts.
    class ContactsView extends Backbone.View
        el: $('div#content')

        # Events definition.
        events:
            'click button#create_contact': 'create_contact'
            'click button#update_contact': 'update_contact'
            'click button#cancel_contact_update': 'cancel_contact_update'

        initialize: ->
            @collection = new Contacts()
            @pusher_event()               # Real-time listener.
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
            # Saves the present object ('this') in order to be accesible
            # inside the fetch function. You will se this often in this code.
            self = @
            @collection.fetch
                success: ->
                    self.appendContacts(self.collection.models)

        # Appends all the fetched contacts to the view.
        appendContacts: (contacts) ->
            # Store the all the contacts' views.
            contactViews = []
            # Creates a new contact view for each object and
            # stores the object in the views list.
            for contact in contacts
                # Creates a contact view.
                contactView = new ContactView {
                    model: contact
                }
                # Adds the HTML contact view to the list.
                contactViews.push(contactView.render().el)

            # Renders the contacts with HTML because for each
            # creation it has to reorder the contact list by last name.
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

            self = @
            # Adds a validation listener to the contact model.
            # When a validation error is found, the function is executed.
            contact.on 'error', (contact_model, error) ->
                Helper.show_message(Constant.ERROR, error, Constant.CONTACT)

            # Creates the contact.
            self = @
            contact.save {},
                success: (contact_model) ->
                    # Adds the new contact to the collection.
                    self.collection.add(contact_model)
                    # Fetch the contact again in order to keep
                    # the contacts ordered by last name.
                    self.fetch_contacts()
                    # Cleans the creation form.
                    self.clean_form()
                    # Shows the successful message.
                    msg = "The contact was created successfully."
                    Helper.show_message(Constant.SUCCESS, msg, Constant.CONTACT)

        # Updates a contact.
        update_contact: ->
            # Catches the information of the form.
            first_name = $('input#first_name_input').val()
            last_name = $('input#last_name_input').val()
            # This hidden input identifies which contact is being editing
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
                    # Toggles the DOM objects for the update.
                    $('.update_contact_toggle').toggle()
                    # Cleans the form
                    self.clean_form()
                    # Fetchs the contacts to keep the info ordered.
                    self.fetch_contacts()
                    # Shows the successful message.
                    msg = "The contact was updated successfully."
                    Helper.show_message(Constant.SUCCESS, msg, Constant.CONTACT)

        # Cleans the contact form.
        clean_form: ->
            $('div#contacts_form input').val("")
            $('h2#form_title').text("New Contact")

        # Method which is executed when the user clicks the cancel button for
        # a contact update.
        cancel_contact_update: ->
            $('.update_contact_toggle').toggle()
            # Disables some buttons from the DOM.
            $('button.update_contact').removeAttr('disabled')
            $('button.delete_contact').removeAttr('disabled')
            $('button.update_phone').removeAttr('disabled')
            $('button.delete_phone').removeAttr('disabled')
            # Changes the title of the form.
            $('h2#form_title').text("New Contact")
            @clean_form()


    # Defines the view for each Contact.
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

            # Compiles the contact template adding the contact information.
            template = _.template($("#contact_template").html(), contact_information)
            $(@el).append(template)

        # Fills the updating information in the form, disabled some
        # buttons and makes ncessary toggles.
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
            # Destroys the model.
            @model.destroy
                success: ->
                    # Makes an effect on deleting the contact.
                    $(self.el).fadeOut ->
                        # Removes the contact from the dom.
                        $(self.el).remove()
                        # Shows the successful message.
                        msg = "The contact was deleted successfully."
                        Helper.show_message(Constant.SUCCESS, msg, Constant.CONTACT)

        # Creates the phones view.
        create_phones_view: ->
            # Creates a phones view.
            phoneView = new PhonesView(@model.get('id'))
            # Appends the phone view to the document.
            $('div#phones', @el).append(phoneView.render().el)

    # Initializes Pusher and its channel (real-time feature).
    pusher = new Pusher('dd485dd170fb48eb43c0')
    contact_channel = pusher.subscribe('contact-channel');

    # Makes this channel global.
    window.phone_channel = pusher.subscribe('phone-channel');

    # Main view creation.
    new ContactsView()

