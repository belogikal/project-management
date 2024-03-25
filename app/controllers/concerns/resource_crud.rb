module ResourceCrud
  extend ActiveSupport::Concern

  included { skip_before_action :verify_authenticity_token }

  def index
    @resources = model_class.all
    respond_to do |format|
      format.html
      format.json { render json: @resources }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: resource }
    end
  end

  def edit; end

  def update
    if resource.update(resource_params)
      respond_to do |format|
        format.html { redirect_to redirection_path, notice: 'Updated' }
        format.json { render json: { message: 'Updated', resource: } }
      end
    else
      error_response(resource)
    end
  end

  def new
    resource = model_class.new

    respond_to do |format|
      format.html
      format.json { render json: resource }
    end
  end

  def create
    @resource = model_class.new(resource_params)

    if @resource.save
      respond_to do |format|
        format.html { redirect_to redirection_path, notice: 'Created' }
        format.json { render json: { message: 'Created', resource: @resource } }
      end
    else
      error_response(@resource)
    end
  end

  def destroy
    resource.destroy
    redirect_to [controller_name.to_sym], notice: 'Deleted'
  end

  private

  def resource
    @resource ||= model_class.find(params[:id])
  end

  def redirection_path
    resource
  end

  def model_class
    controller_name.singularize.camelize.constantize
  end

  def resource_name
    controller_name.singularize
  end

  def resource_params
    params.require(resource_name).permit(permitted_params)
  end

  def error_response(resource, status = :unprocessable_entity)
    respond_to do |format|
      format.html { redirect_back }
      format.json { render json: { errors: resource.errors.full_messages }, status: }
    end
  end
end
