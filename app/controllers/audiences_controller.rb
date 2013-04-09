class AudiencesController < ApplicationController

  def create
    @item_id =params["item_id"].to_i
    create_audience @item_id
  end

end
