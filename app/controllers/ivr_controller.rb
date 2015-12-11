class IvrController < ApplicationController
  protect_from_forgery :except => :index
  def index
    caller = (params[:From]).try(:strip)
    receiver = (params[:To]).try(:strip)

    user = Guest.find_by_mobile(caller)
    #create Event
    event = Event.create(:caller => caller , :called => receiver , :called_at => Time.now , :guest => user)
    xml_string = ""
    #Guest found
    if user
      #check schedule

      logger.debug user.date_start
      logger.debug user.date_end
      logger.debug Time.now

      #if Time.now.between?(user.date_start,user.date_end)
      if user.flag_enabled
      #  forward call
        caller_id = IvrConfig.find_by_code(5).try(:property_value)
        dn = IvrConfig.find_by_code(4).try(:property_value)
        xml_string = Gyoku.xml({"Response" =>
                                    {
                                        "Play" => IvrConfig.find_by_code(3).property_value,
                                        "Dial" => {
                                            :content! => dn,
                                            :@callerId =>  caller_id
                                        }

                                    }}
        )
        event.update(:called => dn)
      else
      # Announcement
        xml_string = Gyoku.xml({"Response" =>
                       {
                           "Play" => IvrConfig.find_by_code(2).property_value
                       }}
        )
      end
    else
    #  unknown user
      xml_string = Gyoku.xml({"Response" =>
                                  {
                                      "Play" => IvrConfig.find_by_code(1).property_value
                                  }}
      )
    end


    @twiml = Nokogiri::XML(xml_string)
    logger.debug "====================TWIML==========================="
    logger.debug @twiml
    logger.debug "====================END OF TWIML===================="

    render :layout => false,  :action => "index" #, type: "application/xml"
  end
end
