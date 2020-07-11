module ApplicationHelper

    def bootstrap_alert(msg_type)
        case msg_type
        when "alert"
          "warning"
        when "notice"
          "success"
        when "error"
          "danger"
        end
    end



end
