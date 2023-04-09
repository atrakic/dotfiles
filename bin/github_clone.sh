repo="$1"
prefix="https:\/\/github.com\/"
suffix=".git"
stripped=$(echo "$repo"|sed -e "s/^$prefix//" -e "s/$suffix$//")
git clone "$repo" "$stripped"
