# ios-collectionView-customLayout
Collection View layout customization

customize navigation bar

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey:     Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // customize navigation bar
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = AppColors.theme.getColor()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        // customize status bar
        UIApplication.shared.statusBarStyle = .lightContent
        
        // customize table view
        UITableView.appearance().separatorColor = AppColors.theme.getColor()
        
        // get window
        let layout  = MylivnLayout()
        let vc = MainCollectionViewController(collectionViewLayout: layout)
        layout.delegate = vc
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        
        return true
    }

### Download Manager
### Image Caching
### Wiggle Animation
### Custom Collection View Layout


## Screenshots

![simulator screen shot - iphone x - 2018-08-29 at 21 23 17](https://user-images.githubusercontent.com/4557961/44799590-f1520900-abd1-11e8-9d31-6bd5bbe1bc6d.png)

![simulator screen shot - iphone x - 2018-08-29 at 21 23 23](https://user-images.githubusercontent.com/4557961/44799596-f6af5380-abd1-11e8-81cc-9b412c7b1e71.png)

![simulator screen shot - iphone x - 2018-08-29 at 21 23 28](https://user-images.githubusercontent.com/4557961/44799602-fb740780-abd1-11e8-8ba7-178647507a12.png)

![simulator screen shot - iphone x - 2018-08-29 at 21 23 49](https://user-images.githubusercontent.com/4557961/44799609-ffa02500-abd1-11e8-98d3-48fbe8ea13e5.png)
