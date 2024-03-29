class PeopleController < ApplicationController
  skip_before_action :authenticate_admin!, only: [:show]
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  def index
    @people = Person.order("results_count DESC, nickname")
    respond_to do |format|
      format.html
      format.csv {
        send_data @people.to_csv
      }
    end
  end

  def show
  end

  def new
    @person = Person.new
  end

  def edit
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to new_person_url, notice: "#{@person.name} was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @person.update(person_params)
      redirect_to @person, notice: "Person was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy
    redirect_to people_url, notice: "Person was successfully destroyed."
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:name, :email, :nickname, :emoji, :password, :password_confirmation, :birthdate, :country, :parkrun_id)
  end
end
