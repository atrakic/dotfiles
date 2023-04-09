# https://stackoverflow.com/questions/15292391/is-it-possible-to-perform-a-grep-search-in-all-the-branches-of-a-git-project
git grep -i foo `git for-each-ref --format='%(refname)' refs/`
