class Basechurch::V1::BulletinsController < Basechurch::ApplicationController
  before_action :authenticate_user!, except: [:show, :sunday]
  before_action :set_signing_expiry, only: :sign

  def sunday
    params[:id] = fetch_sunday_bulletin_id.to_s
    show
  end

  def sign
    render json: {
      acl: 'public-read',
      awsAccessKeyId: Rails.application.secrets.aws_access_key_id,
      bucket: 'mcac-staging',
      'Cache-Control' => 'max-age=630720000, public',
      'Content-Type' => params[:type],
      expires: @expiry,
      key: "bulletins/#{random_filename}",
      policy: encoded_policy,
      signature: signature,
      success_action_status: '201'
    }, status: :ok
  end

  private
  def fetch_sunday_bulletin_id
    Basechurch::Bulletin.english_service.
                         where('published_at <= ?', DateTime.now).
                         order('published_at DESC').
                         pluck(:id).
                         first
  end

  def encoded_policy
    Base64.strict_encode64(policy.to_json)
  end

  def policy
    {
      expiration: @expiry,
      conditions: [
        { bucket: 'mcac-staging' },
        { acl: 'public-read' },
        { expires: @expiry },
        { success_action_status: '201' },
        ['starts-with', '$key', ''],
        ['starts-with', '$Content-Type', ''],
        ['starts-with', '$Cache-Control', ''],
        ['content-length-range', 0, 524288000]
      ]
    }
  end

  def signature
    Base64.strict_encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new('sha1'),
        Rails.application.secrets.aws_secret_access_key,
        encoded_policy
      )
    )
  end

  def set_signing_expiry
    @expiry = 30.minutes.from_now
  end

  def file_extension(file_type)
    case file_type
    when 'image/jpeg', 'image/jpg'
      'jpg'
    end
  end

  def random_filename
    "#{SecureRandom.uuid}.#{file_extension(params[:type])}"
  end
end
