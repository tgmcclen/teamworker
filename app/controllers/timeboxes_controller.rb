class TimeboxesController < ApplicationController
  def index
    @timeboxes = Timebox.all
  end

  def show
    @timebox = Timebox.find(params[:id])
  end

  def new
    @timebox = Timebox.new
  end

  def create
    @timebox = Timebox.new(params[:timebox])
    if @timebox.save
      redirect_to @timebox, :notice => "Successfully created timebox."
    else
      render :action => 'new'
    end
  end

  def edit
    @timebox = Timebox.find(params[:id])
  end

  def update
    @timebox = Timebox.find(params[:id])
    if @timebox.update_attributes(params[:timebox])
      redirect_to @timebox, :notice  => "Successfully updated timebox."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @timebox = Timebox.find(params[:id])
    @timebox.destroy
    redirect_to timeboxes_url, :notice => "Successfully destroyed timebox."
  end
end
