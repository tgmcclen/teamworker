class SuppliesController < ApplicationController
  def index
    @supplies = Supply.all
  end

  def show
    @supply = Supply.find(params[:id])
  end

  def new
    @supply = Supply.new
  end

  def create
    @supply = Supply.new(params[:supply])
    if @supply.save
      redirect_to @supply, :notice => "Successfully created supply."
    else
      render :action => 'new'
    end
  end

  def edit
    @supply = Supply.find(params[:id])
  end

  def update
    @supply = Supply.find(params[:id])
    if @supply.update_attributes(params[:supply])
      redirect_to @supply, :notice  => "Successfully updated supply."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @supply = Supply.find(params[:id])
    @supply.destroy
    redirect_to supplies_url, :notice => "Successfully destroyed supply."
  end
end
