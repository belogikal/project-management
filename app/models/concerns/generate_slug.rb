module GenerateSlug
  def generate_slug
    self.slug = name.parameterize
  end
end
