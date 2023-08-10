#!/usr/bin/env bash

curl -Lso go.tar.gz https://go.dev/dl/go1.20.4.darwin-amd64.tar.gz
echo "698ef3243972a51ddb4028e4a1ac63dc6d60821bf18e59a807e051fee0a385bd go.tar.gz" | shasum -a 256 -c -
mkdir -p gobuild/golang gobuild/gopath gobuild/gocache
tar -C gobuild/golang -xzf go.tar.gz
rm go.tar.gz
export GOPATH="$PWD/gobuild/gopath"
export GOCACHE="$PWD/gobuild/gocache"
export GO_LANG="$PWD/gobuild/golang/go/bin"
export GO_COMPILED="$GOPATH/bin"
export PATH="$GO_LANG:$GO_COMPILED:$PATH"
go version
go install fyne.io/fyne/v2/cmd/fyne\@v2.3.5
$GO_COMPILED/fyne version
if [[ $# -eq 0 ]]; then
	$GO_COMPILED/fyne package -os android -release -appID com.github.howeyc.crocgui -icon metadata/en-US/images/icon.png
	zip -d crocgui.apk "META-INF/*"
else
	$GO_COMPILED/fyne package -os android -appID com.github.howeyc.crocgui -icon metadata/en-US/images/icon.png
fi
chmod -R u+w gobuild
rm -rf gobuild
