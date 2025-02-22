git shortlog -s ${1-} |
cut -b8- | # strip the commit counts
sort | uniq | cat

# 显示作者和邮箱
# git shortlog --email --format="%an####<%ae>" | xargs -I {} echo {} | grep "####" | sort | uniq | awk -F "####" '{ print $1 $2 }'

git log --format="%aN <%aE>" | sort -u

