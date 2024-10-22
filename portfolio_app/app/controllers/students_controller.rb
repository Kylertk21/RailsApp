class StudentsController < ApplicationController
  before_action :configure_permitted_parameters, if: :devise_controller?

  # GET /students or /students.json
  def index
    Rails.logger.info"Params: #{params.inspect}"
    @search_params = params[:search]||{}

    @students = Student.none

    if @search_params[:major].present? || (@search_params[:grad_date].present? && @search_params[:before_after].present?)
      @students = Student.all
    end
 
    if @search_params[:major].present?  
      @students = Student.by_major(@search_params[:major])
    end

    if @search_params[:grad_date].present? && @search_params[:before_after].present?      
      grad_date = @search_params[:grad_date]

      if @search_params[:before_after] == 'before'
        @students = @students.where('grad_date < ?', grad_date)
      elsif @search_params[:before_after] == 'after'
        @students = @students.where('grad_date > ?', grad_date)
      end
    end
    
    if params[:show_all] == 'true'
      @students = Student.page(params[:page]).per(4)
    else
      @students = @students.page(params[:page]).per(4) unless @students.empty?
    end

    Rails.logger.info "Search Params: #{@search_params.inspect}"
    Rails.logger.info "Filtered Students: #{@students.inspect}"
  end

  # GET /students/1 or /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:first_name, :last_name, :grad_date, :major, :image)
    end
end
