jQuery ->

    class PhonesView extends Backbone.View
        tagName: 'div'
        className: "phones_list"

        events: {
            'click button#create_phone': 'create_phone'
            'click button#update_phone': 'update_phone'
            'click button#cancel_phone_update': 'cancel_phone_update'
        }

        initialize: (contact_id)->
            @contact_id = contact_id
            @collection = new Phones(@contact_id)

        render: ->
            @fetch_phones()
            # Renders the table tamplate for the phones.
            phones_table = _.template($('#phones_table_template').html())
            $(@el).append(phones_table)
            return @

        fetch_phones: ->
            self = @

            # Fetch the phones for this contact.
            # Saves the objects to be accesible inside the fetch.
            self = @
            @collection.fetch
                success: ->
                    self.appendPhones(self.collection.models)

        # Appends alle the fetched phones to the view.
        appendPhones: (phones) ->

            phoneViews = []
            for phone in phones
                # Creates a phone view.
                phoneView = new PhoneView {
                    model: phone
                }
                phoneViews.push(phoneView.render().el)

            # Appends the phone view to the phones' view.
            $('tbody', @el).html(phoneViews)


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
                    self.fetch_phones()

        # Method which is executed when the user clicks the cancel button for
        # and update.
        cancel_phone_update: ->
            phones_div = $("div#collapse_contact_#{ @contact_id }")
            $('.update_phone_toggle', phones_div).toggle()
            $('button.update_phone').removeAttr('disabled')
            $('button.delete_phone').removeAttr('disabled')
            $('button.update_contact').removeAttr('disabled')
            $('button.delete_contact').removeAttr('disabled')
            $('h2#updating_phone_title').text("New Phone")
            @clean_form()

        # Cleans the phone form.
        clean_form: ->
            $('div.phones_form input').val("")
            $('h2#updating_phone_title').text("New Phone")

        # # Shows a popover when the user wants to create a phone entry.
        # create_popover: ->
        #     self = @
        #     $("#collapse_contact_#{ @contact_id }").popover {
        #         html: true,
        #         title: '<h2>New Phone</h2>'
        #         placement: 'right'
        #         content: ->
        #             self.compile_phone_form()
        #     }

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
            phones_div = $("div#collapse_contact_#{ @model.get('contact_id')}")
            console.log phones_div
            # Sets models values to the form.
            $("input#number_input", phones_div).val(number)
            $("input#number_type_input", phones_div).val(number_type)
            $("input#phone_id", phones_div).val(@model.get('id'))

            # Disable/enable necessary fields for the update.
            $('button.update_phone').attr('disabled', '')
            $('button.delete_phone').attr('disabled', '')
            $('button.update_contact').attr('disabled', '')
            $('button.delete_contact').attr('disabled', '')
            $('button.update_phone_toggle', phones_div).toggle()

            # Adds a title with the contact's name who is updating to
            # the phones' view.
            $('h2#updating_phone_title', phones_div).text("Updating #{ full_info }")


        # Deletes a phone entry
        delete_phone: ->
            self = @
            @model.destroy
                success: ->
                    $(self.el).fadeOut ->
                        $(self.el).remove()


    # Adds phones' view the the global variables.
    window.PhonesView = PhonesView