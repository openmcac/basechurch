class S3Signer
  attr_reader :expiry

  def initialize
    @expiry = 30.minutes.from_now
  end

  def sign(options = {})
    type = options[:type]
    directory = options[:directory]

    {
      acl: "public-read",
      awsAccessKeyId: Rails.application.secrets.aws_access_key_id,
      bucket: AwsSettings.bucket,
      "Cache-Control" => "max-age=630720000, public",
      "Content-Type" => type,
      expires: expiry,
      key: "#{directory}/#{RandomFilename.new(type).generate}",
      policy: encoded_policy,
      signature: signature,
      success_action_status: "201"
    }
  end

  private

  def encoded_policy
    Base64.strict_encode64(policy.to_json)
  end

  def policy
    {
      expiration: expiry,
      conditions: [
        { bucket: AwsSettings.bucket },
        { acl: "public-read" },
        { expires: expiry },
        { success_action_status: "201" },
        ["starts-with", "$key", ""],
        ["starts-with", "$Content-Type", ""],
        ["starts-with", "$Cache-Control", ""],
        ["content-length-range", 0, 524288000]
      ]
    }
  end

  def signature
    Base64.strict_encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new("sha1"),
        Rails.application.secrets.aws_secret_access_key,
        encoded_policy
      )
    )
  end
end
