jQuery ->
    class Helper
        # Shows a message in the view.
        show_message: (msg_type, msg, model_name) ->
            variables = {
                message: msg
                msg_type: msg_type
            }

            div_messages = "div##{ model_name }_messages"
            console.log div_messages
            template = _.template($('#messages_template').html(), variables)
            $(div_messages).html(template)

    class Constant
        # Defines constants for validation messages.
        SUCCESS: 'success'
        ERROR: 'error'
        CONTACT: 'contact'
        PHONE: 'phone'

    window.Helper = new Helper()
    window.Constant = new Constant()