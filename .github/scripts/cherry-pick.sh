#!/bin/bash
git config --global user.email "$GITBOT_EMAIL"
git config --global user.name "$GITHUB_ACTOR@users.noreply.github.com"

git remote update
git fetch --all


BRANCH_NAME="cherry-pick-$TARGET_BRANCH-$GITHUB_SHA"
git checkout -b $BRANCH_NAME origin/$TARGET_BRANCH
git cherry-pick -m 1 --strategy=recursive --strategy-option=theirs $GITHUB_SHA
git push -u origin $BRANCH_NAME


echo "open PR"
PR_TITLE="[cherry-pick] $(git log -1 --format="%s" ${GITHUB_SHA})"
PR_MSG="Cherry picking #$PR_ID into [**$TARGET_BRANCH**] branch"

curl -v -X POST \
    -H "Authorization: token $GITHUB_TOKEN" \
    -d '{"title": "'"$PR_TITLE"'", "body": "'"$PR_MSG"'", "head": "'"$BRANCH_NAME"'", "base": "'"$TARGET_BRANCH"'"}' \
    "https://api.github.com/repos/$GITHUB_REPOSITORY/pulls"

# Create a pull request
PR_JSON=$(curl -s -X POST \
    -H "Authorization: token $GITHUB_TOKEN" \
    -d '{"title": "'"$PR_TITLE"'", "body": "'"$PR_MSG"'", "head": "'"$BRANCH_NAME"'", "base": "'"$TARGET_BRANCH"'"}' \
    "https://api.github.com/repos/$GITHUB_REPOSITORY/pulls")

NEW_PR_URL=$(echo $PR_JSON | grep '"url"' | grep pulls | cut -d'"' -f4)
echo "add labels to $NEW_PR_URL"
NEW_PR_ID=$(basename $NEW_PR_URL)
curl -s -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$NEW_PR_ID/labels \
  -d '{"labels":["cherry-pick","00 - Ask for Review on Green"]}'


