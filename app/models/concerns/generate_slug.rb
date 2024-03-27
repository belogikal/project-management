module GenerateSlug
  def generate_slug
    return unless name

    self.slug = name.parameterize
  end
end
