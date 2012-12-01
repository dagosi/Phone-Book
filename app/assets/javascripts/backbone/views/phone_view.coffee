jQuery ->

    class PhonesView extends Backbone.View
        tagName: 'div'
        className: 'phones'

        events:
            'click button#create_phone': 'create_phone'

        initialize: (contact_id) ->
            @contact_id = contact_id
            @collection = new Phones(@contact_id)

        render: ->
            template = _.template($('#phone_form_template').html())
            $(@el).append(template)
            @fetch_phones()
            return @

        # Fetch the phones' information from the API.
        fetch_phones: ->
            # Saves the objects to be accesible inside the fetch.
            self = @
            @collection.fetch
                success: ->
                    # Iterates over the retrieved info.
                    for phone in self.collection.models
                        self.appendPhone(phone)

        # Creates a phone entry.
        create_phone: ->
            # Catches the information of the form.
            number = $('input#number_input', @el).val()
            number_type = $('input#number_type_input', @el).val()

            # Sets phone's new information.
            phone = new Phone(@contact_id)
            phone.set {
                number: number
                number_type: number_type
            }

            # Creates the phone entry.
            self = @
            phone.save {},
                success: (phone_model) ->
                    self.collection.add(phone_model)
                    self.appendPhone(phone_model)

        # Cleans the phone form.
        clean_form: ->
            $('div#phones_form input').val("")


        # Appends a phone object to the view.
        appendPhone: (phone) ->
            # Creates a phone view.
            phoneView = new PhoneView {
                model: phone
            }

            # Appends the phone view to the phones' view.
            $('ul', @el).append(phoneView.render().el)


    class PhoneView extends Backbone.View
        tagName: 'li'

        events:
            'click button.delete_phone': 'delete_phone'

        render: ->
            # Gets the phone information from the model.
            phone_information = {
                number: @model.get('number')
                number_type: @model.get('number_type')
            }

            # Compiles a template adding the phone information.
            template = _.template($("#phone_template").html(), phone_information)
            $(@el).append(template)

            return @

        fill_contact_information_for_update: ->
            # Gets model values.
            number = @model.get('number')
            number_type = @model.get('number_type')
            full_info = number + " " + number_type

            # Sets models values to the form
            $('input#number_input').val(number)
            $('input#number_type').val(number_type)
            $('input#phone_id').val(@model.get('id'))

            # Hide/show necessary fields for the update.
            $('.update_phone_toggle').toggle()

            # Adds a title with the contact's name who is updating.
            $('h3#updating_phone_title').text("Updating #{ full_info }")

        # Deletes a phone entry
        delete_phone: ->
            self = @
            @model.destroy
                success: ->
                    $(self.el).remove()


    # Adds phones' view the the global variables.
    window.PhonesView = PhonesView