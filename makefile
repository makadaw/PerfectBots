# Makefile for SwiftBot
.DEFAULT_GOAL := build

# Few shortcuts for swift package manager

install:
	Scripts/install.py Sources/SwiftBot/config.swift

generate:
	swift package -Xlinker -L/usr/local/lib generate-xcodeproj 

test:
	swift test -Xlinker -L/usr/local/lib

build:
	swift build -Xlinker -L/usr/local/lib
	
lint:
	@if which swiftlint >/dev/null; then swiftlint; else echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"; fi	

debug:
	if [ "$(brew services list mysql | grep '^mysql' | awk '{print $$2}')" == "started" ]; then brew services start mysql ; mysql -uroot <<<"CREATE DATABASE IF NOT EXISTS swiftbot" ; fi
	.build/debug/PerfectBot
