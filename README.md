# ReactiveCoordinator
ReactiveCoordinator is a framework based on the Coordinator pattern. Implemented in RxSwift

## Requirements

- iOS 11.0
- Swift 5

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate ReactiveCoordinator into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'ReactiveCoordinator', '4.0.0'
```

## How To Use

Inherit from ReactiveCoordinator in Coordinator subclasses:

```swift
class HolidaysCoordinator: ReactiveCoordinator<Void> {
    
    let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        
        let viewController = HolidaysViewController()
        let viewModel = HolidaysViewModel()
        viewController.viewModel = viewModel
        
        rootViewController.navigationController?.pushViewController(viewController, animated: true)
        
        return Observable.empty()
    }
    
}
```

## Replace Delegation with ReactiveCoordinator

In presented Coordinator:

```swift
enum ChooseCountryCoordinationResult {
    case country(String)
    case cancel
}

class ChooseCountryCoordinator: ReactiveCoordinator<ChooseCountryCoordinationResult> {
    
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<CoordinationResult> {
        let viewController = ChooseCountryViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let viewModel = ChooseCountryViewModel()
        viewController.viewModel = viewModel
        
        let country = viewModel.selectedCountry.map { CoordinationResult.country($0) }
        let cancel = viewModel.didClose.map { _ in
            CoordinationResult.cancel
        }
        
        rootViewController.present(navigationController, animated: true, completion: nil)
        
        return Observable.merge(country, cancel)
            .take(1)
            .do(onNext: { _ in
                viewController.dismiss(animated: true, completion: nil)
            })
    }
    
}
```

In presenting Coordinator:

```swift
class HolidaysCoordinator: ReactiveCoordinator<Void> {
    
    let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        
        let viewController = HolidaysViewController()
        let viewModel = HolidaysViewModel()
        viewController.viewModel = viewModel
        
        viewModel.chooseCountry
            .flatMap { [weak self] _ -> Observable<String?> in
                guard let `self` = self else { return .empty() }
                return self.coordinateToChooseCountry()
        }
        .filter { $0 != nil }
        .map { $0! }
        .bind(to: viewModel.selectedCountry)
        .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    // MARK: - Coordination
    private func coordinateToChooseCountry() -> Observable<String?> {
        let chooseCountryCoordinator = ChooseCountryCoordinator(rootViewController: rootViewController)
        return coordinate(to: chooseCountryCoordinator)
            .map { result in
                switch result {
                case .country(let country): return country
                case .cancel: return nil
                }
        }
    }
    
}
```

## License

ReactiveCoordinator is released under the MIT license. [See LICENSE](https://github.com/zafarivaev/ReactiveCoordinator/blob/master/LICENSE) for details.
