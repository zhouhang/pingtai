class Admin::ChannelgroupsController < Admin::ApplicationController
  def index
    @channelgroups = Channelgroup.page(params[:page])
  end

  def new
    @channelgroup = Channelgroup.new
  end

  def create
    @channelgroup = Channelgroup.new channelgroup_params
    if @channelgroup.save
      redirect_to action:'index'
    else
      render 'new'
    end
  end

  def edit
    @channelgroup = Channelgroup.find params[:id]
    @channels = Channel.find_by_sql("SELECT c.id, c.name, cgs.id as cgsid, cgs.order FROM channels c left join channelgroupships cgs on c.id = cgs.channel_id and c.operator_id = #{@channelgroup.operator_id} order by cgs.order desc")
    @channels.each do |c|
      c.order
    end
  end

  def update
    params[:channels].each do |key, value|
      if value == ""
        Channelgroupship.destroy_all(["channel_id = ? and channelgroup_id = ?", key, params[:id]])
      else
        channelgroupship = Channelgroupship.where("channel_id = :channel_id and channelgroup_id = :channelgroup_id",
                                                   { :channel_id => key, :channelgroup_id => params[:id]})
        if channelgroupship.empty?
          channelgroupship = Channelgroupship.new( :channel_id => key, :channelgroup_id => params[:id], :order => value)
          channelgroupship.save
        else
          channelgroupship[0].order = value
          channelgroupship[0].save
        end
      end
    end
    if  Channelgroup.find(params[:id]).update(channelgroup_params)
      redirect_to action:'index'
    else
      render edit_admin_channelgroup_path
    end
  end

  def destroy
    @channelgroup = Channelgroup.find params[:id]
    @channelgroup.destroy
    respond_with do |format|
      format.html { redirect_to action:'index' }
      format.js { render :nothing => true, :status => 200, :content_type => 'text/html' }
    end
  end

  def channelgroup_params
    params.require(:channelgroup).permit(:province_id, :city_id, :operator_id)
  end

end
