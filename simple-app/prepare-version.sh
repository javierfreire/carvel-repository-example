if [ -z "$1" ]; then
  echo "version required"
else
  mkdir -p bundle/.imgpkg
  kbld -f bundle/ --imgpkg-lock-output bundle/.imgpkg/images.yml > /dev/null
  ytt -f bundle/config/values.yml \
      --data-values-schema-inspect \
      -o openapi-v3 > schema-openapi.yml
  ytt -f package-template.yml \
      --data-value-file openapi=schema-openapi.yml \
      -v version="$1" \
      -v bundle="ghcr.io/javierfreire/simple-app.corp.org:$1" \
      > package.yaml
  rm schema-openapi.yml
fi
