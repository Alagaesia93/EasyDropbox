# frozen_string_literal: true

module ApplicationHelper
  def cloudfront_url_for(active_storage_item)
    unsigned_url = Rails.application.credentials.dig(:cloudfront, :base_url) + '/' + active_storage_item.blob.key
    policy = create_policy(unsigned_url, 10.minutes)

    signer = Aws::CloudFront::UrlSigner.new(
      key_pair_id: Rails.application.credentials.dig(:cloudfront, :key_pair_id),
      private_key: Rails.application.credentials.dig(:cloudfront, :private_key)
    )
    signer.signed_url(
      unsigned_url,
      policy: policy.to_json
    )
  end

  private

  def create_policy(unsigned_url, end_time)
    {
      "Statement": [
        {
          "Resource": unsigned_url,
          "Condition": {
            "DateLessThan": {
              "AWS:EpochTime": (DateTime.current + end_time).to_i
            }
          }
        }
      ]
    }
  end
end
