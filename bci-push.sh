#!/bin/sh

make ORG=bcibase TAG="v3.4.0-build20220419" BUILD_META="-build20220419" image-push
make ORG=bcibase TAG="v3.4.0-build20220419" BUILD_META="-build20220419" image-manifest

make ORG=bcibase TAG="v3.3.1-build20211008" BUILD_META="-build20211008" image-push
make ORG=bcibase TAG="v3.3.1-build20211008" BUILD_META="-build20211008" image-manifest
