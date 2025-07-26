# db/seeds.rb
require 'csv'
require 'net/http'
require 'uri'

puts "Importing airports..."

# Download OurAirports data if not exists
airports_file = Rails.root.join('tmp', 'airports.csv')
unless File.exist?(airports_file)
  puts "Downloading airports data..."
  uri = URI('https://davidmegginson.github.io/ourairports-data/airports.csv')
  response = Net::HTTP.get(uri)

  # Force UTF-8 encoding and handle invalid characters
  utf8_content = response.force_encoding('UTF-8')
                        .encode('UTF-8', invalid: :replace, undef: :replace, replace: '')

  File.write(airports_file, utf8_content, encoding: 'UTF-8')
end

# Batch processing configuration
BATCH_SIZE = 1000
airports_batch = []
processed_count = 0

def private_jet_capable?(row)
  return false if %w[heliport seaplane_base closed].include?(row['type'])
  return false if row['elevation_ft'].to_i > 8000

  %w[large_airport medium_airport small_airport].include?(row['type'])
end

def normalize_airport_data(row)
  {
    iata_code: row['iata_code'].presence&.strip&.upcase,
    icao_code: row['ident'].presence&.strip&.upcase,
    name: row['name']&.strip,
    city: row['municipality']&.strip,
    country: row['iso_country']&.strip,
    country_code: row['iso_country']&.strip&.upcase,
    latitude: row['latitude_deg'].to_f,
    longitude: row['longitude_deg'].to_f,
    elevation_ft: row['elevation_ft'].to_i,
    type: row['type'],
    private_jet_capable: private_jet_capable?(row),
    timezone: row['timezone']&.strip,
    created_at: Time.current,
    updated_at: Time.current
  }
end

def process_batch(batch)
  return if batch.empty?

  # Get existing airports by ICAO code for upsert logic
  icao_codes = batch.map { |a| a[:icao_code] }.compact
  existing_airports = Airport.where(icao_code: icao_codes)
                            .pluck(:icao_code, :id)
                            .to_h

  # Separate into creates and updates
  creates = []
  updates = []

  batch.each do |airport_data|
    icao = airport_data[:icao_code]

    if icao && existing_airports[icao]
      # Update existing
      updates << airport_data.merge(id: existing_airports[icao])
    else
      # Create new
      creates << airport_data
    end
  end

  # Batch insert new records
  if creates.any?
    Airport.insert_all(creates, returning: false)
    puts "  Created #{creates.size} airports"
  end

  # Batch update existing records
  if updates.any?
    Airport.upsert_all(
      updates,
      unique_by: :id,
      returning: false
    )
    puts "  Updated #{updates.size} airports"
  end
end

# Process CSV in batches with proper encoding
CSV.foreach(airports_file, headers: true, encoding: 'UTF-8') do |row|
  # Skip invalid records
  next if row['name'].blank? || row['ident'].blank?

  begin
    airport_data = normalize_airport_data(row)
    airports_batch << airport_data
    processed_count += 1

    # Process batch when full
    if airports_batch.size >= BATCH_SIZE
      process_batch(airports_batch)
      airports_batch.clear
      puts "Processed #{processed_count} records..."
    end
  rescue => e
    puts "Skipping row #{processed_count}: #{e.message}"
    next
  end
end

# Process final batch
process_batch(airports_batch)

total_airports = Airport.count
private_jet_airports = Airport.private_jet_capable.count

puts "Import complete!"
puts "Total airports: #{total_airports}"
puts "Private jet capable: #{private_jet_airports}"
puts "Coverage: #{(private_jet_airports.to_f / total_airports * 100).round(1)}%"

# Clean up
File.delete(airports_file) if File.exist?(airports_file)
