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
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('person_details', partial: 'persons/new', locals: {person: @person}) }
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('person_details', partial: 'persons/edit', locals: {person: @person}) }
    end
  end

  # POST /programs or /programs.json
  def create
    @person = Person.create(person_params)
    @detail = @person.create_detail(
      title: params[:detail_attributes][:title],
      age: params[:detail_attributes][:age],
      email: params[:detail_attributes][:email],
      phone: params[:detail_attributes][:phone]
    )
    respond_to do |format|
      if @person.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("persons_list", partial: 'persons/list_item', locals: {person: @person}) +
                               turbo_stream.replace('new_person_details', partial: 'persons/detail', locals: {person: @person})
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
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
