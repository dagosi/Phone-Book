jQuery ->

    class ContactsView extends Backbone.View
        el: $('ul#contacts')

        initialize: ->
            @collection = new window.Contacts()
            @render()

        render: ->
            self = @
            @collection.fetch
                success: ->
                    for contact in self.collection.models
                        self.appendContact(contact)

        appendContact: (contact) ->
            contactView = new ContactView {
                model: contact
            }
            $(@el).append(contactView.render().el)

    class ContactView extends Backbone.View
        tagName: 'li'

        render: ->
            contact_information = {
                first_name: @model.get('first_name')
                last_name: @model.get('last_name')
            }

            template = _.template($("#template").html(), contact_information)
            $(@el).append(template)
            return @


    new ContactsView()