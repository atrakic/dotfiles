## Types
# API relevant changes:
# feat Commits, that adds a new feature
# fix Commits, that fixes a bug
# refactor Commits, that rewrite/restructure your code, however does not change any behaviour
# perf Commits are special refactor commits, that improves performance
# style Commits, that do not affect the meaning (white-space, formatting, missing semi-colons, etc)
# test Commits, that add missing tests or correcting existing tests
# docs Commits, that affect documentation only
# build Commits, that affect build components like build tool, ci pipeline, dependencies, project version, ...
# ops Commits, that affect operational components like infrastructure, deployment, backup, recovery, ...
# chore Miscellaneous commits e.g. modifying .gitignore


## examples
git commit -m 'build(release): bump project version to <version>'
git commit -m 'build(release): bump version to 1.0.0'
git commit -m 'build: update dependencies'
git commit -m 'doc(release): create <version> change log entry'
git commit -m 'feat(shopping cart): add the amazing button'
git commit -m 'fix: add missing parameter to service call'
git commit -m 'refactor: implement calculation method as recursion'
git commit -m 'style: remove empty line'

git commit --allow-empty -m "chore: release 2.0.0" -m "Release-As: 2.0.0"

git tag -m'build(release): <version>' '<version-prefix><version>'
