class InstallGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def copy_locale
    copy_file "#{gem_path}/lib/responders/locales/en.yml", "responders.en.yml"
  end

  private
  def gem_path
    @gem_path ||= gem_spec.full_gem_path
  end

  def gem_spec
    @gem_spec ||= Gem::Specification.find_by_name 'responders'
  end
end
