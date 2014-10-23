class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @votable = votable_class.find(params[:vote][:votable_id])
    @vote = current_user.gives_vote_to(@votable)
    redirect_to :back
  end

  def destroy
    Vote.find(params[:id]).destroy
    redirect_to :back
  end

  private

  def votable_class
    (params[:vote][:votable_type]).classify.constantize
  end
end