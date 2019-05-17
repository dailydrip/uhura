# frozen_string_literal: true

class Api::V1::OffersController < Api::V1::ApiBaseController
  def show
    @offer = Offer.find(params[:id])
    render json: @offer
  end

  def index
    @offers = @manager.offers
    render json: @offers
  end

  def update
    @offer = @app.offers.find(params[:id])
    if @offer.update(offer_params)
      render json: @offer, status: 201
    else
      render json: { error: @offer.errors }, status: 422
    end
  end

  def create
    @offer = Offer.new(offer_params)
    @offer.manager = @manager
    if @offer.save
      render json: @offer
    else
      render json: { error: @offer.errors }, status: 422
    end
  end

  private

  def offer_params
    params.require(:offer).permit %i[description name due_on amount deferrable]
  end
end
