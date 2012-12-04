jQuery ->
    # Contains useful method necessaries along the Bakckbone implementation.
    class Helper
        # Shows a message in the view.
        # This message can be provider for an error or a successful action.
        # msg_type:   String. Defines if is an error message or a success message.
        # ms: String. Message
        # model_name: Model which thw messages belongs to.
        show_message: (msg_type, msg, model_name) ->
            variables = {
                message: msg
                msg_type: msg_type
            }

            # Contains the div message in the DOM
            div_messages = "div##{ model_name }_messages"
            # Compiles the message template giving some parameters.
            template = _.template($('#messages_template').html(), variables)
            $(div_messages).html(template)

    # Contains useful contants necessaries along the implementation.
    class Constant
        # Defines constants for validation messages. Error, success, and their models.
        SUCCESS: 'success'
        ERROR: 'error'
        CONTACT: 'contact'
        PHONE: 'phone'

    # Makes these helpers globals.
    window.Helper = new Helper()
    window.Constant = new Constant()