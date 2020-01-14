Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "ReactiveCoordinator"
s.summary = "ReactiveCoordinator is a Reactive framework based on the Coordinator pattern."
s.requires_arc = true

# 2
s.version = "4.0.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Zafar Ivaev" => "z.ivaev@mail.ru" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/zafarivaev/ReactiveCoordinator"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/zafarivaev/ReactiveCoordinator.git",
             :tag => "#{s.version}" }

# 7
s.dependency 'RxSwift'

# 8
s.source_files = "ReactiveCoordinator/**/*.{swift}"

# 9

# 10
s.swift_version = "5.0"

end