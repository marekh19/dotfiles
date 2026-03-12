function gtagv --description 'Create annotated git tag from package.json version'
    set -l pkg_version (node -p 'require("./package.json").version' 2>/dev/null)

    if test $status -ne 0 -o -z "$pkg_version"
        echo "Could not read version from package.json" >&2
        return 1
    end

    git tag -a "v$pkg_version" -m "v$pkg_version"
end
