module Datomic
  def self.download_url(license_type, version)
    if license_type == "pro"
      "https://my.datomic.com/repo/com/datomic/datomic-pro/#{version}/datomic-pro-#{version}.zip"
    else
      "https://my.datomic.com/downloads/free/#{version}"
    end
  end

  def self.download_auth(license_email, license_download_key)
    if !license_email.empty? && !license_download_key.empty?
      "--http-user=#{license_email} --http-password=#{license_download_key}"
    end
  end
end
