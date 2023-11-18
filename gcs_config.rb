require "google/cloud/storage"

module GCSConfig
  def self.storage
    Google::Cloud::Storage.new(
      project_id: "project-kriptografi-jawa",
      credentials: "credentials.json"
    )
  end

  def self.bucket
    storage.bucket "bucketappkripto"
  end
end
