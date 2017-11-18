Pod::Spec.new do |s|
  s.name         = "GoogleBooksClient"

  `xcodebuild -project GoogleBooksClient.xcodeproj -showBuildSettings` =~ /CURRENT_PROJECT_VERSION = ((\d\.)+\d)/
  abort("No version detected") if $1.nil?
  s.version = $1

  s.summary      = "A simple API Client for Google's Book API."
  s.description  = <<-DESC
  Google Books is an effort to make book content more discoverable on the Web.
  GoogleBooksClient gives you access to book information in your Swift project. Search for books and display information about specific books.
                   DESC

  s.homepage     = "https://github.com/opfeffer/GoogleBooksClient"
  s.license      = "MIT"
  s.author       = { "Oli Pfeffer" => "oliver.pfeffer@gmail.com" }
  s.source       = { :git => "https://github.com/opfeffer/GoogleBooksClient.git", :tag => "#{s.version}" }

  s.platform     = :ios, "10.0"
  s.source_files = "Sources/**/*.swift"

  s.dependency "Moya", "~> 10.0"
  s.dependency "Alamofire", "~> 4.5" # this shouldn't be necessary, should it?! getting Undefined Symbols errors without it :shrug:q
end
