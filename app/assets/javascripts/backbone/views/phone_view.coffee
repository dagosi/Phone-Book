jQuery ->

    class PhonesView extends Backbone.View
        tagName: 'ul'
        className: 'phones'

        initialize: (contact_id) ->
            @collection = new Phones(contact_id)

        render: ->
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

        # Appends a phone object to the view.
        appendPhone: (phone) ->
            # Creates a phone view.
            phoneView = new PhoneView {
                model: phone
            }

            # Appends the phone view to the phones' view.
            $(@el).append(phoneView.render().el)


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

        # Deletes a phone entry
        delete_phone: ->
            self = @
            @model.destroy
                success: ->
                    $(self.el).remove()


    # Adds phones' view the the global variables.
    window.PhonesView = PhonesView