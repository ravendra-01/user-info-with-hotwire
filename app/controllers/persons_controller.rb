class PersonsController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]

  def index
    @persons = Person.all
  end

  def show
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('person_details', partial: 'persons/detail', locals: {person: @person}) }
    end
  end
 
  def new
    @person = Person.new
    @person.build_detail
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('person_details', partial: 'persons/new', locals: {person: @person}) }
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('person_details', partial: 'persons/edit', locals: {person: @person}) }
    end
  end

  def create
    @person = Person.new(person_params)
    respond_to do |format|
      if @person.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("persons_list", partial: 'persons/list_item', locals: {person: @person}) +
                               turbo_stream.replace('new_person_details', partial: 'persons/detail', locals: {person: @person})
        end
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('new_person_details', partial: 'persons/new', locals: {person: @person})
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @person.update(person_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("person_details_#{@person.id}", partial: 'persons/list_item', locals: {person: @person}) +
                               turbo_stream.replace('edit_person_details', partial: 'persons/detail', locals: {person: @person})
        end
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('edit_person_details', partial: 'persons/edit', locals: {person: @person})
        end
      end
    end
  end

  def destroy
    @person.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("person_details_#{@person.id}") +
                             turbo_stream.replace('person_details', partial: 'persons/detail', locals: {person: Person.first})
      end
    end
  end

  private
    def set_person
      @person = Person.find(params[:id])
    end

    def person_params
      params.require(:person).permit(:name, detail_attributes: [:id, :title, :age, :phone, :email])
    end
end
