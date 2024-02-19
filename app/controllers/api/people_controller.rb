class Api::PeopleController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }

  before_action :set_person, only: %i[ show edit update destroy ]
  
  def index
    @people = Person.includes(:detail).all
    render json: PeopleSerializer.new(@people).serializable_hash, status: :ok
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      render json: PeopleSerializer.new(@person).serializable_hash, status: :created
    else
      render json: { errors: format_activerecord_errors(@person.errors) }, status: :unprocessable_entity
    end
  end

  def update
    if @person.update(person_params)
      render json: PeopleSerializer.new(@person).serializable_hash, status: :ok
    else
      render json: { errors: format_activerecord_errors(@person.errors) }, status: :unprocessable_entity
    end
  end

  def show
    render json: PeopleSerializer.new(@person).serializable_hash, status: :ok
  end

  def destroy
    if @person.destroy
      render json: {error: "Person deleted successfully"}, status: :ok
    end
  end
  
  private
  
  def set_person
    @person = Person.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    return render json: {error: e.message}, status: 404
  end
  
  def person_params
    params.require(:person).permit(:name, detail_attributes: [:id, :title, :age, :phone, :email])
  end

  def format_activerecord_errors(errors)
    result = []
    errors.each do |type|
      result << { type.attribute => type.full_message }
    end
    result
  end
end
