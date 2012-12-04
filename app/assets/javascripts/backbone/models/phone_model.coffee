# Defines the model and the collection for a contact.

jQuery ->

    # A phone model is defined by:
    # number:      String. A phone number
    # number_type: String. Defines the type of the phone number
    #              (Work, Home, Cellular, or Other)
    class Phone extends Backbone.Model
        # Defines the validations for this model.
        validate: (attrs) ->
            if not attrs.number
                return 'Number is required.'

            if not attrs.number_type
                return 'Number type is required.'

        initialize: (contact_id) ->
            if @get('contact_id')
                @urlRoot = "/contacts/#{ @get('contact_id') }/phones/"
            else if contact_id
                @urlRoot = "/contacts/#{ contact_id }/phones/"

    # Phones collection.
    class Phones extends Backbone.Collection
        initialize: (contact_id) ->
            @url = "/contacts/#{ contact_id }/phones.json"

        model: Phone

    # Makes the model and the collection globals
    window.Phones = Phones
    window.Phone = Phone
