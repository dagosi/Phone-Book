# Defines the model and the collection for a contact.

jQuery ->

    # A phone model is defined by:
    # number:      String. A phone number
    # number_type: String. Defines the type of the phone number
    #              (Work, Home, Cellular, or Other)
    class Phone extends Backbone.Model
        NUMBER_TYPES: ['Work', 'Home', 'Cellular', 'Other']

    # Phones collection.
    class Phones extends Backbone.Collection
        initialize: (contact_id) ->
            @url = "/contacts/#{ contact_id }/phones/"

        model: Phone

    # Makes the model and the collection globals
    window.Phones = Phones
    window.Phone = Phone
