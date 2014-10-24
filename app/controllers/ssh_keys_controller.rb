class SshKeysController < ApplicationController
  before_action :set_ssh_key, only: [:show, :edit, :update, :destroy]

  # GET /ssh_keys
  def index
    @ssh_keys = SshKey.all
  end

  # GET /ssh_keys/1
  def show
  end

  # GET /ssh_keys/new
  def new
    @ssh_key = SshKey.new
  end

  # GET /ssh_keys/1/edit
  def edit
  end

  # POST /ssh_keys
  def create
    @ssh_key = SshKey.new(ssh_key_params)

    if @ssh_key.save
      redirect_to @ssh_key, notice: 'Ssh key was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ssh_keys/1
  def update
    if @ssh_key.update(ssh_key_params)
      redirect_to @ssh_key, notice: 'Ssh key was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ssh_keys/1
  def destroy
    @ssh_key.destroy
    redirect_to ssh_keys_url, notice: 'Ssh key was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ssh_key
      @ssh_key = SshKey.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ssh_key_params
      params.require(:ssh_key).permit(:private_key, :public_key, :comment, :passphrase)
    end
end
