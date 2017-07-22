import PackageDescription

let package = Package(  
	name: "SwiftBot",  
	targets: [
        Target(
            name:"Mapper",
            dependencies:[]),
        Target(
            name:"BotsKit",
            dependencies:[]),
        Target(
            name:"Facebook",
            dependencies:["Mapper", "BotsKit", "ReplyService"]),
        Target(
            name:"ReplyService",
            dependencies:["BotsKit"]),
        Target(
            name: "EchoBot",
            dependencies:["BotsKit"]),
        // Bot implementation on perfect framework
        Target(
            name:"PerfectBot",
            dependencies:["Facebook","EchoBot"])
    ],  
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 2),
        .Package(url: "https://github.com/IBM-Swift/Health.git", majorVersion: 0),
        // Common
        .Package(url: "https://github.com/IBM-Swift/SwiftKueryMySQL", majorVersion: 0),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger", majorVersion: 1)
    ],
  exclude:["Scripts"]       
)
