$LOAD_PATH.unshift File.expand_path("lib", __dir__)

require "jekyll-responsive-image/version"

Gem::Specification.new do |spec|
    spec.name          = "jekyll-responsive-image"
    spec.version       = Jekyll::ResponsiveImage::VERSION
    spec.authors       = ["Carter Pape", "Joseph Wynn"]
    spec.email         = ["jekyll-responsive-image@carterpape.com"]
    spec.summary       = "Responsive image management for Jekyll"
    spec.homepage      = "https://github.com/wildlyinaccurate/jekyll-responsive-image"
    spec.license       = "GPL-3.0-or-later"
    spec.description   = %q{
        Highly configurable Jekyll plugin for managing responsive images. Automatically
        resizes images and provides a Liquid template tag for loading the images with
        picture, img srcset, Imager.js, etc.
    }
    
    spec.files         = `git ls-files lib *.md`.split("\n")
    spec.platform      = Gem::Platform::RUBY
    spec.require_paths = ["lib"]
    
    spec.add_dependency "jekyll"
    spec.add_dependency "rmagick"
    spec.add_dependency "jekyll-include-tag-parsing"
end
