class CreateModaConfigBundle
  def call
    create_bundle_dir
    create_meta_file
    lint_all_the_things
    add_all_files_to_bundle
  end

  def lint_all_the_things
    puts "No linting performed..."
  end

  def add_all_files_to_bundle
    add_meta_file_to_bundle
    add_moda_files_to_bundle
    add_kubernetes_files_to_bundle
  end

  def add_kubernetes_files_to_bundle
    kube_filenames = Dir[File.join('config/kubernetes', '', '**/*.{yaml,yml}')]

    kube_filenames.each do |filename|
      add_file_to_bundle filename
    end
  end

  def add_moda_files_to_bundle
    moda_filenames = Dir[File.join('config/moda', '', '**/*.{yaml,yml}')]

    moda_filenames.each do |filename|
      add_file_to_bundle filename
    end
  end

  def tmp_dir
    'tmp'
  end

  def create_bundle_dir
    system "mkdir -p #{tmp_dir}/moda-artifacts"
  end

  def create_meta_file
    File.open meta_file_location, 'w+' do |f|
      f.puts "name: #{meta_name}"
      f.puts "owner: #{meta_owner}"
      f.puts "origin: #{meta_origin}"
      f.puts "sha: #{meta_sha}"
      f.puts "timestamp: #{meta_timestamp}"
    end
  end

  def add_meta_file_to_bundle
    add_file_to_bundle meta_file_location if File.exists? meta_file_location
  end

  def meta_file_location
    "#{tmp_dir}/meta"
  end

  def add_file_to_bundle filename
    system "tar -rvhf #{tar_archive_location} #{filename}"
  end

  def meta_name
    @meta_name ||= 'hi' #step_env['BUILD_NWO'].split('/').last
  end

  def meta_origin
    @meta_origin ||= 'hi' #"https://github.com/#{step_env["BUILD_NWO"]}.git"
  end

  def meta_owner
    @meta_owner ||= 'hi' #step_env['BUILD_NWO'].split('/').first
  end

  def meta_sha
    'hi' #step_env['BUILD_SHA']
  end

  def meta_timestamp
    @timestamp ||= Time.now.strftime('+%F:%T(%z)')
  end

  def tar_archive_location
    "#{tmp_dir}/moda-artifacts/#{meta_name}@#{meta_sha}.tar"
  end
end

CreateModaConfigBundle.new.call
