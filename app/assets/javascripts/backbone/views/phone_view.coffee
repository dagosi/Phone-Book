jQuery ->

    class PhonesView extends Backbone.View
        events:
            'click button#create_phone': 'create_phone'
            'click button#update_phone': 'update_phone'
            'click button#cancel_phone_update': 'cancel_phone_update'

        initialize: (contact_id) ->
            @contact_id = contact_id
            @el = "div#contact_#{ @contact_id }_phones"
            @collection = new Phones(@contact_id)
            @render()

        render: ->
            # Fetch the phones for this contact.
            # Saves the objects to be accesible inside the fetch.
            self = @
            @collection.fetch
                success: ->
                    # Iterates over the retrieved info.
                    for phone in self.collection.models
                        self.appendPhone(phone)

                    # Renders the form to create a new phone.
                    #self.render_phone_form()

        render_phone_form: ->
            form_variables = {
                id: @contact_id
            }

            template = _.template($("#phone_form_template").html(), form_variables)
            $("div#contact_#{ @contact_id }_phones").append(template)


        # Appends a phone object to the view.
        appendPhone: (phone) ->
            # Creates a phone view.
            phoneView = new PhoneView {
                model: phone
            }

            # Appends the phone view to the phones' view.
            $('table tbody', @el).append(phoneView.render().el)


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
                    self.clean_form()

        # Updates a phone.
        update_phone: ->

            # Catches the information of the form.
            number = $('input#number_input', phones_div).val()
            number_type = $('input#number_type_input', phones_div).val()
            phone_id = $('input#phone_id', phones_div).val()

            # Searchs the phone in the collection.
            phone_to_update = @collection.get(phone_id)

            # Gets phones for each contact div.
            phones_div =
                $("div#contact_#{ phone_to_update.get('contact_id')}_phones")

            # Sets the new information.
            phone_to_update.set {
                number: number
                number_type: number_type
            }

            console.log phone_to_update

            # Updates the phone.
            self = @
            phone_to_update.save {},
                success: ->
                    $('.update_phone_toggle').toggle()
                    self.clean_form()

        # Method which is executed when the user clicks the cancel button for
        # and update.
        cancel_phone_update: ->
            $('.update_phone_toggle').toggle()
            @clean_form()

        # Cleans the phone form.
        clean_form: ->
            $('div#phones_form input').val("")



    class PhoneView extends Backbone.View
        tagName: 'tr'
        events:
            'click button.delete_phone': 'delete_phone'
            'click button.update_phone': 'fill_phone_information_for_update'

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

        fill_phone_information_for_update: ->
            # Gets model values.
            number = @model.get('number')
            number_type = @model.get('number_type')
            full_info = number + " " + number_type

            # Gets phones div.
            phones_div = $("div#contact_#{ @model.get('contact_id')}_phones")

            # Sets models values to the form.
            $("input#number_input", phones_div).val(number)
            $("input#number_type_input", phones_div).val(number_type)
            $("input#phone_id", phones_div).val(@model.get('id'))

            # Hide/show necessary fields for the update.
            $('.update_phone_toggle').toggle()

            # Adds a title with the contact's name who is updating to
            # the phones' view.
            $('h3#updating_phone_title', phones_div)
                .text("Updating #{ full_info }")


        # Deletes a phone entry
        delete_phone: ->
            self = @
            @model.destroy
                success: ->
                    $(self.el).remove()


    # Adds phones' view the the global variables.
    window.PhonesView = PhonesView