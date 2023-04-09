this_branch="$(git rev-parse --abbrev-ref HEAD)"

git diff remotes/origin/main "$(git rev-parse --abbrev-ref HEAD)" -- | diff-so-fancy -
# git diff remotes/origin/PIP-3125 "$(git rev-parse --abbrev-ref HEAD)"  -- | diff-so-fancy - |less
